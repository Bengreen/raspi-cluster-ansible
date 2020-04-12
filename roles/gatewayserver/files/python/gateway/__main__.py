import sys

from .main import create_app
import logging
from aiohttp import web

def main(argv):
    """
    This is the entrypoint for running in production mode
    """
 
    logging.basicConfig(level=logging.DEBUG)

    app = create_app()

    web.run_app(app,
                host=str(app['settings'].HOST),
                port=app['settings'].PORT)

main(sys.argv[1:])
