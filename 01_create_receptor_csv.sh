#!/bin/bash
################################################################################
# STEP 1: CREATE RECEPTOR CSV
# Generates a CSV file listing all receptor files for grid generation
################################################################################

set -e  # Exit on error

# Configuration
RECEPTOR_DIR="./receptors"
OUTPUT_CSV="./data/protein_grid.csv"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================================================"
echo "STEP 1: Creating Receptor CSV File"
echo "================================================================================"
echo ""

# Check if receptor directory exists
if [ ! -d "$RECEPTOR_DIR" ]; then
    echo "Error: Receptor directory not found: $RECEPTOR_DIR"
    echo "Please create the directory and add your .maegz receptor files"
    exit 1
fi

# Count receptor files
receptor_count=$(find "$RECEPTOR_DIR" -name "*.maegz" | wc -l)

if [ "$receptor_count" -eq 0 ]; then
    echo "Error: No .maegz receptor files found in $RECEPTOR_DIR"
    echo "Please add your receptor files to the receptors/ directory"
    exit 1
fi

echo -e "${GREEN}Found $receptor_count receptor file(s)${NC}"
echo ""

# Create data directory if it doesn't exist
mkdir -p ./data

# Remove old CSV if exists
rm -f "$OUTPUT_CSV"

# Write CSV header
echo "rec_file,lig_asl" > "$OUTPUT_CSV"

# Counter
count=0

# Process each receptor file
for file in "$RECEPTOR_DIR"/*.maegz; do
    # Get absolute path
    abs_path=$(cd "$(dirname "$file")" && pwd)/$(basename "$file")
    
    # Convert Windows-style backslashes to forward slashes (for cross-platform)
    abs_path=$(echo "$abs_path" | sed 's|\\|/|g')
    
    # Append to CSV
    echo "$abs_path,mol.num 2" >> "$OUTPUT_CSV"
    
    count=$((count + 1))
    echo "  [$count/$receptor_count] Added: $(basename "$file")"
done

echo ""
echo -e "${GREEN}✓ CSV file created: $OUTPUT_CSV${NC}"
echo "  Total receptors: $count"
echo ""
echo "Next step: Run './02_generate_grids.sh' to generate grid files"
echo "================================================================================"
