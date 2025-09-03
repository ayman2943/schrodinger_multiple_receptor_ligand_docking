#!/bin/bash

# Define the ligand file path
LIGAND_FILE="C:\Users\ASUS\OneDrive\AK\NA_bovine.prj\ligprep_osetamivir_all_combo/ligprep_osetamivir_all_combo-out.maegz"

# Function to create the input file for each grid file
create_glide_input_file_for_grid() {
    local grid_file=$1
    local output_folder=$2

    # For Windows (Git Bash or Cygwin), use cygpath for absolute path
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        local absolute_grid_path=$(cygpath -w "$grid_file")
    else
        # For Unix-like systems, use pwd to resolve the absolute path
        local absolute_grid_path="$(pwd)/$grid_file"
    fi

    # Extract the name of the grid file without the extension to use as the subfolder name
    local grid_name="${grid_file##*/}"  # Get the base filename
    grid_name="${grid_name%.zip}"  # Remove the .zip extension

    # Initialize the content of the input file
    local input_file_content="FORCEFIELD   OPLS_2005\n"
    input_file_content="$input_file_content""GRIDFILE   $absolute_grid_path\n"
    input_file_content="$input_file_content""LIGANDFILE   $LIGAND_FILE\n"
    input_file_content="$input_file_content""POSTDOCK_XP_DELE   0.5\n"
    input_file_content="$input_file_content""PRECISION   XP\n"
    input_file_content="$input_file_content""WRITE_XP_DESC   False\n"

    # If we have content, create the subfolder and write the input file
    if [ -n "$input_file_content" ]; then
        # Ensure the subfolder under the 'input' directory exists
        mkdir -p "$output_folder/input/$grid_name"
        
        # Write to the output .inp file with the same name as the subfolder
        echo -e "$input_file_content" > "$output_folder/input/$grid_name/$grid_name.inp"
        echo "Glide input file created at: $output_folder/input/$grid_name/$grid_name.inp"
    else
        echo "No valid grid file found: $grid_file"
    fi
}

# Function to process all .zip files in the current directory
process_grid_files() {
    local base_folder="."  # Current directory
    
    # Loop through all .zip files in the current directory
    for grid_file in "$base_folder"/*.zip; do
        # Check if the grid file exists (in case there are no .zip files)
        if [ -e "$grid_file" ]; then
            # Call the function to create the input file for the grid
            create_glide_input_file_for_grid "$grid_file" "$base_folder"
        else
            echo "No grid files found in the current directory."
        fi
    done
}

# Main execution
echo "Starting the script in the current directory."

# Call the function to process all .zip grid files in the current directory
process_grid_files
