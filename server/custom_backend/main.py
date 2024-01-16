import os
import traceback
from datetime import datetime
from venv import logger
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException, WebSocket, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from schemas.userSchema import userId
from schemas.utilsSchema import getLocSchema
from schemas.chatSchema import chatSchema, urlContextSchema
from schemas.adminSchmeas import Initator

from configs.db import firestoreDB, firestore

from docs.metadata import tags_metadata

# from loggingUtil.logshandeller import logGenerator
from utils.datetimeUtils import (
    startEndTime, 
    testStarttime
)
from utils.GeoLoc import (
    geoLoc
)
from utils.ragPipeline import (
    addDocVectorStore,
    getResponse,
    loaderToDoc,
    querySimilarSearch,
    loadURLdata,
)
from utils.llmHelper import (
    FireStoreInitiate,
    GetLLMChain,
    GetPromptTemplate,
    GetSummaryMemory,
    model,
)
from utils.regionMapHelper import (
    addNewRegionMaps,
    createCoordinateCluster,
    get_dict_by_regionMapId,
    get_marker_cord_by_id,
    get_marker_cord_by_id_tuple,
    getParings,
    getRegionmapDB,
    markersDB,
    select_bounding_coords,
    GeoPoint,
)

# ------------------------ Init FastAPI -------------------------#
app = FastAPI(openapi_tags=tags_metadata)

# --------------------------- Config ----------------------------#
load_dotenv()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

start_date, end_date = startEndTime()


# ---------------------------  Chat  ----------------------------#
@app.post("/chat/send", tags=["Chatbot"])
async def chat_send(chat: chatSchema):
    """
    Endpoint to handle query to chatbots and generate responses.

    Args:
    - `chat` (chatSchema): Chat schema containing user and question.

    Returns:
    - JSONResponse: Response containing the generated reply or an error message.
    """
    question = str(chat.question).lower()
    print(question)
    user = chat.user
    # add question to firebase chat
    try:
        message_history = FireStoreInitiate(user_id=user, session_id=user)
        summary_memory = GetSummaryMemory(
            llm=model,
            chat_memory=message_history,
        )
        conversation = GetLLMChain(
            llm=model, memory=summary_memory, prompt=GetPromptTemplate()
        )
        docs = querySimilarSearch(
            question=question,
        )
        res = getResponse(conversation=conversation, context=docs, question=question)
        # add response to firebase chat
        res_json = {"reply": res["text"]}
        return JSONResponse(content=res_json, status_code=200)
    except Exception as e:
        # Handle exceptions or validation errors and return an appropriate HTTP response code.
        traceback_str = traceback.format_exc()
        error_message = {"detail": f"An error occurred: {str(e)}",
                         "traceback":traceback_str}
        return JSONResponse(content=error_message, status_code=500)


@app.put("/chat/add_context/byURL", tags=["Chatbot"])
async def add_context_URL(urlContext: urlContextSchema):
    """
    Endpoint to add a contest context by providing a URL.

    Args:
    - `urlContext` (urlContextSchema): Schema containing URL and user ID.

    Returns:
    - JSONResponse: Response indicating success or failure.
        - If successful, returns a JSON object with the message:
        {"Response": "Successfully added to Context"}`
        - If an error occurs during Firestore storage, returns a JSON object with an error message:
        {"detail": "Unable to store Source to Firestore: Error Message"}
        - If an error occurs during Vectorstore storage, returns a JSON object with an error message:
        {"detail": "Unable to store Source to Vectorstore: Error Message"}
    """
    url = urlContext.url
    user_id = urlContext.user_id
    current_datetime = datetime.now()
    current_datetime_str = current_datetime.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    try:
        data = {"type": "URL", "source": url, "User_id": user_id}
        CSL_ref = firestoreDB.collection("Chatbot_source_list").document(
            current_datetime_str
        )
        CSL_ref.set(data)
    except Exception as e:
        error_message = {"detail": f"Unable to store Source to Firestore: {str(e)}"}
        return JSONResponse(content=error_message, status_code=500)
    try:
        pages = loadURLdata([url])
        text = loaderToDoc(pages)
        addDocVectorStore(text=text)
        return JSONResponse(
            content={"Response": "Successfully add to Context"}, status_code=200
        )
    except Exception as e:
        error_message = {"detail": f"Unable to store Source to Vectorstore: {str(e)}"}
        return JSONResponse(content=error_message, status_code=500)


# --------------------------  Utils  ----------------------------#
@app.post("/location/get", tags=["Utils"])
async def location_get(getLoc: getLocSchema):
    """
    Get location information based on latitude and longitude.

    Parameters:
    - `getLoc` (lat:str, lon:str): A Pydantic BaseModel representing the input data with latitude and longitude.

    Returns:
    - JSONResponse: A FastAPI JSONResponse object containing either the address information or an error message.
        - If successful, returns a JSON object with the address information:
            {"address": "Formatted Address"}
        - If an error occurs, returns a JSON object with an error message:
            {"detail": "An error occurred: Error Message"}

    Example:
    ```
    # Example request:
    # POST /location/get
    # Request body: {"lat": 40.7128, "lon": -74.0060}

    # Example response (success):
    # Status Code: 200 OK
    {
        "address": "New York, NY, USA"
    }

    # Example response (error):
    # Status Code: 500 Internal Server Error
    {
        "detail": "An error occurred: Some error message"
    }
    ```
    """
    lat = getLoc.lat
    lon = getLoc.lon
    try:
        locname = geoLoc.reverse(f"{lat}, {lon}")
        res_json = {"address": locname.address}  # type:ignore
        return JSONResponse(content=res_json, status_code=200)
    except Exception as e:
        error_message = {"detail": f"An error occurred: {str(e)}"}
        return JSONResponse(content=error_message, status_code=500)


# --------------------------  User ----------------------------#
@app.post("/user/getNamebyID", tags=["Users"])
async def User_Name(userId: userId):
    """
    Get user name by user ID.

    Parameters:
    - `userId` (id:str): A Pydantic BaseModel representing the input data with the user ID.

    Returns:
    - JSONResponse: A FastAPI JSONResponse object containing the user name or an error message.
        - If successful, returns a JSON object with the user name:
            {"name": "User Name"}
        - If an error occurs, returns a JSON object with an error message:
            {"detail": "An error occurred: Error Message"}
    """
    id = userId.id
    print(id)
    try:
        doc = firestoreDB.collection("Users").document(id).collection("Profile").get()
        # print(doc[0].to_dict()['name'])
        res_json = {"name": doc[0].to_dict()["name"]}
        return JSONResponse(content=res_json, status_code=200)
    except Exception as e:
        error_message = {"detail": f"An error occurred: {str(e)}"}
        return JSONResponse(content=error_message, status_code=500)


# --------------------------  Admin  ----------------------------#


@app.put("/admin/regionMapGen", tags=["Admin"])
def regionMapGen(Initator: Initator):   
    """
    Endpoint to generate region maps and update Firestore.  
    
    Args:
    - `Initator` (Initator): Schema containing the initiator's ID.

    Returns:
    - JSONResponse: Response indicating success or failure.
    """
    try:
        markers_ = markersDB(start_date, end_date)
        # logger.info(markers_)
        if len(markers_) <2:
            error_message = {"detail": f"An error occurred: Not enough markers"}
            return JSONResponse(content=error_message, status_code=500)
        regionMaps_get, regionMaps = getRegionmapDB()  # type: ignore
        parings = getParings(markers_, regionMaps)
        for key in parings.keys():
            result_dict = get_dict_by_regionMapId(regionMaps, parings[key])
            ref = firestoreDB.collection("RegionMap").document(parings[key])

            result_dict["coords"].append(get_marker_cord_by_id_tuple(markers_, key))  # type: ignore

            try:
                list_bbox = select_bounding_coords(result_dict["coords"])  # type: ignore

                not_list_box = [GeoPoint(x[0], x[1]) for x in result_dict["coords"] if GeoPoint(x[0], x[1]) not in list_bbox]  # type: ignore
            except Exception as e:
                error_message = {"detail": f"An error occurred: {str(e)}"}
                return JSONResponse(content=error_message, status_code=500)

            average_latitude = sum(lat for lat, lon in result_dict["coords"]) / len(result_dict["coords"])  # type: ignore
            average_longitude = sum(lon for lat, lon in result_dict["coords"]) / len(result_dict["coords"])  # type: ignore

            central_coord = GeoPoint(average_latitude, average_longitude)
            ref.update(
                {
                    "central_coord": central_coord,
                    "coords": firestore.ArrayUnion([get_marker_cord_by_id(markers_, key)]),  # type: ignore
                    "markers": firestore.ArrayUnion([key]),  # type: ignore
                }
            )
            if len(not_list_box) > 0:
                ref.update(
                    {
                        "coords": firestore.ArrayRemove(not_list_box),  # type: ignore
                    }
                )

        filtered_markers = [marker for marker in markers_ if marker["marker-id"] not in parings.keys()]  # type: ignore

        coordinates = [entry["marker_cord"] for entry in filtered_markers]

        coordinate_clusters = createCoordinateCluster(coordinates)  # type: ignore
        
        region_data = addNewRegionMaps(coordinate_clusters, markers_)
        
        try:
            current_datetime = datetime.now()
            current_datetime_str = current_datetime.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            data = {"timStamp": current_datetime_str, "User_id": Initator.id}
            CSL_ref = firestoreDB.collection("RegionMap_logs").add(data)
        except Exception as e:
            traceback_str = traceback.format_exc()
            error_message = {"detail": f"An error occurred: {str(e)}",
                             "traceback":traceback_str}
            return JSONResponse(content=error_message, status_code=500)

        return JSONResponse(content={"res":"done"}, status_code=200)
    except Exception as e:
        traceback_str = traceback.format_exc()
        error_message = {"detail": f"An error occurred: {str(e)}",
                         "traceback":traceback_str}
        return JSONResponse(content=error_message, status_code=500)
