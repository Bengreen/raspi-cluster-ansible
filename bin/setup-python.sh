#!/bin/bash
# if venv does not exist then create it
if [ ! -d venv ]; then
    python3 -m venv venv
fi
# activate the virtual environment
source venv/bin/activate
# check if requests is already installed
if python -c "import requests" &> /dev/null; then
    echo "requests is already installed"
else
    echo "installing requests"
    pip install requests click
fi
