from pprint import pformat
from langchain.schema import Document
from langchain_community.document_loaders import SeleniumURLLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from .vectorSearch import vector_store
from main import logger


def loadURLdata(
    url_list: list,
):
    """
    Load data from a list of URLs using SeleniumURLLoader.

    Args:
        url_list (list): List of URLs to load.

    Returns:
        list: List of pages loaded from the URLs.
    """
    data_loader = SeleniumURLLoader(urls=url_list)
    pages = data_loader.load()
    return pages


def loaderToDoc(
    pages,
    chunk_size: int = 5000,
    chunk_overlap: int = 0,
):
    """
    Convert pages into a list of Document objects using RecursiveCharacterTextSplitter.

    Args:
        pages: List of pages to convert.
        chunk_size (int, optional): Size of text chunks. Defaults to 5000.
        chunk_overlap (int, optional): Overlap between text chunks. Defaults to 0.

    Returns:
        list: List of Document objects.
    """
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size, chunk_overlap=chunk_overlap
    )
    context = "\n\n".join(str(p.page_content) for p in pages)
    texts = text_splitter.split_text(context)
    text = [Document(page_content=x) for x in texts]
    return text


def addDocVectorStore(
    text: list,
):
    """
    Add documents to the vector store.

    Args:
        text (list): List of Document objects.
    """
    for t in text:
        inserted_ids = vector_store.add_documents([t])


def querySimilarSearch(question: str, k: int = 4):
    """
    Query the vector store for similar documents based on a given question.

    Args:
        question (str): Query question.
        k (int, optional): Number of similar documents to retrieve. Defaults to 3.

    Returns:
        list: List of page content from similar documents.
    """
    docs = vector_store.similarity_search(question, k=k)
    docs_str = [str(x.page_content) for x in docs]
    logger.debug(pformat(docs_str))
    return docs_str


def getResponse(conversation, context: list[str], question: str):
    """
    Get a response from the llm based on the provided context and question.

    Args:
        conversation: Language model conversation chain.
        context (list[str]): List of context strings.
        question (str): Question for the conversation.

    Returns:
        str: Response from the conversation.
    """
    return conversation({"context": context, "question": question})

def getResponseUncontext(conversation, question: str):
    """
    Get a response from the llm based on the provided context and question.

    Args:
        conversation: Language model conversation chain.
        context (list[str]): List of context strings.
        question (str): Question for the conversation.

    Returns:
        str: Response from the conversation.
    """
    return conversation({"question": question})
