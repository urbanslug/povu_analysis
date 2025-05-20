#!/usr/bin/env python

import sys

def process_file(input_path):
    id_map = {}
    output_lines = []

    # First pass: build the ID map from S lines
    with open(input_path, 'r') as f:
        counter = 1
        for line in f:
            if line.startswith('S'):
                fields = line.strip().split('\t')
                if len(fields) > 1:
                    id_map[fields[1]] = str(counter)
                    counter += 1

    # Second pass: replace names using id_map
    with open(input_path, 'r') as f:
        for line in f:
            if line.startswith('S') or line.startswith('L'):
                fields = line.strip().split('\t')
                new_fields = []

                for i, field in enumerate(fields):
                    # Replace specific fields depending on S or L line
                    if line.startswith('S') and i == 1:
                        field = id_map.get(field, field)
                    elif line.startswith('L') and (i == 1 or i == 3):
                        field = id_map.get(field, field)
                    new_fields.append(field)

                print('\t'.join(new_fields))
            else:
                print(line.strip())

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file.tsv>")
        sys.exit(1)

    input_file = sys.argv[1]
    process_file(input_file)

