from datetime import datetime, timedelta
import json
import traceback

from fastapi.responses import HTMLResponse, JSONResponse
from fastapi import APIRouter, HTTPException, Request, Response, status
from grpc import Status
from pydantic import EmailStr

import core.config as config

from db.models.user import User
from db.mongodb_connect import NotUniqueError

from schemas.authUtilSchema import change_passed, rePass
from schemas.userschemas import LoginRequestBody, newUser

from utils.authUtils import authenticate_user, create_access_token, get_password_hash, verify_token
from utils.emailUtils import send_email, send_password_reset_email

router = APIRouter(prefix="/auth")

@router.post("/signup")
async def signup(new_user: newUser) -> JSONResponse:
    """
    Register a new user.

    Parameters:
    - new_user (newUser): The data for creating a new user.

    Returns:
    - JSONResponse: A JSON response containing a message and user type.

    Raises:
    - 401, JSONResponse: If the email or phone number already has an account (status code 400).
    - 501, JSONResponse: If any other error occurs during the registration process (status code 500).
    - 502, JSONResponse: If any other error occurs during the sending verification mail (status code 502).
    """
    if new_user.user_type is None:
        new_user.user_type = "ngo"
    try:
        user:User = User(
            fname=new_user.fname,
            lname=new_user.lname,
            email=new_user.email,
            phone_number=new_user.phone_number,
            password=get_password_hash(new_user.password),
            user_type=new_user.user_type,
            joined_at=datetime.now()
        )
        user.save()
    except NotUniqueError:
        error_message = {
            "detail": f"Email or phone number already has an account.",
        }
        return JSONResponse(content=error_message, status_code=401) # type: ignore
    except Exception as e:
        traceback_str: str = traceback.format_exc()
        error_message: dict[str, str] = {
            "detail": f"An error occurred: {str(e)}",
            "traceback": traceback_str,
        }
        return JSONResponse(content=error_message, status_code=501)  # type: ignore
    try:
        access_token: str = create_access_token(
            data={"sub": user.email}, expires_delta=timedelta(minutes=30)
        )
        await send_email([user.email], token=access_token) # type: ignore
        return JSONResponse({
            "message": f"New user, {user.fname} with mail {user.email} added",
            "user_type": user.user_type,
        })
    except Exception as e:
        traceback_str = traceback.format_exc()
        error_message = {
            "detail": f"An error occurred : {str(e)}",
            "traceback": traceback_str,
        }
        return JSONResponse(content=error_message, status_code=502)
    
@router.post("/signup_admin")
async def signup_admin(newUser: newUser):
    """
    Register a new user with the 'admin' user type.

    Parameters:
    - newUser (newUser): The data for creating a new user.

    Returns:
    - JSONResponse: A JSON response containing a message and user type.

    Raises:
    - 401, JSONResponse: If the email or phone number already has an account (status code 401).
    - 501, JSONResponse: If any other error occurs during the registration process (status code 501).
    - 502, JSONResponse: If any other error occurs during the sending verification mail (status code 502).
    """
    if newUser.user_type is None:
        newUser.user_type = 'admin'
    try:
        user = User(
            fname=newUser.fname,
            lname=newUser.lname,
            email=newUser.email,
            phone_number=newUser.phone_number,
            password=get_password_hash(newUser.password),
            user_type=newUser.user_type,
            joined_at=datetime.now()
        )
        user.save()
    except NotUniqueError:
        error_message = {
            "detail": f"Email or phone number already has an account.",
        }
        return JSONResponse(content=error_message, status_code=401) # type: ignore
    except Exception as e:
        traceback_str = traceback.format_exc()
        error_message = {
            "detail": f"An error occurred: {str(e)}",
            "traceback": traceback_str,
        }
        return JSONResponse(content=error_message, status_code=501)  # type: ignore
    try:
        access_token = create_access_token(
            data={"sub": user.email}, expires_delta=timedelta(minutes=30)
        )
        await send_email([user.email], token=access_token) # type: ignore
        return JSONResponse({
            "message": f"New user, {user.fname} with mail {user.email} added",
            "user_type": user.user_type,
        })
    except Exception as e:
        traceback_str = traceback.format_exc()
        error_message = {
            "detail": f"An error occurred : {str(e)}",
            "traceback": traceback_str,
        }
        return JSONResponse(content=error_message, status_code=502)
    
@router.post("/login")
async def login(request_body: LoginRequestBody, response: Response) -> dict[str, str|int]| None:
    """
    Log in a user.

    Parameters:
    - request_body (LoginRequestBody): The login request body containing email and password.
    - response (Response): The FastAPI Response object for setting cookies.

    Returns:
    - dict: A dictionary containing the access token, user email, and user type.
      If authentication fails, returns None.

    Raises:
    - HTTPException: If incorrect email or password is provided (status code 400).
    """
    email = request_body.email
    password = request_body.password

    if authenticate_user(email, password):
        access_token = create_access_token(
            data={"sub": email}, expires_delta=timedelta(minutes=30)
        )
        user = json.loads(User.objects.get(email=email).to_json()) # type: ignore
        response.set_cookie(
            key="access_token",
            value=access_token,
            expires=timedelta(minutes=30), # type: ignore
            httponly=True,  # This ensures the cookie is only accessible via HTTP
            samesite="lax",  # Adjust this according to your security needs
        )
        return {"token": access_token, "user": email, "user_type":f"{user['user_type']}" }
    else:
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    
@router.delete("/logout")
async def logout(response: Response) -> JSONResponse:
    """
    Log out a user.

    Parameters:
    - response (Response): The FastAPI Response object for deleting cookies.

    Returns:
    - JSONResponse: A json containing a message confirming successful logout.
    """
    response.delete_cookie(
        key="access_token",
        path="/",
    )
    return JSONResponse({"message": "Logged out successfully"})

@router.get("/verification", response_class=HTMLResponse)
async def email_verification(request: Request, token:str):
    """
    Endpoint for email verification.

    Parameters:
        - request (Request): The incoming request.
        - token (str): The verification token.

    Returns:
        TemplateResponse: HTML page displaying verification status.
        
    Raises:
        HTTPException: If the user is already verified.
    """
    user:User = await verify_token(token=token)
    if user and not user.is_verified:
        user.is_verified = True
        user.save()
        context = {
            "request": request,
            "is_verified": user.is_verified,
            "username": user.fname
        }
        return config.templates.TemplateResponse(
            "verification.html",
            context
        )
    elif user.is_verified:
        raise HTTPException(
        status_code=status.HTTP_412_PRECONDITION_FAILED,
        detail="Already verified",
        headers={"WWW-Authenticate": "Bearer"}
    )
        
@router.put("/reset_pass")
async def reset_pass(RePass:rePass) -> JSONResponse:
    """
    Endpoint to initiate the password reset process.

    Parameters:
        - RePass (RePass): The input model containing the email address.
        - response (Response): The HTTP response object.
        - token (str): The token, obtained from the email.

    Returns:
        JSONResponse: JSON response indicating the success or failure of the password reset initiation.
    """
    email:EmailStr = RePass.email # type: ignore
    try:
        access_token:str = create_access_token(
            data={"sub": email}, expires_delta=timedelta(minutes=30)
        )
        await send_password_reset_email(email=email, token=access_token)
        message:dict = {
            "detail": f"Successfully sent prest pasword mail.",
        }
        return JSONResponse(content=message, status_code=200)
    except Exception as e:
        traceback_str: str = traceback.format_exc()
        error_message:dict = {
            "detail": f"An error occurred : {str(e)}",
            "traceback": traceback_str,
        }
        return JSONResponse(content=error_message, status_code=500)
        
@router.put("/change_pass")
async def change_pass(change_pass_bdy:change_passed):
    """
    Endpoint to change the user's password.

    Parameters:
        - change_pass_bdy (change_passed): The input model containing the token and new password.

    Returns:
        JSONResponse: JSON response indicating the success or failure of the password change.
    """
    token:str = change_pass_bdy.token
    password:str = change_pass_bdy.password
    try:
        user:User = verify_token(token=token) # type: ignore
    except Exception as e:
        error_message:dict = {
            "detail": f"An error occurred : {str(e)}",
        }
        return JSONResponse(content=error_message, status_code=status.HTTP_401_UNAUTHORIZED)
    try:
        user.password = get_password_hash(password=password)
        user.save()
    except Exception as e:
        error_message:dict = {
            "detail": f"An error occurred : {str(e)}",
        }
        return JSONResponse(content=error_message, status_code=501)