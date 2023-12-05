#!/usr/bin/env python

import setuptools
import os


def find_version():
    tag = os.environ.get("TAG", "0.0.0")
    return tag


setuptools.setup(
    name="gateway",
    version=find_version(),
    description="aio based python System Service for Image serving",
    author="Ben Greene",
    author_email="BenJGreene@gmail.com",
    url="https://www.undefined.com",
    packages=setuptools.find_packages(),
    include_package_data=True,
    package_data={
        'gateway': [
            'templates/*',
            'static/*',
        ],
    },
    zip_safe=False,
    install_requires=[
        "aiohttp",
        "aiohttp-jinja2",
        "aiohttp-session",
        "pydantic",
        "python-systemd",
        "requests",
        "click",
        "pydantic-settings",
    ],
    extras_require={
        "dev": [
            "pytest-aiohttp",
        ]
    },
    entry_points={
        "console_scripts": ["gateway = gateway.cli:cli"],
    },
)
