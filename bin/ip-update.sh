#!/usr/bin/env python
# ip update Copyright (C) 2024 Ben Greene

# This example requires the requests library be installed.  You can learn more
# about the Requests library here: http://docs.python-requests.org/en/latest/
import requests
import click
import sys
import json
from google.oauth2 import service_account
from google.auth.transport.requests import Request



# https://stackoverflow.com/questions/242485/starting-python-debugger-automatically-on-error
def interactivedebugger(type, value, tb):
    if hasattr(sys, "ps1") or not sys.stderr.isatty():
        # we are in interactive mode or we don't have a tty-like
        # device, so we call the default hook
        sys.__excepthook__(type, value, tb)
    else:
        import traceback
        import pdb

        # we are NOT in interactive mode, print the exception...
        traceback.print_exception(type, value, tb)
        print
        # ...then start the debugger in post-mortem mode.
        # pdb.pm() # deprecated
        pdb.post_mortem(tb)  # more "modern"


@click.group()
@click.option("--debug/--no-debug", default=False)
@click.pass_context
def cli(ctx, debug):
    """
    Start a generic command with a debug option
    """
    ctx.ensure_object(dict)

    ctx.obj["DEBUG"] = debug

    if debug:
        click.echo(f"Debug mode is {'on' if debug else 'off'}", err=True)
        sys.excepthook = interactivedebugger


# ------------- CLI commands go below here -------------
hostname = 'homer.polecatworks.com'


def scoped_credentials():
    credentials = service_account.Credentials.from_service_account_file(
        '/Users/bengreene/.config/gcloud/sa/polecatworks-1f7edd9701b5.json'
    )
    scoped_credentials = credentials.with_scopes(['https://www.googleapis.com/auth/cloud-platform'])
    return scoped_credentials


def headers(scoped_credentials):

    click.echo(f'Scoped credentials: {scoped_credentials}')
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {scoped_credentials.token}'
    }
    return headers


def url():
    project_id = 'polecatworks'
    managed_zone = 'polecatworks'
    record_name = f'{hostname}.'
    record_type = 'A'
    ttl = 300

    url = f'https://dns.googleapis.com/dns/v1/projects/{project_id}/managedZones/{managed_zone}/rrsets/{record_name}/{record_type}'
    return url

def record_set(ip):

    project_id = 'polecatworks'
    managed_zone = 'polecatworks'
    record_name = f'{hostname}.'
    record_type = 'A'
    ttl = 300

    record_set = {
        "name": record_name,
        "type": record_type,
        "ttl": ttl,
        "rrdatas": [ip]
    }
    return record_set

@cli.command()
@click.pass_context
def getip(ctx):
    """
    Get the public IP address
    """

    ip = requests.get('https://api.ipify.org').content.decode('utf8')
    click.echo('My public IP address is: {}'.format(ip))


    my_scoped_credentials=scoped_credentials()
    my_scoped_credentials.refresh(Request())

    my_headers=headers(my_scoped_credentials)
    click.echo(my_headers)

    response = requests.get(url(), headers=my_headers)
    click.echo(response.json())


@cli.command()
@click.pass_context
def setip(ctx):
    """
    Set the public IP address
    """

    ip = requests.get('https://api.ipify.org').content.decode('utf8')
    click.echo('My public IP address is: {}'.format(ip))


    my_scoped_credentials=scoped_credentials()
    my_scoped_credentials.refresh(Request())

    my_headers=headers(my_scoped_credentials)
    click.echo(my_headers)

    my_url = url()

    response = requests.get(my_url, headers=my_headers)
    click.echo(response.json())


    # Using GCP REST API update CloudDNS to point to the new IP
    # https://cloud.google.com/dns/docs/reference/v1/


    record= record_set(ip)

    click.echo(f'Setting record: {record}')

    my_data = json.dumps(record)
    click.echo(f'Data: {my_data}')


    response = requests.patch(my_url, headers=my_headers, data=my_data)

    if response.status_code == 200:
        print('DNS record updated successfully.')
    else:
        print(f'Failed to update DNS record: {response.status_code} {response.text}')

    # project_id = 'polecatworks'
    # managed_zone = 'polecatworks'
    # record_name = f'{hostname}.'
    # record_type = 'A'
    # ttl = 300

    # record_set = {
    #     "name": record_name,
    #     "type": record_type,
    #     "ttl": ttl,
    #     "rrdatas": [ip]
    # }
    # click.echo(record_set)

    # credentials = service_account.Credentials.from_service_account_file(
    #     '/Users/bengreene/.config/gcloud/sa/polecatworks-1f7edd9701b5.json'
    # )
    # scoped_credentials = credentials.with_scopes(['https://www.googleapis.com/auth/cloud-platform'])
    # click.echo(scoped_credentials)

def unused():

    # Make the PUT request to update the DNS record
    url = f'https://dns.googleapis.com/dns/v1/projects/{project_id}/managedZones/{managed_zone}/rrsets/{record_name}/{record_type}'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {scoped_credentials.token}'
    }

    response = requests.put(url, headers=headers, data=json.dumps(record_set))


    if response.status_code == 200:
        print('DNS record updated successfully.')
    else:
        print(f'Failed to update DNS record: {response.status_code} {response.text}')

    credentials = service_account.Credentials.from_service_account_file(
        'path/to/your/service-account-file.json'
    )
    scoped_credentials = credentials.with_scopes(['https://www.googleapis.com/auth/cloud-platform'])



    # GET https://dns.googleapis.com/dns/v1/projects/polecatworks/managedZones/polecatworks/rrsets/homer.polecatworks.com./A
    # {
    #   "name": "homer.polecatworks.com.",
    #   "rrdatas": [
    #     "87.115.75.13"
    #   ],
    #   "ttl": 300,
    #   "type": "A"
    # }



# ------------- CLI commands above here -------------

if __name__ == "__main__":
    cli()
