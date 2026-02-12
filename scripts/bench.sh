#!/bin/bash

# Ensure DATA_DIR is set
if [[ -z "$DATA_DIR" ]]; then
    echo "ERROR: DATA_DIR environment variable is not set."
    exit 1
fi


# Define a default list of chromosomes if none are provided via command-line options
chromosomes=()

# Parse options using getopts
while getopts "c:" opt; do
    case $opt in
        c)
            # Parse comma-separated chromosomes into an array
            IFS=',' read -r -a chromosomes <<< "$OPTARG"
            ;;
        \?)
            echo "Usage: $0 -c <chromosome list (comma-separated)>"
            exit 1
            ;;
    esac
done

# Use default chromosomes if none provided
if [[ ${#chromosomes[@]} -eq 0 ]]; then
    echo "No chromosomes provided, using default list: ${default_chromosomes[*]}"
    chromosomes=("${default_chromosomes[@]}")
else
    echo "Chromosome list provided: ${chromosomes[*]}"
fi

# Loop over each chromosome and run the `povu gfa2vcf` command
for chr in "${chromosomes[@]}"; do
    echo "Decomposing graph: $chr"

    # Run the command, replacing <element> with the chromosome (e.g., chr6, chr22, etc.)
    /usr/bin/time -v -o "$DATA_DIR/chr${chr}_time.log" povu decompose \
         -v 4 -h \
         -i "$DATA_DIR/chr${chr}.full.gfa" \
         -o "$DATA_DIR/frst_dir" \
         2> "$DATA_DIR/chr${chr}.log"

    # Check for errors
    if [[ $? -ne 0 ]]; then
        echo "Error processing chr${chr}, check $DATA_DIR/chr${chr}.log for details."
    else
        echo "chr${chr} processed successfully."
    fi
done
