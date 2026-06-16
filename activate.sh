#!/usr/bin/env bash
# Usage (from project root):  source ./activate.sh
source .venv/bin/activate     # turn on the virtual environment
set -a                        # mark following vars for export
source .env                   # load TRINO_* etc. into the shell
set +a
export DBT_PROFILES_DIR=/Users/alenapatel/dbt-playground/ae_playground
echo "Environment activated (venv + .env)."