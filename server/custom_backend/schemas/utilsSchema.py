from pydantic import BaseModel

class getLocSchema(BaseModel):
    lat:str
    lon:str