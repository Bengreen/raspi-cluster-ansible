from urllib.parse import urlparse

from pydantic import BaseSettings
from ipaddress import IPv4Address


class Settings(BaseSettings):
    """
    See https://pydantic-docs.helpmanual.io/#settings for details on using and overriding this
    """
    name = 'gatewayserver'
    auth_key = 'RlWPSxCDUDILOevgHp2Z-qu3anE8YKmpszZJUz9lLFs='
    cookie_name = 'testme'
    imageDir = '/images'
    HOST: IPv4Address = "0.0.0.0" 
    PORT: int = "8080"