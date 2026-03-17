#!/bin/bash
################################################################################
# STEP 3: CREATE GLIDE INPUT FILES
# Generates Glide docking input files for each grid
################################################################################

set -e  # Exit on error

# Configuration - MODIFY THESE PATHS
LIGAND_FILE="./ligands/ligprep_ligands.maegz"  # Path to prepared ligands
GRID_DIR="./grids"
INPUT_DIR="./inputs"

# Docking parameters
FORCEFIELD="OPLS_2005"
PRECISION="XP"  # Options: SP, XP, HTVS
POSTDOCK_XP_DELE="0.5"
WRITE_XP_DESC="False"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================================================================"
echo "STEP 3: Creating Glide Input Files"
echo "================================================================================"
echo ""

# Check if ligand file exists
if [ ! -f "$LIGAND_FILE" ]; then
    echo -e "${RED}Error: Ligand file not found: $LIGAND_FILE${NC}"
    echo "Please add your prepared ligand file to the ligands/ directory"
    echo ""
    echo "Expected file: $LIGAND_FILE"
    echo ""
    echo "You can modify the LIGAND_FILE variable in this script if your"
    echo "ligand file has a different name or location."
    exit 1
fi

# Check if grid directory exists
if [ ! -d "$GRID_DIR" ]; then
    echo -e "${RED}Error: Grid directory not found: $GRID_DIR${NC}"
    echo "Please run './02_generate_grids.sh' first"
    exit 1
fi

# Count grid files
grid_count=$(find "$GRID_DIR" -name "*.zip" | wc -l)

if [ "$grid_count" -eq 0 ]; then
    echo -e "${RED}Error: No grid files (.zip) found in $GRID_DIR${NC}"
    echo "Please run './02_generate_grids.sh' first"
    exit 1
fi

# Get absolute path for ligand file
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    ABS_LIGAND_FILE=$(cygpath -w "$(realpath "$LIGAND_FILE")")
else
    ABS_LIGAND_FILE=$(realpath "$LIGAND_FILE")
fi

echo -e "${GREEN}Configuration:${NC}"
echo "  Ligand file: $LIGAND_FILE"
echo "  Grid directory: $GRID_DIR"
echo "  Input directory: $INPUT_DIR"
echo "  Total grids: $grid_count"
echo "  Precision: $PRECISION"
echo "  Force field: $FORCEFIELD"
echo ""

# Create main input directory
mkdir -p "$INPUT_DIR"

# Counter
count=0

# Process each grid file
for grid_file in "$GRID_DIR"/*.zip; do
    # Get absolute path for grid file
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        ABS_GRID_FILE=$(cygpath -w "$(realpath "$grid_file")")
    else
        ABS_GRID_FILE=$(realpath "$grid_file")
    fi
    
    # Extract grid name (filename without extension)
    grid_name=$(basename "$grid_file" .zip)
    
    # Create subdirectory for this grid
    grid_input_dir="$INPUT_DIR/$grid_name"
    mkdir -p "$grid_input_dir"
    
    # Create input file
    input_file="$grid_input_dir/${grid_name}.inp"
    
    cat > "$input_file" << EOF
FORCEFIELD   $FORCEFIELD
GRIDFILE   $ABS_GRID_FILE
LIGANDFILE   $ABS_LIGAND_FILE
POSTDOCK_XP_DELE   $POSTDOCK_XP_DELE
PRECISION   $PRECISION
WRITE_XP_DESC   $WRITE_XP_DESC
EOF
    
    count=$((count + 1))
    echo "  [$count/$grid_count] Created: $input_file"
done

echo ""
echo -e "${GREEN}✓ Input file generation complete${NC}"
echo "  Created $count input file(s) in $INPUT_DIR/"
echo ""
echo "Next step: Run './04_run_docking.sh' to execute Glide docking"
echo "================================================================================"
