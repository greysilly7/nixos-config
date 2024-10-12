#!/usr/bin/env bash

# Check if exactly one argument is provided
if (( $# == 1 )); then
    # Create a compressed tarball with the provided argument as the name
    tar -cvzf "$1.tar.gz" "$1"
else
    # Print an error message if the number of arguments is incorrect
    echo "Wrong number of arguments..."
fi