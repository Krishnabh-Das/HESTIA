from pydantic import BaseModel

class chatSchema(BaseModel):
    question:str
    user:str