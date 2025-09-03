#!/bin/bash

# Create a folder named 'grid' if it doesn't exist
mkdir -p ./grid
cd grid

# Run the grid generation command with the provided arguments and save output in the 'grid' folder
"C:/Program Files/Schrodinger2024-1/utilities/generate_glide_grids.exe" E:/Ayman/final/2.3.1.1a.prj/exported/6SLN/protein_grid.csv -HOST localhost:30 -PROJ E:/Ayman/final/2.3.1.1a.prj -LOCAL -WAIT -verbose  
# Confirm the grid folder was created and output saved
echo "Grid generation complete. Output saved in './grid/grid_generation_output.log'."
