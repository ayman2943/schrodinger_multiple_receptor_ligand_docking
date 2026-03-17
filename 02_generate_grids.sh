#!/bin/bash
################################################################################
# STEP 2: GENERATE GLIDE GRIDS
# Generates receptor grids for docking using Schrodinger's grid generation tool
################################################################################

set -e  # Exit on error

# Configuration - MODIFY THESE PATHS FOR YOUR SYSTEM
SCHRODINGER_PATH="/opt/schrodinger2024-1"  # Default Linux path
# SCHRODINGER_PATH="C:/Program Files/Schrodinger2024-1"  # Windows path
# SCHRODINGER_PATH="/Applications/Schrodinger2024-1"  # macOS path

PROJECT_DIR="$(pwd)"
RECEPTOR_CSV="./data/protein_grid.csv"
GRID_OUTPUT_DIR="./grids"
HOST_SETTINGS="localhost:30"  # Adjust CPU cores as needed

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================================================================"
echo "STEP 2: Generating Glide Grids"
echo "================================================================================"
echo ""

# Check if receptor CSV exists
if [ ! -f "$RECEPTOR_CSV" ]; then
    echo -e "${RED}Error: Receptor CSV not found: $RECEPTOR_CSV${NC}"
    echo "Please run './01_create_receptor_csv.sh' first"
    exit 1
fi

# Check Schrodinger installation
GRID_GEN_EXE="$SCHRODINGER_PATH/utilities/generate_glide_grids"

# Add .exe for Windows
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    GRID_GEN_EXE="$GRID_GEN_EXE.exe"
fi

if [ ! -f "$GRID_GEN_EXE" ]; then
    echo -e "${RED}Error: Schrodinger grid generation executable not found${NC}"
    echo "Expected: $GRID_GEN_EXE"
    echo ""
    echo "Please update SCHRODINGER_PATH in this script to match your installation:"
    echo "  - Linux:   /opt/schrodinger2024-1"
    echo "  - Windows: C:/Program Files/Schrodinger2024-1"
    echo "  - macOS:   /Applications/Schrodinger2024-1"
    exit 1
fi

# Create grid output directory
mkdir -p "$GRID_OUTPUT_DIR"

# Count receptors
receptor_count=$(tail -n +2 "$RECEPTOR_CSV" | wc -l)

echo -e "${GREEN}Configuration:${NC}"
echo "  Schrodinger: $SCHRODINGER_PATH"
echo "  Receptor CSV: $RECEPTOR_CSV"
echo "  Output directory: $GRID_OUTPUT_DIR"
echo "  Total receptors: $receptor_count"
echo "  Host settings: $HOST_SETTINGS"
echo ""

# Change to grid directory
cd "$GRID_OUTPUT_DIR"

echo -e "${YELLOW}Starting grid generation...${NC}"
echo ""

# Run grid generation
"$GRID_GEN_EXE" \
    "../$RECEPTOR_CSV" \
    -HOST "$HOST_SETTINGS" \
    -PROJ "$PROJECT_DIR" \
    -LOCAL \
    -WAIT \
    -verbose

# Check if grids were created
grid_count=$(find . -name "*.zip" | wc -l)

echo ""
if [ "$grid_count" -gt 0 ]; then
    echo -e "${GREEN}✓ Grid generation complete${NC}"
    echo "  Generated $grid_count grid file(s)"
    echo "  Location: $GRID_OUTPUT_DIR/"
    echo ""
    echo "Grid files:"
    find . -name "*.zip" -exec basename {} \;
    echo ""
    echo "Next step: Run './03_create_input_files.sh' to create Glide input files"
else
    echo -e "${RED}Warning: No grid files (.zip) were generated${NC}"
    echo "Check the log files in $GRID_OUTPUT_DIR/ for errors"
fi

echo "================================================================================"
