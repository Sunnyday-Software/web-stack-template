#!/usr/bin/env bash

#
set -e

echo "script $0"

source "$(dirname "$0")/env.sh"

check_container;

cd ${astro_path}

npm install
npm run dev