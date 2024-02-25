import os
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

load_dotenv()

genai.configure(api_key=os.environ.get("GOOGLE_API_KEY"))

model = ChatGoogleGenerativeAI(model="gemini-pro", temperature=0.3)  # type: ignore
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
