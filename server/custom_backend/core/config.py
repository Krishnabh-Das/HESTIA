import os
from re import template
from dotenv import load_dotenv

from jose import jwt
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer

from fastapi.templating import Jinja2Templates

from pydantic_settings import BaseSettings
from fastapi_mail import ConnectionConfig

from utils.logingUtils import logger

load_dotenv()


# App config
class Settings(BaseSettings):
    app_name: str = "Hestia backend"
    admin_email: str = "proypabsab@gamil.com"


settings = Settings()

# CORS config
origins = ["*"]
allow_credentials = (True,)
# allow_methods=,
allow_headers = ["Content-Type", "Authorization", "Set-Cookie"]

# Cryptygraphic config
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Email Configs
conf = ConnectionConfig(
    MAIL_USERNAME=str(os.getenv("MAIL_USERNAME")),  # type: ignore
    MAIL_PASSWORD=str(os.getenv("MAIL_PASSWORD")),  # type: ignore
    MAIL_FROM=str(os.getenv("MAIL_USERNAME")),  # type: ignore
    MAIL_PORT=int(os.getenv("MAIL_PORT")),  # type: ignore
    MAIL_SERVER="smtp.gmail.com",
    MAIL_FROM_NAME="Desired Name",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True,
    VALIDATE_CERTS=True
)

# Templates Configs
templates = Jinja2Templates(
    directory="templates"
)