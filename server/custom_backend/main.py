import os
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from schemas.chatSchema import chatSchema
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
async def create_item(chat: chatSchema):
    """
    Endpoint to handle query to chatbots and generate responses.

    Args:
        chat (chatSchema): Chat schema containing user and question.

    Returns:
        JSONResponse: Response containing the generated reply or an error message.
    """
    question = chat.question
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
    