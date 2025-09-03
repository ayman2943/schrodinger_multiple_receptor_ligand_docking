#!/bin/bash

# Path to Glide executable
GLIDE_EXE="C:/Program Files/Schrodinger2025-1/glide.exe"

# Project directory path
PROJECT_DIR="C:\Users\ASUS\OneDrive\AK\NA_bovine.prj"

# Input folder path
INPUT_DIR="input"

# Loop through each .inp file in all subdirectories of the input folder
find "$INPUT_DIR" -type f -name "*.inp" | while read -r inp_file; do
    # Get the directory of the current input file
    input_dir=$(dirname "$inp_file")

    # Run Glide with the specified command
    "$GLIDE_EXE" "$inp_file" -OVERWRITE -adjust -HOST localhost:4 -PROJ "$PROJECT_DIR" -DISP append -VIEWNAME glide_docking_gui.DockingPanel -TMPLAUNCHDIR

    # Move the output files to the respective input directory
    for output_file in glide_*.log glide_*.pv glide_*.lib glide_*.csv; do
        if [ -e "$output_file" ]; then
            mv "$output_file" "$input_dir"
        fi
    done

    echo "Processed: $inp_file"
done

echo "All docking runs are complete."
