from google.cloud import storage

def getClusterStorageStep3(GCP_PROJECT_NAME:str):
    """
    Get the Google Cloud Storage client for the given GCP project.

    Args:
        GCP_PROJECT_NAME (str): The name of the Google Cloud Platform project.

    Returns:
        storage.Client: The Google Cloud Storage client.
    """
    storage_client = storage.Client(GCP_PROJECT_NAME)
    print(type(storage_client))
    return storage_client
    