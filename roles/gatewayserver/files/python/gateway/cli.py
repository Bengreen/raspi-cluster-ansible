#!/home/ben.greene/venv/bin/python
import click
import requests

@click.group()
def cli():
    pass



@cli.command()
@click.option('--host', default='localhost', help='Hostname of server')
@click.option('--port', default=8080, help='port of server')
def ping(host, port):
    """Check connection to gateway server"""
    hostUrl="http://%s:%s" % (host, port)
    click.echo('Ping: %s' % (hostUrl))

    r=requests.get(hostUrl)

    click.echo(r)

@cli.command()
@click.option('--host', default='localhost', help='Hostname of server')
@click.option('--port', default=8080, help='port of server')
def images(host, port):
    """Check the images available on gateway"""
    hostUrl="http://%s:%s" % (host, port)
    click.echo('Images on: %s' % (hostUrl))

    r=requests.get("%s/images" % (hostUrl))

    click.echo(r.text)

@cli.group()
def imaging():
    pass


@imaging.command()
@click.option('--host', default='localhost', help='Hostname of server')
@click.option('--port', default=8080, help='port of server')
@click.argument('serial')
def create(host, port, serial):
    """Create an imaging request for a serial number"""
    hostUrl="http://%s:%s" % (host, port)

    click.echo("Create imaging: %s" % serial)
    r=requests.post("%s/imaging/" % (hostUrl), json={"serialNumber": serial})
    click.echo(r.text)


@imaging.command()
@click.option('--host', default='localhost', help='Hostname of server')
@click.option('--port', default=8080, help='port of server')
@click.argument('serial')
def delete(host, port, serial):
    """Delete an imaging request for a serial number"""
    hostUrl="http://%s:%s" % (host, port)

    click.echo("Delete imaging: %s" % serial)
    r=requests.delete("%s/imaging/%s" % (hostUrl, serial))
    click.echo(r.text)


@imaging.command()
@click.option('--host', default='localhost', help='Hostname of server')
@click.option('--port', default=8080, help='port of server')
@click.argument('serials', nargs=-1)
def get(host, port, serials):
    """Check the nodes allocated to imaging"""
    hostUrl="http://%s:%s" % (host, port)

    if serials:
        click.echo("Getting info for: %s" % ", ".join(serials))
        for serial in serials:
            r=requests.get("%s/imaging/%s" % (hostUrl, serial))
            click.echo(r.text)
    else:
        r=requests.get("%s/imaging/" % (hostUrl))
        sources=r.json()['imaging']

        if sources:
            click.echo(", ".join(sources))
        else:
            click.echo("No imaging")




if __name__ == '__main__':
    cli()
