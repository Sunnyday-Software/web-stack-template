#!/usr/bin/env bash
set -e

source "$(dirname "$0")/../../.env"

if [ ! -f "./application/.init.touch" ]; then
    echo "Error: run 'project init' before"
    exit 1
fi