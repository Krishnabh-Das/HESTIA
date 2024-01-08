import os
from dotenv import load_dotenv

import firebase_admin
from firebase_admin import credentials

load_dotenv()


creds_path = "configs/serviceAccountKey.json"
cred = credentials.Certificate(creds_path)
firebase_admin.initialize_app(cred)


def get_ASTRA_DB_COLLECTION_NAME():
    """
    Retrieve the Astra DB collection name from the environment variables.

    This function fetches the Astra DB collection name stored in the
    environment variable 'ASTRA_DB_COLLECTION_NAME'.

    Args:
        None

    Returns:
        str: Astra DB collection name
    """
    return os.environ.get("ASTRA_DB_COLLECTION_NAME")


def get_ASTRA_DB_API_ENDPOINT():
    """
    Retrieve the Astra DB API endpoint URL.

    This function constructs and returns the Astra DB API endpoint URL based on
    the environment variables 'ASTRA_DB_ID' and 'ASTRA_DB_REGION'.

    Args:
        None

    Returns:
        str: Astra DB API endpoint URL
    """
    ASTRA_DB_API_ENDPOINT = f"https://{os.environ.get('ASTRA_DB_ID')}-{os.environ.get('ASTRA_DB_REGION')}.apps.astra.datastax.com"
    return ASTRA_DB_API_ENDPOINT


def get_ASTRA_DB_APPLICATION_TOKEN():
    """
    Retrieve the Astra DB application token from the environment variables.

    This function fetches the Astra DB application token stored in the
    environment variable 'ASTRA_DB_APPLICATION_TOKEN'.

    Args:
        None

    Returns:
        str: Astra DB application token
    """
    return os.environ.get("ASTRA_DB_APPLICATION_TOKEN")


def get_ASTRA_DB_NAMESPACE():
    """
    Retrieve the Astra DB namespace from the environment variables.

    This function fetches the Astra DB namespace stored in the environment
    variable 'ASTRA_DB_NAMESPACE'.

    Args:
        None

    Returns:
        str: Astra DB namespace
    """
    return os.environ.get("ASTRA_DB_NAMESPACE")
