#!/bin/bash
################################################################################
# STEP 4: RUN GLIDE DOCKING
# Executes Glide docking for all input files and organizes outputs
################################################################################

set -e  # Exit on error

# Configuration - MODIFY THESE PATHS
SCHRODINGER_PATH="/opt/schrodinger2025-1"  # Default Linux path
# SCHRODINGER_PATH="C:/Program Files/Schrodinger2025-1"  # Windows path
# SCHRODINGER_PATH="/Applications/Schrodinger2025-1"  # macOS path

PROJECT_DIR="$(pwd)"
INPUT_DIR="./inputs"
OUTPUT_DIR="./outputs"
HOST_SETTINGS="localhost:4"  # Adjust CPU cores as needed

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "================================================================================"
echo "STEP 4: Running Glide Docking"
echo "================================================================================"
echo ""

# Check Schrodinger installation
GLIDE_EXE="$SCHRODINGER_PATH/glide"

# Add .exe for Windows
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    GLIDE_EXE="$GLIDE_EXE.exe"
fi

if [ ! -f "$GLIDE_EXE" ]; then
    echo -e "${RED}Error: Glide executable not found${NC}"
    echo "Expected: $GLIDE_EXE"
    echo ""
    echo "Please update SCHRODINGER_PATH in this script to match your installation"
    exit 1
fi

# Check if input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo -e "${RED}Error: Input directory not found: $INPUT_DIR${NC}"
    echo "Please run './03_create_input_files.sh' first"
    exit 1
fi

# Count input files
input_count=$(find "$INPUT_DIR" -name "*.inp" | wc -l)

if [ "$input_count" -eq 0 ]; then
    echo -e "${RED}Error: No input files (.inp) found in $INPUT_DIR${NC}"
    echo "Please run './03_create_input_files.sh' first"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}Configuration:${NC}"
echo "  Schrodinger: $SCHRODINGER_PATH"
echo "  Input directory: $INPUT_DIR"
echo "  Output directory: $OUTPUT_DIR"
echo "  Total jobs: $input_count"
echo "  Host settings: $HOST_SETTINGS"
echo ""

# Counter
count=0
failed=0

# Process each input file
find "$INPUT_DIR" -name "*.inp" | while read -r inp_file; do
    count=$((count + 1))
    
    # Get grid name from path
    grid_name=$(basename $(dirname "$inp_file"))
    
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[$count/$input_count] Processing: $grid_name${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    
    # Create output subdirectory for this job
    job_output_dir="$OUTPUT_DIR/$grid_name"
    mkdir -p "$job_output_dir"
    
    # Run Glide
    echo "Running Glide docking..."
    
    if "$GLIDE_EXE" "$inp_file" \
        -OVERWRITE \
        -adjust \
        -HOST "$HOST_SETTINGS" \
        -PROJ "$PROJECT_DIR" \
        -DISP append \
        -VIEWNAME glide_docking_gui.DockingPanel \
        -TMPLAUNCHDIR; then
        
        echo -e "${GREEN}✓ Docking completed successfully${NC}"
        
        # Move output files to job-specific directory
        echo "Organizing output files..."
        
        for pattern in "glide_*.log" "glide_*.pv" "glide_*.lib" "glide_*.csv" "glide_*.maegz" "glide_*.rept"; do
            for output_file in $pattern; do
                if [ -e "$output_file" ]; then
                    mv "$output_file" "$job_output_dir/"
                    echo "  Moved: $output_file"
                fi
            done
        done
        
        echo -e "${GREEN}✓ Output files saved to: $job_output_dir/${NC}"
    else
        echo -e "${RED}✗ Docking failed for $grid_name${NC}"
        failed=$((failed + 1))
        
        # Still try to move any partial output files
        for pattern in "glide_*.log" "glide_*.pv" "glide_*.lib" "glide_*.csv" "glide_*.maegz" "glide_*.rept"; do
            for output_file in $pattern; do
                if [ -e "$output_file" ]; then
                    mv "$output_file" "$job_output_dir/"
                fi
            done
        done
    fi
    
    echo ""
done

echo "================================================================================"
echo -e "${GREEN}DOCKING COMPLETE${NC}"
echo "================================================================================"
echo ""
echo "Summary:"
echo "  Total jobs: $input_count"
echo "  Completed: $((input_count - failed))"
if [ "$failed" -gt 0 ]; then
    echo -e "  ${RED}Failed: $failed${NC}"
fi
echo ""
echo "Output location: $OUTPUT_DIR/"
echo ""
echo "Next step: Analyze results in the outputs/ directory"
echo "  - CSV files contain docking scores"
echo "  - MAEGZ files contain docked poses"
echo "  - LOG files contain detailed run information"
echo "================================================================================"
