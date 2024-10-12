#!/usr/bin/env bash

# Loop through all provided arguments
for i in "$@"; do
    # Check if the file exists
    if [[ -f "$i" ]]; then
        # Extract the tarball
        tar -xvzf "$i"
    else
        # Print an error message if the file does not exist
        echo "File $i does not exist."
    fi
    # Exit the loop after the first iteration
    break
done