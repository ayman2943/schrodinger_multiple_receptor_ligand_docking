#!/bin/bash
################################################################################
# MASTER RUN SCRIPT
# Executes the complete docking pipeline
################################################################################

set -e  # Exit on error

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                   GLIDE DOCKING PIPELINE - MASTER SCRIPT                  ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

# Function to run a step
run_step() {
    local step_num=$1
    local step_name=$2
    local script=$3
    
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}STEP $step_num: $step_name${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f "$script" ]; then
        echo -e "${RED}Error: Script not found: $script${NC}"
        exit 1
    fi
    
    if ! bash "$script"; then
        echo ""
        echo -e "${RED}✗ Step $step_num failed!${NC}"
        echo ""
        exit 1
    fi
    
    echo ""
    echo -e "${GREEN}✓ Step $step_num completed successfully${NC}"
}

# Check if scripts exist
for script in 01_create_receptor_csv.sh 02_generate_grids.sh 03_create_input_files.sh 04_run_docking.sh; do
    if [ ! -f "$script" ]; then
        echo -e "${RED}Error: Required script not found: $script${NC}"
        exit 1
    fi
    if [ ! -x "$script" ]; then
        echo -e "${YELLOW}Making $script executable...${NC}"
        chmod +x "$script"
    fi
done

# Record start time
start_time=$(date +%s)

# Run pipeline
run_step 1 "Create Receptor CSV" "./01_create_receptor_csv.sh"
run_step 2 "Generate Grids" "./02_generate_grids.sh"
run_step 3 "Create Input Files" "./03_create_input_files.sh"
run_step 4 "Run Docking" "./04_run_docking.sh"

# Calculate elapsed time
end_time=$(date +%s)
elapsed=$((end_time - start_time))
hours=$((elapsed / 3600))
minutes=$(( (elapsed % 3600) / 60 ))
seconds=$((elapsed % 60))

# Final summary
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo -e "║${GREEN}                     PIPELINE COMPLETED SUCCESSFULLY!                      ${NC}║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Total execution time: ${hours}h ${minutes}m ${seconds}s"
echo ""
echo "Results are available in:"
echo "  - Grids:  grids/"
echo "  - Inputs: inputs/"
echo "  - Outputs: outputs/"
echo ""
echo "Next steps:"
echo "  1. Review docking scores in outputs/*/*.csv"
echo "  2. Visualize top poses in Maestro"
echo "  3. Analyze binding interactions"
echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
