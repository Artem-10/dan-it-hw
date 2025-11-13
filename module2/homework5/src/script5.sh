#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 source_file destination"
    exit 1
fi

source_file=$1
destination=$2

if [ ! -e "$source_file" ]; then
    echo "Error: source file '$source_file' does not exist."
    exit 1
fi

mv "$source_file" "$destination"

if [ "$?" -eq 0 ]; then
    echo "File successfully moved from '$source_file' to '$destination'."
else
    echo "Failed to move the file."
fi