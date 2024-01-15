import os
from datetime import datetime
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from schemas.userSchema import userId
from schemas.utilsSchema import getLocSchema
from schemas.chatSchema import chatSchema, urlContextSchema

from configs.db import firestoreDB

from docs.metadata import tags_metadata

from utils.GeoLoc import geoLoc
from utils.ragPipeline import addDocVectorStore, getResponse, loaderToDoc, querySimilarSearch, loadURLdata
from utils.llmHelper import FireStoreInitiate, GetLLMChain, GetPromptTemplate, GetSummaryMemory, model

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
    user     = chat.user
    # add question to firebase chat
    try:
        message_history = FireStoreInitiate(
            user_id=user,
            session_id=user
        )
        summary_memory = GetSummaryMemory(
            llm=model,
            chat_memory=message_history,
        )
        conversation = GetLLMChain(
            llm=model,
            memory=summary_memory,
            prompt=GetPromptTemplate()
        )
        docs = querySimilarSearch(
            question=question,
        )
        res = getResponse(
            conversation=conversation,
            context=docs,
            question=question
        )
        # add response to firebase chat
        res_json = {"reply":res['text']}
        return JSONResponse(content=res_json, status_code=200) 
    except Exception as e:
        # Handle exceptions or validation errors and return an appropriate HTTP response code.
        error_message = {"detail": f"An error occurred: {str(e)}"}
        return JSONResponse(content=error_message, status_code=500)

@app.put("/chat/add_context/byURL", tags=["Chatbot"])
async def add_contest_URL(urlContext: urlContextSchema):
    """
    Endpoint to add a contest context by providing a URL.

    Args:
    - `urlContext` (urlContextSchema): Schema containing URL and user ID.

    Returns:
    - JSONResponse: Response indicating success or failure.\n
            - If successful, returns a JSON object with the message: `{"Response": "Successfully added to Context"}`
            - If an error occurs during Firestore storage, returns a JSON object with an error message:
                `{"detail": "Unable to store Source to Firestore: Error Message"}`
            - If an error occurs during Vectorstore storage, returns a JSON object with an error message:
                `{"detail": "Unable to store Source to Vectorstore: Error Message"}`
    """
    url = urlContext.url
    user_id = urlContext.user_id
    current_datetime = datetime.now()
    current_datetime_str = current_datetime.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    try:
        data = {
            "type":'URL',
            "source": url,
            "User_id": user_id
        }
        CSL_ref = firestoreDB.collection("Chatbot_source_list").document(current_datetime_str)
        CSL_ref.set(data)
    except Exception as e:
        error_message = {"detail": f"Unable to store Source to Firestore: {str(e)}"}
        return JSONResponse(
            content=error_message, 
            status_code=500
        )
    try:
        pages = loadURLdata([url])
        text = loaderToDoc(pages)
        addDocVectorStore(text=text)
        return JSONResponse(content={"Response": "Successfully add to Context"}, status_code=200) 
    except Exception as e:
        error_message = {"detail": f"Unable to store Source to Vectorstore: {str(e)}"}
        return JSONResponse(
            content=error_message, 
            status_code=500
        )
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
        res_json = {"address":locname.address} #type:ignore
        return JSONResponse(content=res_json, status_code=200) 
    except Exception as e:
        error_message = {"detail": f"An error occurred: {str(e)}"}
        return JSONResponse(content=error_message, status_code=500)

# --------------------------  User Services  ----------------------------#
@app.post("/user/getNamebyID", tags=['Users'])
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
        doc = firestoreDB.collection('Users').document(id).collection('Profile').get()
        # print(doc[0].to_dict()['name'])
        res_json = {"name": doc[0].to_dict()['name']}
        return JSONResponse(
            content=res_json, 
            status_code=200
        ) 
    except Exception as e:
        error_message = {"detail": f"An error occurred: {str(e)}"}
        return JSONResponse(
            content=error_message, 
            status_code=500
        )