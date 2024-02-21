import os
import json
from pydantic import Json
from dotenv import load_dotenv

import google.generativeai as genai

from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain.chains.conversation.memory import ConversationSummaryMemory

from langchain_community.chat_message_histories.firestore import (
    FirestoreChatMessageHistory,
)
from docs.appDocs import APP_INFO

from utils.logingUtils import logger

load_dotenv()

genai.configure(api_key=os.environ.get("GOOGLE_API_KEY"))

model = ChatGoogleGenerativeAI(model="gemini-pro", temperature=0.7)  # type: ignore
embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")  # type: ignore



def FireStoreInitiate(
    user_id: str,
    session_id: str,
    collection_name: str = "Chat_message",
):
    """
    Initialize and return FirestoreChatMessageHistory for storing chat messages.

    Args:
        user_id (str): User ID for the chat history.
        session_id (str): Session ID for the chat history.
        collection_name (str, optional): Collection name for Firestore. Defaults to "Chat_message".

    Returns:
        FirestoreChatMessageHistory: Firestore chat message history
    """
    message_history = FirestoreChatMessageHistory(
        collection_name=collection_name, session_id=session_id, user_id=user_id
    )
    return message_history


def GetStatesCheckerPromptTemplate():
    """
    Analyzes the question and checks if the user wants to know about current homelessness stats and of which region.
    Returns a PromptTemplate that can be used to prompt the user for the required information.
    The template contains a JSON schema that must be used for the response.
    """
    checkTypePrompt = PromptTemplate(
        input_variables=[
            "question",
        ],
        template=(
            """
        Analyse the question and check if the user wants to know about current homelessness stats and of which region answer in valid json schema as mebntioned in ### below.
        !!! dont use \n in json formating:
        ###
            "is_current_stats": true|false,
            "is_homelessness_stats": true|false,
            "need_stats_of": world|country|state|current_location,
            "state_name": none|name,
            "country_name": none|name,
        ###
        
        Question:{question}\n
        """
        ),
    )
    return checkTypePrompt


def GetQuestionTypePromptTemplate():
    """
    Analyzes the question and checks what the user wants to know about.

    Args:
        question (str): The user's question.

    Returns:
        PromptTemplate: A PromptTemplate object that can be used to prompt the user for the required information.
    """
    check_type_prompt = PromptTemplate(
        input_variables=["question"],
        template=(
            """
        Analyse the question and check what the user wants to know about.
        !!! dont use \\n in json formating:
        ###
            "question_type": "STATS"| "APP_USAGE"| "OTHER",
        ###

        Question: {question}
        """
        ),
    )
    return check_type_prompt


def GetPromptTemplate():
    """
    Create and return a PromptTemplate for generating prompts.

    Returns:
        PromptTemplate: Prompt template
    """
    prompt = PromptTemplate(
        input_variables=["history", "context", "question"],
        template=(
            """Act a a guide who answers queries regarding homelessness use the history and context to provide well informed answers, if dont know the
            answer as well as te context and history dont know it reply "I am nor aware of it yet", if the data is not in context just tell"contact your 
            support team for more answers" dont't mention any thing reading context or historoy in your reply saying that"result not context or history".


        Context:{context}\n
        Question:{question}\n
        """
        ),
    )
    return prompt

def GetAppInstrPromptTemplate():
    """
    Create and return a PromptTemplate for generating prompts regarding App Instaruction.

    Returns:
        PromptTemplate: Prompt template
    """
    prompt = PromptTemplate(
        input_variables=["history", "question"],
        template=(
            f"""You are the chatbot section of a APP named Hestia you are responsible to answer any question regarding the working of our app based on the Section in ### ###, if dont know the answer as well as the ### ### and history dont know it reply "I am nor aware of it yet", if the data is not in context just tell"contact your  support team for more answers" dont't mention any thing reading context or historoy in your reply saying that"result not context or history".

            ### 
            {APP_INFO}
            ###
        Question:{{question}}
        """
        ),
    )
    return prompt

def GetSummaryMemory(
    llm,
    chat_memory,
    memory_key: str = "history",
    input_key: str = "question",
):
    """
    Create and return ConversationSummaryMemory for managing conversation summaries.

    Args:
        llm: Language model for conversation.
        chat_memory: Chat memory for storing conversation history.
        memory_key (str, optional): Key for accessing conversation history in memory. Defaults to "history".
        input_key (str, optional): Key for accessing input in memory. Defaults to "question".

    Returns:
        ConversationSummaryMemory: Conversation summary memory
    """
    summary_memory = ConversationSummaryMemory(
        llm=llm, memory_key=memory_key, input_key=input_key, chat_memory=chat_memory
    )
    return summary_memory


def GetLLMChain(
    llm,
    memory,
    prompt,
    verbose: bool = False,
):
    """
    Create and return LLMChain for managing language model-based conversations.

    Args:
        llm: Language model for conversation.
        verbose (bool): Verbosity flag.
        memory: Memory object for storing conversation history.
        prompt: Prompt template for generating prompts.

    Returns:
        LLMChain: Language model chain for conversation
    """
    conversation = LLMChain(llm=llm, memory=memory, verbose=verbose, prompt=prompt)
    return conversation


def GetCkeckerLLMChain(
    llm,
    prompt,
    verbose: bool = False,
) -> LLMChain:
    """
    Create and return LLMChain for managing language model-based conversations.

    Args:
        llm (LanguageModel): Language model for conversation.
        prompt (PromptTemplate): Prompt template for generating prompts.
        verbose (bool, optional): Verbosity flag.

    Returns:
        LLMChain: Language model chain for conversation
    """
    conversation = LLMChain(llm=llm, prompt=prompt, verbose=verbose)
    return conversation


def chatResponseStrTojson(chatResponse: str) -> Json:
    """
    Extracts the JSON object from a chat response string.

    Args:
        chatResponse (str): The chat response string.

    Returns:
        Json: The JSON object.
    """
    # Extract the JSON string from the provided string
    json_string = (
        chatResponse.replace("('```json\n'", "")
        .replace("`", "")
        .replace("'", "")
        .replace("\n", "")
        .strip()
    )

    # Replace escaped characters
    json_string = json_string.replace("\\n", "\n").replace("\\t", "\t")
    json_string = json_string.split("json{")[-1].strip()

    # Load the JSON object
    json_object = json.loads(json_string)

    return json_object


def queryStatsAnsweer(
    query: str,
) -> Json:
    """
    This function uses a trained language model to answer questions about homelessness statistics.

    Args:
        query (str): The question to be answered.

    Returns:
        str: The answer to the question.
    """
    chain = GetCkeckerLLMChain(llm=model, prompt=GetStatesCheckerPromptTemplate())
    stuff_answer = chain({"question": query})
    return chatResponseStrTojson(stuff_answer["text"])


def checkTypeQuestion(
    query: str,
) -> Json:
    chain = GetCkeckerLLMChain(llm=model, prompt=GetQuestionTypePromptTemplate())
    stuff_answer = chain({"question": query})
    logger.debug(stuff_answer["text"])
    return chatResponseStrTojson(stuff_answer["text"])
