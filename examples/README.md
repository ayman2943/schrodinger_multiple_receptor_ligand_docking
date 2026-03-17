# Example Files

This directory contains example files for testing the pipeline.

## Included Examples

### Receptors
- `examples/receptors/` - Sample receptor files
  - Small protein structures for testing
  - Already prepared and ready to use

### Ligands
- `examples/ligands/` - Sample ligand files
  - Small molecule library
  - Pre-processed with LigPrep

## Using Example Files

### Quick Test

```bash
# Copy examples to working directories
cp examples/receptors/*.maegz receptors/
cp examples/ligands/*.maegz ligands/ligprep_ligands.maegz

# Run pipeline
./01_create_receptor_csv.sh
./02_generate_grids.sh
./03_create_input_files.sh
./04_run_docking.sh
```

### Expected Results

With example files:
- Grid generation: ~5-10 minutes
- Docking: ~10-15 minutes
- Output: Docking scores in `outputs/`

## Creating Your Own Test Files

### Receptor Preparation

1. Open Maestro
2. Import PDB file
3. Protein Preparation Wizard:
   - Preprocess
   - Review and modify
   - Refine (minimize)
4. Export as `.maegz`

### Ligand Preparation

1. Open Maestro
2. Import ligand structures (SDF, MOL2, etc.)
3. LigPrep:
   - Use OPLS force field
   - Generate tautomers
   - Generate ionization states
   - Minimize
4. Export as `.maegz`

## File Format Requirements

### Receptor Files
- Format: `.maegz` (Maestro compressed)
- Preparation: Must be prepared with Protein Prep Wizard
- Structure: Should include binding site

### Ligand Files
- Format: `.maegz` (Maestro compressed)
- Preparation: Must be prepared with LigPrep
- Multiple ligands: All in one file

## Notes

Example files are intentionally small for quick testing. Real docking campaigns typically involve:
- Larger protein structures
- Libraries of 100s-1000s of compounds
- Longer computation times

## Data Sources

Example receptor: PDB (https://www.rcsb.org/)
Example ligands: ZINC database (https://zinc.docking.org/)

*Note: These are for testing only. Use appropriate structures for your research.*
