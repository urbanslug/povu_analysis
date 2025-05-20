#!/usr/bin/env bash

for file in *.gfa; do
    # Skip if no .gfa files are found
    [ -e "$file" ] || continue

    # Remove the .gfa extension and add .num.gfa
    output="${file%.gfa}.num.gfa"

    # Run your Python script on each file
    python ../../to_numeric.py "$file" > "$output"
done

