#!/usr/bin/env bash

ROOT="/var/www"
SRCDIR="$ROOT/src/site"
BUILDDIR="$SRCDIR/build"
DEPLOYDIR="$ROOT/site"

if [[ $JEKYLL_ENV =~ PROD ]]; then
    echo "Updating source..."
    git checkout master && git pull origin master

    echo "Cleaning $DEPLOYDIR..."
    rm -rf $DEPLOYDIR/* && mkdir -p $DEPLOYDIR

    echo "Copying build artifact to $DEPLOYDIR..."
    make -C $SRCDIR build && rsync -r $BUILDDIR/* $DEPLOYDIR/
else
    echo "Connecting to deploy server..."
    ssh ${1-"hub"} JEKYLL_ENV=PRODUCTION source $SRCDIR/deploy.sh
fi
