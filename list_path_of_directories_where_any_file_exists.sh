#!/bin/sh
find $1 -type f -printf '%h\n' | sort -u | sed "s|^|$PWD/|"
