#!/usr/bin/env bash

#
set -e

source "$(dirname "$0")/env.sh"

check_container;

cd application/keystone/core
npm install
npm run dev