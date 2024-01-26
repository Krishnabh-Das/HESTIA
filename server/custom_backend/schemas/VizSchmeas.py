from pydantic import BaseModel

class coordSchema(BaseModel):
    lat:float
    lon:float