import traceback
from pprint import pformat
from datetime import datetime

from fastapi import APIRouter
from fastapi.responses import JSONResponse

from schemas.chatSchema import chatSchema, urlContextSchema

from db.fireStoreDB import firestoreDB

from utils.logingUtils import logger
from utils.ragPipeline import (
    addDocVectorStore,
    getResponse,
    getResponseUncontext,
    loaderToDoc,
    querySimilarSearch,
    loadURLdata,
)
from utils.llmHelper import (
    FireStoreInitiate,
    GetAppInstrPromptTemplate,
    GetLLMChain,
    GetPromptTemplate,
    GetSummaryMemory,
    checkTypeQuestion,
    model,
)

router = APIRouter(prefix="/chat")

@router.post("/send")
async def chat_send(chat: chatSchema):
    """
    Endpoint to handle query to chatbots and generate responses.

    Args:
    - `chat` (chatSchema): Chat schema containing user and question.

    Returns:
    - JSONResponse: Response containing the generated reply or an error message.
    """
    logger.info("/chat/send: Route triggered")
    question = str(chat.question).lower()
    logger.critical(question)
    user = chat.user

    try:
        QuestionTypeJson = checkTypeQuestion(query=question)
        # logger.info(pformat(QuestionTypeJson))
        logger.info("Question checked")
        
        if QuestionTypeJson["question_type"] == "STATS":
            res_json = {"reply": "Not Implemented yet."}
            logger.info("Question type STATS")
            return JSONResponse(content=res_json, status_code=200)
        
        if QuestionTypeJson["question_type"] == "APP_USAGE":
            logger.info("Question type APP_USAGE")
            message_history = FireStoreInitiate(user_id=user, session_id=user+"_APP_Info")
            summary_memory = GetSummaryMemory(
                llm=model,
                chat_memory=message_history,
            )
            logger.info("/chat/send: summary_memory iniated")
            conversation = GetLLMChain(
                llm=model, memory=summary_memory, prompt=GetAppInstrPromptTemplate()
            )
            logger.info("/chat/send: conversation stated")
            res = getResponseUncontext(conversation=conversation, question=question)
            res_json = {"reply": res["text"]}
            return JSONResponse(content=res_json, status_code=200)

        if QuestionTypeJson["question_type"] == "OTHER":
            logger.info("Question type OTHER")
            message_history = FireStoreInitiate(user_id=user, session_id=user)
            summary_memory = GetSummaryMemory(
                llm=model,
                chat_memory=message_history,
            )
            logger.info("/chat/send: summary_memory iniated")
            conversation = GetLLMChain(
                llm=model, memory=summary_memory, prompt=GetPromptTemplate()
            )
            logger.info("/chat/send: conversation stated")
            docs = querySimilarSearch(
                question=question,
            )
            logger.info("/chat/send: Similarity search stated")

            res = getResponse(conversation=conversation, context=docs, question=question)

            res_json = {"reply": res["text"]}
            return JSONResponse(content=res_json, status_code=200)

    except Exception as e:
        traceback_str = traceback.format_exc()
        error_message = {
            "detail": f"An error occurred: {str(e)}",
            "traceback": traceback_str,
        }
        logger.critical(pformat(error_message))
        return JSONResponse(content=error_message, status_code=500)

@router.put("/add_context_byURL")
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
