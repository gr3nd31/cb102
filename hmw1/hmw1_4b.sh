#!/bin/bash

export x=$(echo $(cat $1 | grep -v ">" | tr -d "\n" | wc -c)/$(cat NC_000913.faa | grep ">" | wc -l) | bc)

echo "The average amino acid length of proteins found in "$1" is "$x"."
