import os

from fastapi_mail import FastMail, MessageSchema
from pydantic import EmailStr

from schemas.emailSchema import EmailSchema
import core.config as core

from utils.logingUtils import logger
from utils.authUtils import jwt


async def send_email(email: EmailSchema, token: str) -> None:
    """
    Send an email for account verification.

    Parameters:
        - email (str): The email address of the recipient.
        - token (str): The verification token to be included in the verification link.

    Returns:
        None
    """
    logger.debug(jwt.decode(token=token, key=core.SECRET_KEY, algorithms=[core.ALGORITHM])) # type: ignore
    template = f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>
    <body>
        <div style="display: flex; align-items:center; justify-content: center; flex-direction:column">
            <h3>Account Verification </h3>
            <br>
            <p> Thanks for Joining us. please click on the button below to verify <p>
            
            <a style="margin-top: 1 rem; padding:1rem; border-radius:0.5rem; font-size: 1rem; text-dectoration:none; background: #0275d8; color=white;" href="{os.getenv("BASE_ROUTE")}api/v2/auth/verification/?token={token}">
                Verify your mail
            </a>
        </div>

    </body>
    </html>
    """
    message = MessageSchema(
        subject="Email Verification", recipients=email, body=template, subtype="html" # type: ignore
    )

    fm = FastMail(config=core.conf)

    await fm.send_message(message=message)
    
async def send_password_reset_email(email: EmailStr, token: str) -> None:

    logger.debug(jwt.decode(token=token, key=core.SECRET_KEY, algorithms=[core.ALGORITHM])) # type: ignore
    template = f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>
    <body>
        <div style="display: flex; align-items:center; justify-content: center; flex-direction:column">
            <h3>Change pass</h3>
            <br>
            <p> Thanks for Joining us. please click on the button below to verify <p>
            
            <a style="margin-top: 1 rem; padding:1rem; border-radius:0.5rem; font-size: 1rem; text-dectoration:none; background: #0275d8; color=white;" href="{os.getenv("BASE_ROUTE")}api/v2/auth/change_pass/?token={token}">
                Verify your mail
            </a>
        </div>

    </body>
    </html>
    """
    message = MessageSchema(
        subject="Password Reset", recipients=email, body=template, subtype="html" # type: ignore
    )

    fm = FastMail(config=core.conf)

    await fm.send_message(message=message)

