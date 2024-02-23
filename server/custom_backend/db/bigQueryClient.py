import pandas as pd
from google.cloud import bigquery
from face_recognition import load_image_file

def getBigQueryTableStep3(TableID: str) -> pd.DataFrame:
    """
    This function is used to query a BigQuery table and return the results as a pandas dataframe.

    Args:
        TableID (str): The ID of the BigQuery table to query.

    Returns:
        pd.DataFrame: A pandas dataframe containing the results of the query.

    """
    client = bigquery.Client()
    query = f"""
        SELECT * FROM `{TableID}`
    """
    df = client.query(query=query).result().to_dataframe().fillna(-1)
    return df
    
