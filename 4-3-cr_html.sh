#!/bin/bash

for usr in /home/*; do
    # echo $usr
    # /home/ubt
    htmldir="$usr/html"
    if [ ! -d "$htmldir" ]; then
        mkdir -p "$htmldir"
    fi

    echo "Creating index.html in $htmldir" > "$htmldir/index.html"
    chown -R $(basename $usr):$(basename $usr) "$htmldir"
done