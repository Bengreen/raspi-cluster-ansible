from urllib.parse import urlparse

from pydantic_settings import BaseSettings
from ipaddress import IPv4Address


class Settings(BaseSettings):
    """
    See https://pydantic-docs.helpmanual.io/#settings for details on using and overriding this
    """
    name: str = 'gatewayserver'
    auth_key: str = 'RlWPSxCDUDILOevgHp2Z-qu3anE8YKmpszZJUz9lLFs='
    cookie_name: str = 'testme'
    imageDir: str = '/opt/gateway/images'
    defaultImage: str = 'DietPi_RPi-ARMv8-Bookworm.7z'
    tftpDir: str = '/tftpboot'
    HOST: IPv4Address = "0.0.0.0"
    PORT: int = "8080"
