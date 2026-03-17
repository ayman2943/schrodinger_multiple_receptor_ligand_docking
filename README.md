# Glide Docking Pipeline

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Schrodinger](https://img.shields.io/badge/Schrodinger-2024--2025-blue.svg)](https://www.schrodinger.com/)

Automated pipeline for high-throughput molecular docking using Schrodinger Glide. Streamlines receptor grid generation, input file creation, and batch docking execution.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Detailed Usage](#detailed-usage)
- [Directory Structure](#directory-structure)
- [Configuration](#configuration)
- [Output Files](#output-files)
- [Troubleshooting](#troubleshooting)
- [Citation](#citation)
- [License](#license)

## 🔬 Overview

This pipeline automates the Schrodinger Glide docking workflow for virtual screening campaigns. It handles:

1. **Receptor CSV Generation** - Creates input lists for grid generation
2. **Grid Generation** - Generates receptor grids for all proteins
3. **Input File Creation** - Prepares Glide input files with customizable parameters
4. **Batch Docking** - Executes docking jobs and organizes outputs

Perfect for screening large compound libraries against multiple protein targets.

## ✨ Features

- ✅ **Fully Automated** - Run entire workflow with 4 simple commands
- ✅ **Batch Processing** - Handle multiple receptors and ligands
- ✅ **Organized Outputs** - Automatic file organization by receptor
- ✅ **Cross-Platform** - Works on Linux, macOS, and Windows (Git Bash/WSL)
- ✅ **Error Handling** - Comprehensive error checking and logging
- ✅ **Customizable** - Easy parameter configuration
- ✅ **Resume Support** - Skip completed steps
- ✅ **Progress Tracking** - Clear status messages and counters

## 📦 Prerequisites

### Required Software

1. **Schrodinger Suite** (2024-1 or 2025-1)
   - Glide module
   - Valid license

2. **Bash Shell**
   - Linux/macOS: Built-in
   - Windows: Git Bash or WSL (Windows Subsystem for Linux)

### Prepared Input Files

1. **Receptor Files** (`.maegz`)
   - Prepared protein structures
   - Use Protein Preparation Wizard in Maestro

2. **Ligand File** (`.maegz`)
   - Ligand library prepared with LigPrep
   - Single file containing all ligands

## 🚀 Installation

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/glide-docking-pipeline.git
cd glide-docking-pipeline
```

### 2. Make Scripts Executable

```bash
chmod +x *.sh
```

### 3. Configure Schrodinger Paths

Edit scripts 02 and 04 to match your Schrodinger installation:

**Linux:**
```bash
SCHRODINGER_PATH="/opt/schrodinger2024-1"
```

**Windows:**
```bash
SCHRODINGER_PATH="C:/Program Files/Schrodinger2024-1"
```

**macOS:**
```bash
SCHRODINGER_PATH="/Applications/Schrodinger2024-1"
```

### 4. Add Your Files

```bash
# Add receptor files
cp your_receptors/*.maegz receptors/

# Add ligand file
cp your_ligands.maegz ligands/ligprep_ligands.maegz
```

## 🎯 Quick Start

Run the complete pipeline with 4 commands:

```bash
# Step 1: Create receptor CSV
./01_create_receptor_csv.sh

# Step 2: Generate grids
./02_generate_grids.sh

# Step 3: Create input files
./03_create_input_files.sh

# Step 4: Run docking
./04_run_docking.sh
```

That's it! Results will be in `outputs/`.

## 📖 Detailed Usage

### Step 1: Create Receptor CSV

**What it does:** Scans the `receptors/` directory and creates a CSV file listing all receptor files for grid generation.

```bash
./01_create_receptor_csv.sh
```

**Input:** 
- Receptor files in `receptors/*.maegz`

**Output:** 
- `data/protein_grid.csv`

**Example output:**
```
================================================================================
STEP 1: Creating Receptor CSV File
================================================================================

Found 5 receptor file(s)

  [1/5] Added: 6SLN_prepared.maegz
  [2/5] Added: 1A4G_prepared.maegz
  [3/5] Added: 3TI6_prepared.maegz
  [4/5] Added: 4GWK_prepared.maegz
  [5/5] Added: 5TBM_prepared.maegz

✓ CSV file created: ./data/protein_grid.csv
  Total receptors: 5
```

---

### Step 2: Generate Grids

**What it does:** Generates Glide receptor grids for all proteins using Schrodinger's grid generation utility.

```bash
./02_generate_grids.sh
```

**Input:** 
- `data/protein_grid.csv`
- Receptor files listed in CSV

**Output:** 
- Grid files in `grids/*.zip`
- Log files

**Parameters to adjust:**
- `HOST_SETTINGS`: Number of CPUs (default: `localhost:30`)

**Example output:**
```
================================================================================
STEP 2: Generating Glide Grids
================================================================================

Configuration:
  Schrodinger: /opt/schrodinger2024-1
  Receptor CSV: ./data/protein_grid.csv
  Output directory: ./grids
  Total receptors: 5
  Host settings: localhost:30

Starting grid generation...

[Progress messages from Schrodinger...]

✓ Grid generation complete
  Generated 5 grid file(s)
  Location: ./grids/
```

---

### Step 3: Create Input Files

**What it does:** Creates Glide input files for each grid with customizable docking parameters.

```bash
./03_create_input_files.sh
```

**Input:** 
- Grid files in `grids/*.zip`
- Ligand file: `ligands/ligprep_ligands.maegz`

**Output:** 
- Input files in `inputs/<grid_name>/<grid_name>.inp`

**Parameters to customize:**
```bash
LIGAND_FILE="./ligands/ligprep_ligands.maegz"
PRECISION="XP"  # Options: SP, XP, HTVS
FORCEFIELD="OPLS_2005"
POSTDOCK_XP_DELE="0.5"
```

**Example output:**
```
================================================================================
STEP 3: Creating Glide Input Files
================================================================================

Configuration:
  Ligand file: ./ligands/ligprep_ligands.maegz
  Grid directory: ./grids
  Input directory: ./inputs
  Total grids: 5
  Precision: XP

  [1/5] Created: ./inputs/6SLN_grid/6SLN_grid.inp
  [2/5] Created: ./inputs/1A4G_grid/1A4G_grid.inp
  [3/5] Created: ./inputs/3TI6_grid/3TI6_grid.inp
  [4/5] Created: ./inputs/4GWK_grid/4GWK_grid.inp
  [5/5] Created: ./inputs/5TBM_grid/5TBM_grid.inp

✓ Input file generation complete
```

---

### Step 4: Run Docking

**What it does:** Executes Glide docking for all input files and organizes outputs by receptor.

```bash
./04_run_docking.sh
```

**Input:** 
- Input files in `inputs/`

**Output:** 
- Docking results in `outputs/<grid_name>/`
  - `glide_*.csv` - Docking scores
  - `glide_*.maegz` - Docked poses
  - `glide_*.log` - Run logs
  - `glide_*.pv` - Pose viewer files

**Parameters to adjust:**
```bash
HOST_SETTINGS="localhost:4"  # CPU cores for docking
```

**Example output:**
```
================================================================================
STEP 4: Running Glide Docking
================================================================================

Configuration:
  Total jobs: 5
  Host settings: localhost:4

═══════════════════════════════════════════════════════════
[1/5] Processing: 6SLN_grid
═══════════════════════════════════════════════════════════
Running Glide docking...
✓ Docking completed successfully
Organizing output files...
  Moved: glide_6SLN_grid.csv
  Moved: glide_6SLN_grid.maegz
  Moved: glide_6SLN_grid.log
✓ Output files saved to: ./outputs/6SLN_grid/

[... continues for all grids ...]

================================================================================
DOCKING COMPLETE
================================================================================

Summary:
  Total jobs: 5
  Completed: 5
```

## 📁 Directory Structure

```
glide-docking-pipeline/
├── 01_create_receptor_csv.sh    # Step 1: Generate receptor CSV
├── 02_generate_grids.sh          # Step 2: Generate grids
├── 03_create_input_files.sh      # Step 3: Create input files
├── 04_run_docking.sh             # Step 4: Run docking
├── config.sh                      # Configuration file (optional)
├── README.md                      # This file
├── LICENSE                        # MIT License
├── .gitignore                     # Git ignore rules
├── receptors/                     # Input receptor files
│   ├── protein1.maegz
│   ├── protein2.maegz
│   └── ...
├── ligands/                       # Input ligand files
│   └── ligprep_ligands.maegz
├── data/                          # Generated CSV files
│   └── protein_grid.csv
├── grids/                         # Generated grid files
│   ├── protein1_grid.zip
│   ├── protein2_grid.zip
│   └── ...
├── inputs/                        # Generated input files
│   ├── protein1_grid/
│   │   └── protein1_grid.inp
│   ├── protein2_grid/
│   │   └── protein2_grid.inp
│   └── ...
└── outputs/                       # Docking results
    ├── protein1_grid/
    │   ├── glide_protein1.csv
    │   ├── glide_protein1.maegz
    │   └── glide_protein1.log
    ├── protein2_grid/
    │   ├── glide_protein2.csv
    │   ├── glide_protein2.maegz
    │   └── glide_protein2.log
    └── ...
```

## ⚙️ Configuration

### Docking Parameters

Edit `03_create_input_files.sh`:

| Parameter | Options | Description |
|-----------|---------|-------------|
| `PRECISION` | `HTVS`, `SP`, `XP` | Docking accuracy (XP most accurate) |
| `FORCEFIELD` | `OPLS_2005`, `OPLS3e` | Force field for scoring |
| `POSTDOCK_XP_DELE` | `0.5` (default) | Energy window for post-docking |
| `WRITE_XP_DESC` | `True`, `False` | Write XP descriptors |

### Computational Resources

Edit scripts 02 and 04:

```bash
# Grid generation (Step 2)
HOST_SETTINGS="localhost:30"  # Use 30 CPU cores

# Docking (Step 4)
HOST_SETTINGS="localhost:4"   # Use 4 CPU cores per job
```

### Ligand File

Edit `03_create_input_files.sh` if your ligand file has a different name:

```bash
LIGAND_FILE="./ligands/your_ligands.maegz"
```

## 📊 Output Files

### CSV Files (`glide_*.csv`)

Docking scores and properties:

| Column | Description |
|--------|-------------|
| `Title` | Ligand name |
| `r_i_docking_score` | Glide docking score (kcal/mol) |
| `r_i_glide_gscore` | GlideScore |
| `r_i_glide_emodel` | Emodel score |
| `r_i_glide_energy` | Glide energy |
| `r_i_glide_ecoul` | Coulomb energy |
| `r_i_glide_evdw` | van der Waals energy |

### MAEGZ Files (`glide_*.maegz`)

- Contains docked ligand poses
- Open in Maestro for visualization
- Includes receptor-ligand complex

### Log Files (`glide_*.log`)

- Detailed run information
- Warnings and errors
- Docking parameters used

## 🔧 Troubleshooting

### Common Issues

**1. "Schrodinger executable not found"**

- **Solution:** Update `SCHRODINGER_PATH` in scripts 02 and 04
- Check installation location
- Verify Schrodinger license is valid

**2. "No receptor files found"**

- **Solution:** Add `.maegz` receptor files to `receptors/`
- Ensure files are prepared with Protein Preparation Wizard

**3. "Ligand file not found"**

- **Solution:** 
  - Add ligand file to `ligands/` directory
  - Update `LIGAND_FILE` variable in script 03
  - Ensure file is prepared with LigPrep

**4. "Permission denied" when running scripts**

- **Solution:** Make scripts executable
  ```bash
  chmod +x *.sh
  ```

**5. Docking jobs fail**

- **Solution:**
  - Check log files in `outputs/<grid_name>/`
  - Verify grid files were generated correctly
  - Ensure sufficient disk space
  - Check Schrodinger license is active

### Windows-Specific Issues

**Git Bash path issues:**

If you see "command not found" errors, try:

```bash
# Use full Windows paths
SCHRODINGER_PATH="C:/Program Files/Schrodinger2024-1"
```

**Alternatively, use WSL** (Windows Subsystem for Linux) for better compatibility.

## 📚 Best Practices

1. **Protein Preparation**
   - Use Protein Preparation Wizard
   - Add missing hydrogens
   - Assign bond orders
   - Optimize hydrogen bonds
   - Minimize structure

2. **Ligand Preparation**
   - Use LigPrep for ligand preparation
   - Generate tautomers and ionization states
   - Minimize ligands with OPLS force field

3. **Grid Generation**
   - Define binding site carefully
   - Use crystal ligand for site definition if available
   - Verify grid box covers binding site

4. **Resource Management**
   - Adjust `HOST_SETTINGS` based on available CPUs
   - Monitor disk space (docking generates large files)
   - Use HTVS for initial screening, XP for refinement

## 📖 Citation

If you use this pipeline in your research, please cite:

```bibtex
@software{glide_docking_pipeline_2025,
  author = {Your Name},
  title = {Glide Docking Pipeline: Automated Molecular Docking Workflow},
  year = {2025},
  url = {https://github.com/yourusername/glide-docking-pipeline},
  version = {1.0.0}
}
```

And cite Schrodinger Glide:

```bibtex
@article{friesner2004glide,
  title={Glide: a new approach for rapid, accurate docking and scoring. 1. Method and assessment of docking accuracy},
  author={Friesner, Richard A and Banks, Jay L and Murphy, Robert B and Halgren, Thomas A and Klicic, Jasna J and Mainz, Daniel T and Repasky, Matthew P and Knoll, Eric H and Shelley, Mee and Perry, Jason K and others},
  journal={Journal of Medicinal Chemistry},
  volume={47},
  number={7},
  pages={1739--1749},
  year={2004},
  publisher={ACS Publications}
}
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 👥 Authors

- **Your Name** - *Initial work*

## 🙏 Acknowledgments

- Schrodinger, Inc. for the Glide software
- [Add your acknowledgments]

## 📞 Contact

For questions or issues:
- GitHub Issues: [https://github.com/yourusername/glide-docking-pipeline/issues](https://github.com/yourusername/glide-docking-pipeline/issues)
- Email: your.email@example.com

---

**Last Updated:** March 2025
