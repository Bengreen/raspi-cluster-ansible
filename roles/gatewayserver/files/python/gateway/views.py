from aiohttp.hdrs import METH_POST
from aiohttp.web_exceptions import HTTPFound
from aiohttp.web_response import Response
from aiohttp_jinja2 import template
from aiohttp_session import get_session
from pydantic import BaseModel, ValidationError, constr
from aiohttp import web, streamer
import os
import glob
from os.path import basename
import aiohttp_jinja2

@template('index.j2')
async def index(request):
    """
    This is the view handler for the "/" url.
    :param request: the request object see http://aiohttp.readthedocs.io/en/stable/web_reference.html#request
    :return: context for the template.
    """
    # Note: we return a dict not a response because of the @template decorator
    return {
        'title': request.app['settings'].name,
        'intro': "Success! you've setup a basic aiohttp app.",
    }


@streamer
async def file_sender(writer, file_path=None):
    """
    This function will read large file chunk by chunk and send it through HTTP
    without reading them into memory
    """
    with open(file_path, 'rb') as f:
        chunk = f.read(2 ** 16)
        while chunk:
            await writer.write(chunk)
            chunk = f.read(2 ** 16)

class DefaultImage(web.View):
    async def get(self):
        imageName = self.request.app['settings'].defaultImage
        location = self.request.app.router['Images'].url_for(file_name=imageName)
        raise web.HTTPFound(location=location)

class Images(web.View):
    async def get(self):
        if 'file_name' in self.request.match_info:
            file_name = self.request.match_info['file_name']  # Could be a HUGE file
            headers = {
                "Content-disposition": "attachment; filename={file_name}".format(file_name=file_name)
            }

            file_path = os.path.join(self.request.app['settings'].imageDir, file_name)

            if not os.path.exists(file_path):
                return web.Response(
                    body='File <{file_name}> does not exist'.format(file_name=file_name),
                    status=404
                )

            return web.Response(
                body=file_sender(file_path=file_path),
                headers=headers
            )
        else:
            filesOut = []
            for (dirpath, dirnames, filenames) in os.walk(self.request.app['settings'].imageDir, topdown=False):
                for  filename in filenames:
                    filesOut.append(os.path.join(dirpath, filename))
            context = { "files": filesOut}
            return aiohttp_jinja2.render_template('files.j2',
                                              self.request,
                                              context)

class Imaging(web.View):
    async def get(self):
        if 'serialNumber' in self.request.match_info:
            serialNumber = self.request.match_info['serialNumber']
            print("return info on a single imaging dir : %s" % (serialNumber))
            return web.json_response({"created": serialNumber})
        else:
            currentImaging = [basename(image) for image in 
                glob.glob(self.request.app["settings"].tftpDir+
                '/[A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9]')]

            return web.json_response({"imaging": currentImaging})
    async def delete(self):
        if 'serialNumber' not in self.request.match_info:
            print("serialNumber must be provided")
            return web.json_response({"delete": False})
        
        serialNumber = self.request.match_info['serialNumber']
        filename = os.path.join(self.request.app["settings"].tftpDir, serialNumber)
        if not os.path.islink(filename):
            print("serial number %s does not exists" % (serialNumber))
            return web.json_response({"delete": False})

        print("Deleting: %s" % (serialNumber))
        os.unlink(filename)

        return web.json_response({"delete": True})
    async def post(self):
        if 'filename' in self.request.match_info:
            print("cannot POST to an imaging record")
            return web.json_response({"post": False})
        
        serialNumber = self.request.json()["serialNumber"]
        filename = os.path.join(self.request.app["settings"].tftpDir, serialNumber)
        if os.path.exists(filename):
            print("serialNumber %s already exists" % (serialNumber))
            return web.json_response({"post": False})

        os.symlink(os.path.join(self.request.app["settings"].tftpDir,"imager"), filename)
        return web.json_response({"post": True})


class InstallConfig(web.View):
    async def get(self):
        name = self.request.match_info['name']
        context = {
            "password": "archive1",
        }
        return aiohttp_jinja2.render_template('dietpi.txt.j2',
                                              self.request,
                                              context)
        return web.json_response(config)


class Alive(web.View):
    async def get(self):
        return web.json_response({"alive": True})

