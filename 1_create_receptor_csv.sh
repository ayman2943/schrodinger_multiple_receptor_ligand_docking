#!/bin/bash

# Set the directory containing receptor files
RECEPTOR_DIR="./"
OUTPUT_CSV="protein_grid.csv"

# Remove the output file if it exists to avoid permission issues
rm -f "$OUTPUT_CSV"

# Write the header to the CSV file
echo "rec_file,lig_asl" > "$OUTPUT_CSV"

# Loop through all .maegz files in the directory
for file in "$RECEPTOR_DIR"/*.maegz; do
    # Get the absolute path without './'
    abs_path=$(cd "$(dirname "$file")" && pwd)/$(echo "$file" | sed "s|$RECEPTOR_DIR/*||")

    # Convert Windows-style backslashes to forward slashes
    abs_path=$(echo "$abs_path" | sed 's|\\|/|g')

    # Append the file path and lig_asl value to the CSV
    echo "$abs_path,mol.num 2" >> "$OUTPUT_CSV"
done

# Confirm the CSV file has been created
echo "CSV file created: $OUTPUT_CSV"
