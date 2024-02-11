from pydantic import BaseModel, EmailStr

class Initator(BaseModel):
    id:str
    email:EmailStr