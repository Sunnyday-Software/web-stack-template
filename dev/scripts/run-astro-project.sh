#!/usr/bin/env bash

#
set -e

echo "script $0"

source "$(dirname "$0")/env.sh"
echo "Astro project: ${astro_project_name}"
astro_full_path="${astro_path}/${astro_project_name}"

check_container;

cd ${astro_full_path}

npm install
npm run dev