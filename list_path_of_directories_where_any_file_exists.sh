#!/bin/sh
find $1 -type f -name '*.$2' -printf '%h\n' | sort -u | sed "s|^|$PWD/|"
