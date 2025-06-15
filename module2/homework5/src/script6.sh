#!/bin/sh

echo "Enter a sentence:"
read sentence


reversed=$(echo "$sentence" | awk '{ for(i=NF;i>0;i--) printf("%s ", $i); print "" }')

echo "Reversed sentence:"
echo "$reversed"