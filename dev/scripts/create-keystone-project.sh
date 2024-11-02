#!/usr/bin/env bash

#
set -e

source "$(dirname "$0")/env.sh"

check_container;

npm create keystone-app@${keystone_version} --yes application/keystone/core