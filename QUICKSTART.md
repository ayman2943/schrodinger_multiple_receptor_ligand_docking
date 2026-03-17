# Quick Start Guide

Get your Glide docking pipeline running in 5 minutes!

## Prerequisites Checklist

- [ ] Schrodinger Suite installed (2024-1 or 2025-1)
- [ ] Valid Schrodinger license
- [ ] Bash shell available
- [ ] Prepared receptor files (.maegz)
- [ ] Prepared ligand file (.maegz)

## Step-by-Step Setup

### 1. Clone and Setup (2 minutes)

```bash
# Clone repository
git clone https://github.com/yourusername/glide-docking-pipeline.git
cd glide-docking-pipeline

# Make scripts executable
chmod +x *.sh
```

### 2. Configure Paths (1 minute)

Edit `02_generate_grids.sh` and `04_run_docking.sh`:

**Find this line:**
```bash
SCHRODINGER_PATH="/opt/schrodinger2024-1"
```

**Change to your path:**
```bash
# Linux
SCHRODINGER_PATH="/opt/schrodinger2024-1"

# Windows (Git Bash)
SCHRODINGER_PATH="C:/Program Files/Schrodinger2024-1"

# macOS
SCHRODINGER_PATH="/Applications/Schrodinger2024-1"
```

### 3. Add Your Files (1 minute)

```bash
# Copy receptor files
cp /path/to/your/receptors/*.maegz receptors/

# Copy ligand file
cp /path/to/your/ligands.maegz ligands/ligprep_ligands.maegz
```

### 4. Run Pipeline (1 minute to start)

```bash
# Run all steps
./01_create_receptor_csv.sh
./02_generate_grids.sh
./03_create_input_files.sh
./04_run_docking.sh
```

Or run as a single command:

```bash
./01_create_receptor_csv.sh && \
./02_generate_grids.sh && \
./03_create_input_files.sh && \
./04_run_docking.sh
```

## Expected Timeline

| Step | Time (5 receptors) | Output |
|------|-------------------|---------|
| 1. CSV creation | < 1 min | CSV file |
| 2. Grid generation | 10-30 min | Grid files |
| 3. Input creation | < 1 min | Input files |
| 4. Docking | 30 min - 2 hours | Results |

*Times vary based on system resources and complexity*

## Verify Success

After completion, check:

```bash
# List output directories
ls outputs/

# Check a result file
head outputs/*/glide_*.csv
```

You should see docking scores for each receptor!

## Next Steps

1. **Analyze Results**
   - Open CSV files in Excel/Python
   - Sort by docking score
   - Visualize top poses in Maestro

2. **Customize Parameters**
   - Edit `03_create_input_files.sh`
   - Change precision: SP, XP, or HTVS
   - Adjust scoring parameters

3. **Scale Up**
   - Add more receptors
   - Add more ligands
   - Run on cluster/HPC

## Common First-Time Issues

### Issue: "Command not found"
```bash
# Solution: Make scripts executable
chmod +x *.sh
```

### Issue: "No such file or directory"
```bash
# Solution: Check you're in the right directory
pwd  # Should end with /glide-docking-pipeline

# And files are in the right place
ls receptors/
ls ligands/
```

### Issue: "Schrodinger executable not found"
```bash
# Solution: Update path in scripts
# Find your Schrodinger installation:
which glide  # Linux/macOS
where glide  # Windows
```

## Get Help

- Check [README.md](README.md) for detailed documentation
- Open an [issue](https://github.com/yourusername/glide-docking-pipeline/issues)
- Review log files in `outputs/` for error details

## Success!

If you see this at the end of step 4:

```
================================================================================
DOCKING COMPLETE
================================================================================

Summary:
  Total jobs: 5
  Completed: 5
```

🎉 **Congratulations! Your docking pipeline is working!**

Check `outputs/` for your results and start analyzing!
