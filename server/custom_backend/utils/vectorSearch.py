from langchain_community.vectorstores import AstraDB
from utils.llmHelper import embeddings
from db.fireStoreDB import (
    get_ASTRA_DB_COLLECTION_NAME,
    get_ASTRA_DB_API_ENDPOINT,
    get_ASTRA_DB_APPLICATION_TOKEN,
    get_ASTRA_DB_NAMESPACE,
)

vector_store = AstraDB(
    embedding=embeddings,
    collection_name=get_ASTRA_DB_COLLECTION_NAME(),
    api_endpoint=get_ASTRA_DB_API_ENDPOINT(),
    token=get_ASTRA_DB_APPLICATION_TOKEN(),
    namespace=get_ASTRA_DB_NAMESPACE(),
)
