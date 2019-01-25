#!/usr/bin/env bash

venv="$HOME/venv"

[ -d "$venv/py3" ] || python3 -m venv "$venv/py3"

"$venv/py3/bin/pip" install --upgrade pip
"$venv/py3/bin/pip" install --upgrade awscli
