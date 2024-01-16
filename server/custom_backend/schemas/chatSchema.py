from pydantic import BaseModel

class chatSchema(BaseModel):
    question:str
    user:str
    
class urlContextSchema(BaseModel):
    url:str
    user_id:str
