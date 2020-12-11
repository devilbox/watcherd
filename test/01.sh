#!/usr/bin/env bash

set -e
set -u
set -o pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" && pwd -P )"

BIN_PATH="${SCRIPT_PATH}/.."
DIR_PATH="${SCRIPT_PATH}/dirs"



cleanup() {
	rm -rf "${DIR_PATH}" || true
	rm -rf "${SCRIPT_PATH}/01.actual" || true
	rm -rf "${SCRIPT_PATH}/01.expected" || true
}


###
### 01. Clean and create test dirs
###
cleanup
mkdir -p "${DIR_PATH}/dir 1"
mkdir -p "${DIR_PATH}/dir 2"
mkdir -p "${DIR_PATH}/dir 3"
mkdir -p "${DIR_PATH}/dir 4"
mkdir -p "${DIR_PATH}/dir 4/subdir"
touch    "${DIR_PATH}/file 1"
touch    "${DIR_PATH}/file 2"


###
### 02. Setup expected
###
{
	echo "add: ./dir 1";
	echo "add: ./dir 2";
	echo "add: ./dir 3";
	echo "add: ./dir 4";
} > "${SCRIPT_PATH}/01.expected"


###
### 03. Run watcherd
###
cd "${DIR_PATH}"
"${BIN_PATH}/watcherd" -p "." -a "echo 'add: %p'" -d "echo 'del: %p'" > "${SCRIPT_PATH}/01.actual" &
watch_pid="${!}"
echo "Started watcherd with pid: ${watch_pid}"
echo "Waiting 5 sec."
sleep 5



###
### 04 .Compare results and shutdown
###
echo "Diff results"
if ! diff "${SCRIPT_PATH}/01.actual" "${SCRIPT_PATH}/01.expected"; then
	echo "[ERR] Results did not equal"
	echo "Killing watcherd"
	kill "${watch_pid}" || true
	cleanup
	exit 1
fi

echo "[OK] Results equal."
echo "Killing watcherd"
kill "${watch_pid}" || true
cleanup
exit 0
