#!/bin/sh
# pre_build.sh
# lzham-xcode
# FIXME need to work around pervasive __is_pod build issue

ORIGLINE="#if defined(__APPLE__) || defined(__NetBSD__)"
TARGETPATH="lzham_codec/lzhamdecomp/lzham_traits.h"

grep "^$ORIGLINE" "$TARGETPATH"
if [ $? = 0 ]; then
    echo "Replacing problem line..."
    sed \
        -i '' \
        -e "s/^$ORIGLINE/#if 0 \/\/ lzham-xcode FIXME, was $ORIGLINE/" \
        "$TARGETPATH"
else
    echo "Problem line not found. Presumably hacked elsewhere."
fi
