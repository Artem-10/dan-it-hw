#!/bin/bash

echo "enter the filename"

if [ -e "$filename" ]; then
        echo "the $filename is here"
else
        echo "the $filename isnt here"
fi