#!/bin/bash

echo "enter the filename"

read filename

if [ -e "$filename" ]; then
        cat $filename
else
        echo "the $filename isnt here"
fi