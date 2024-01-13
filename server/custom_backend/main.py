import os
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from schemas.userSchema import userId
from schemas.chatSchema import chatSchema
from schemas.getLocSchema import getLocSchema

from configs.db import firestoreDB

from utils.GeoLoc import geoLoc
from utils.ragPipeline import getResponse, querySimilarSearch
from utils.llmHelper import FireStoreInitiate, GetLLMChain, GetPromptTemplate, GetSummaryMemory, model
# from 

# ------------------------ Init FastAPI -------------------------#
app = FastAPI()

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
@app.post("/chat/send")
async def chat_send(chat: chatSchema):
    """
    Endpoint to handle query to chatbots and generate responses.

    Args:
        chat (chatSchema): Chat schema containing user and question.

    Returns:
        JSONResponse: Response containing the generated reply or an error message.
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
    
@app.post("/location/get")
async def location_get(getLoc: getLocSchema):
    """
    Get location information based on latitude and longitude.

    Parameters:
    - `getLoc` (getLocSchema): A Pydantic BaseModel representing the input data with latitude and longitude.

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
        res_json = {"address":locname.address}
        return JSONResponse(content=res_json, status_code=200) 
    except Exception as e:
        error_message = {"detail": f"An error occurred: {str(e)}"}
        return JSONResponse(content=error_message, status_code=500)

@app.post("/user/getNamebyID")
async def User_Name(userId: userId):
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