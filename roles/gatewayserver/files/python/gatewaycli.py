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
    """Simple program that greets NAME for a total of COUNT times."""
    hostUrl="http://%s:%s" % (host, port)
    click.echo('Ping: %s' % (hostUrl))

    r=requests.get(hostUrl)

    click.echo(r)

@cli.command()
@click.option('--host', default='localhost', help='Hostname of server')
@click.option('--port', default=8080, help='port of server')
def images(host, port):
    """Simple program that greets NAME for a total of COUNT times."""
    hostUrl="http://%s:%s" % (host, port)
    click.echo('Images on: %s' % (hostUrl))

    r=requests.get("%s/images" % (hostUrl))

    click.echo(r.text)

@cli.command()
@click.option('--host', default='localhost', help='Hostname of server')
@click.option('--port', default=8080, help='port of server')
def imaging(host, port):
    """Simple program that greets NAME for a total of COUNT times."""
    hostUrl="http://%s:%s" % (host, port)

    r=requests.get("%s/imaging/" % (hostUrl))
    sources=r.json()['imaging']

    if sources:
        click.echo(", ".join(sources))
    else:
        click.echo("No imaging")




if __name__ == '__main__':
    cli()
