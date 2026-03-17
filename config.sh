#!/bin/bash
################################################################################
# CONFIGURATION FILE (OPTIONAL)
# Central location for all pipeline settings
# Source this file at the start of each script for consistency
################################################################################

# Schrodinger Installation
export SCHRODINGER_PATH="/opt/schrodinger2024-1"  # Update for your system
# export SCHRODINGER_PATH="C:/Program Files/Schrodinger2024-1"  # Windows
# export SCHRODINGER_PATH="/Applications/Schrodinger2024-1"  # macOS

# Directory Paths
export RECEPTOR_DIR="./receptors"
export LIGAND_DIR="./ligands"
export DATA_DIR="./data"
export GRID_DIR="./grids"
export INPUT_DIR="./inputs"
export OUTPUT_DIR="./outputs"

# File Paths
export RECEPTOR_CSV="$DATA_DIR/protein_grid.csv"
export LIGAND_FILE="$LIGAND_DIR/ligprep_ligands.maegz"

# Computational Resources
export GRID_GEN_CPUS="30"      # CPUs for grid generation
export DOCKING_CPUS="4"        # CPUs per docking job

# Docking Parameters
export FORCEFIELD="OPLS_2005"
export PRECISION="XP"          # Options: HTVS, SP, XP
export POSTDOCK_XP_DELE="0.5"
export WRITE_XP_DESC="False"

# Advanced Options
export OVERWRITE="True"        # Overwrite existing results
export VERBOSE="True"          # Verbose logging

# Colors for output (optional)
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export BLUE='\033[0;34m'
export NC='\033[0m'

################################################################################
# Usage: Source this file in your scripts
# Add to the top of each script:
#   source ./config.sh
################################################################################
