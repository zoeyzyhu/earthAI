#!/bin/bash

# ============================================================================
# Usage:
#   ./pipeline.sh <HDF_FOLDER_PATH> <H5_FOLDER_PATH>
# ============================================================================

# Function to count total number of files in url.txt
count_files() {
    cat "$1" | wc -l
}

# Check if correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <SQL_FILE_PATH> <PARTITION_FILE_PATH>"
    exit 1
fi

sql_file="$1"
partition_file="$2"

# Check if SQL file exists
if [ ! -f "$sql_file" ]; then
    echo "Error: $sql_file does not exist."
    exit 1
fi

# Check if partition file exists
if [ ! -f "$partition_file" ]; then
    echo "Error: $partition_file does not exist."
    exit 1
fi

# Get the total number of paritions in the file
total_partitions=$(count_files "$partition_file")

# Initialize counter
count=0

# Loop through each partition in the file
while IFS= read -r partition; do
    # Increment counter
    ((count++))

    # Print processing message
    echo "Processing partition $count/$total_partitions"

    # Extract date and granule number from the file name
    date=$(echo "$file_name" | awk -F'/' '{print $7}' | awk -F'=' '{print $2}')
    granule=$(echo "$file_name" | awk -F'/' '{print $8}' | awk -F'=' '{print $2}')
    file=$(echo "$file_name" | awk -F'/' '{print $9}')

    # Load data into the database
    hive \
        --hiveconf d=$date \
        --hiveconf granule=$granule \
        --hiveconf file=$file \
        -f "$sql_file"

    # Print completion message
    echo "... Completed processing partition $count/$total_partitions: $partition"
done < "$partition_file"
```