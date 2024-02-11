import traceback
from fastapi import APIRouter
from fastapi.responses import JSONResponse

from db.fireStoreDB import firestoreDB

from schemas.communitySchema import ReportPost, ReportUser

from utils.logingUtils import logger

router = APIRouter(prefix="/community")

@router.post("/report_post")
async def report_post(Report: ReportPost) -> JSONResponse:
    """
    This function is used to report a post to the community moderators.

    Args:
        Report (ReportPost): The report data.

    Returns:
        JSONResponse: The response.

    Raises:
        Exception: If an error occurs.
    """
    postId = Report.postId
    description = Report.description
    reported_by = Report.reported_by
    reported_at = Report.reported_at
    report_type = Report.report_type
    try:
        data = {
            "postId": postId,
            "description": description,
            "reported_by": reported_by,
            "reported_at": reported_at,
            "report_type": report_type,
        }
        firestoreDB.collection("CommunityPostReports").add(data)
        logger.info("Report to CommunityPostReportss")
        return JSONResponse(content={"Status": "done"}, status_code=200)

    except Exception as e:
        traceback_str = traceback.format_exc()
        error_message = {
            "detail": f"An error occurred: {str(e)}",
            "traceback": traceback_str,
        }
        return JSONResponse(content=error_message, status_code=500)


@router.post("/report_user")
async def report_user(Report: ReportUser) -> JSONResponse:
    """
    This function is used to report a user to the community moderators.

    Args:
        Report (ReportUser): The report data.

    Returns:
        JSONResponse: The response.

    Raises:
        Exception: If an error occurs.
    """
    description = Report.description
    reported_by = Report.reported_by
    reported_at = Report.reported_at
    report_type = Report.report_type
    try:
        data = {
            "description": description,
            "reported_by": reported_by,
            "reported_at": reported_at,
            "report_type": report_type,
        }
        firestoreDB.collection("CommunityUserReports").add(data)
        logger.info("Report to CommunityUserReports")
        return JSONResponse(content={"Status": "done"}, status_code=200)

    except Exception as e:
        traceback_str = traceback.format_exc()
        error_message = {
            "detail": f"An error occurred: {str(e)}",
            "traceback": traceback_str,
        }
        return JSONResponse(content=error_message, status_code=500)
