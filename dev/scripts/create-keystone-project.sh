#!/usr/bin/env bash

#
set -e

source "$(dirname "$0")/env.sh"

check_container;

mkdir -p $(dirname "${keystone_path}")

npm create keystone-app@${keystone_version} --yes ${keystone_path}
cd ${keystone_path}

npm install

jq \
'
.scripts.telemetry_disable="keystone telemetry disable"
|.scripts.build= "keystone build"
|.scripts.dev= "keystone dev"
|.scripts.postinstall= "keystone postinstall"
|.scripts.generate= "keystone prisma migrate dev"
|.scripts.start= "keystone start --with-migrations"
|.scripts.deploy= "keystone build && keystone prisma migrate deploy"
' package.json \
 > package_modified.json && mv package_modified.json package.json

npm run telemetry_disable

