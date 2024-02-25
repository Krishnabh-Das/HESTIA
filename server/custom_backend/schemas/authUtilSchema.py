from pydantic import BaseModel, EmailStr

class rePass(BaseModel):
    email: EmailStr
    
class change_passed(BaseModel):
    token:str
    password:str