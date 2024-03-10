#!/bin/bash

# ============================================================================
# This script is used to convert H5 files to parquet files.
# The parquet files are then loaded into the database.
# Usage:
#   ./pipeline.sh <H5_FOLDER_PATH>
# ============================================================================

# Function to count total number of files in a directory
count_files() {
    find "$1" -maxdepth 1 -name "*.h5" | wc -l
}

# Check if correct number of arguments are passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <H5_FOLDER_PATH>"
    exit 1
fi

# Assign argument to variable
h5_folder_path="$1"

# Check if H5 folder exists
if [ ! -d "$h5_folder_path" ]; then
    echo "Error: $h5_folder_path does not exist."
    exit 1
fi

# Get the total number of H5 files in the folder
total_files=$(count_files "$h5_folder_path")

# Initialize counter
count=0

# Loop through each H5 file in the folder
for h5_file in "$h5_folder_path"/*.h5; do
    if [ -e "$h5_file" ]; then
        # Increment counter
        ((count++))

        # Print processing message
        echo "Processing file $count/$total_files @ $(date)"

        # Extract date and granule number from the file name
        file_name=$(basename "$h5_file")
        date=$(echo "$file_name" | awk -F'[_.]' '{print $2"-"$3"-"$4}')
        granule_number=$(echo "$file_name" | awk -F'[_.]' '{print $5}')

        echo "... Date: $date, Granule Number: $granule_number"

        # Convert H5 to Parquet
        echo "... Converting to Parquet: $h5_file"
        python3 convert_to_parquet.py "$h5_file"

    else
        echo "No H5 files found in $h5_folder_path"
        exit 1
    fi
done