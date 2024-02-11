from datetime import datetime
from pydantic import BaseModel

class ReportPost(BaseModel):
    postId: str
    report_type: str
    description: str
    reported_by: str
    post_by: str
    reported_at: datetime
    
class ReportUser(BaseModel):
    report_type: str
    description: str
    reported_by: str
    reported_at: datetime