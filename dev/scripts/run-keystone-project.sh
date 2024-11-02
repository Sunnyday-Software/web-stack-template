#!/usr/bin/env bash

#
set -e

source "$(dirname "$0")/env.sh"

check_container;

cd ${keystone_path}

npm install
npm run dev