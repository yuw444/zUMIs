# PROJECT KNOWLEDGE BASE

**Generated:** 2026-02-13
**Commit:** 2039a90913b1b12e4fa48212fe6054badc1d1c09
**Branch:** main

## OVERVIEW
zUMIs - UCLA/Mount Sinai RNA-seq pipeline. Perl/R/Python/Bash workflow for single-cell RNA-seq analysis with barcode demultiplexing, mapping (STAR), and expression quantification.

## STRUCTURE (By Pipeline Stage)
```
./
├── zUMIs.sh                    # Main entry point (Bash orchestrator)
├── zUMIs.yaml                  # Pipeline config template
├── environment.yml             # Conda dependencies
├── filtering/                  # Stage 1: read filtering & splitting
│   ├── splitfq.sh
│   ├── mergeBAM.sh
│   ├── checkyaml.R
│   ├── fqfilter_v2.pl
│   ├── correct_BCtag.pl
│   ├── correct_UBtag.pl
│   ├── correct_UBtag.py
│   ├── Approx.pm
│   ├── distilReads.pm
│   └── merge_bbmap_alignment.pl
├── demultiplex/                # Stage 2: barcode demultiplexing
│   ├── demultiplex_BC.py
│   ├── demultiplex_BC.pl
│   ├── countUMIfrags.py
│   └── merge_demultiplexed_fastq.R
├── barcode/                    # Stage 3: barcode detection
│   ├── zUMIs-BCdetection.R
│   ├── barcodeIDFUN.R
│   └── readYaml4fqfilter.R
├── mapping/                    # Stage 4: STAR alignment
│   ├── zUMIs-mapping.R
│   └── zUMIs-bbmap.R
├── counting/                  # Stage 5: expression counting
│   ├── zUMIs-dge2.R
│   ├── runfeatureCountFUN.R
│   ├── UMIstuffFUN.R
│   ├── featureCounts.R
│   ├── fcountsLib/
│   └── fcountsLib2/
├── stats/                      # Stage 6: statistics & QC
│   ├── zUMIs-stats2.R
│   └── statsFUN.R
├── postprocess/               # Stage 7: loom/velocity output
│   ├── rds2loom.R
│   ├── runVelocyto.R
│   └── zUMIs-config_shiny.R
├── bin/                        # Bundled dependencies
│   └── zUMIs-miniconda.partaa-h
└── ExampleData/               # Test data
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Run pipeline | `./zUMIs.sh -y config.yaml` | Bash orchestrator |
| Config schema | `./zUMIs.yaml` | YAML config reference |
| Filtering | `filtering/` | splitfq, fqfilter, correction |
| Demultiplex | `demultiplex/` | barcode demux, UMI counting |
| Barcode detection | `barcode/` | BC detection algorithms |
| Mapping | `mapping/` | STAR alignment |
| Counting | `counting/` | expression quantification |
| Stats | `stats/` | QC metrics |
| Post-process | `postprocess/` | loom, velocyto |

## CONVENTIONS
- **CLI**: `./zUMIs.sh -y <yaml> -d <out_dir>`
- **R scripts**: Use `Rscript` + YAML input via `yaml::read_yaml`
- **Python scripts**: `argparse` + `if __name__ == "__main__": main()`
- **Perl modules**: `.pm` files in filtering/
- **Config**: YAML-based, validated by `filtering/checkyaml.R`

## ANTI-PATTERNS (THIS PROJECT)
- No test suite - testing conventions not established

## UNIQUE STYLES
- Mixed language pipeline (Bash→R→Python→Perl)
- YAML-driven workflow configuration
- Pipeline organized by stage (filtering→demultiplex→barcode→mapping→counting→stats→postprocess)
- Shiny config UI: `postprocess/zUMIs-config_shiny.R`

## COMMANDS
```bash
# Run full pipeline
./zUMIs.sh -y config.yaml -d output_dir

# Validate config
Rscript filtering/checkyaml.R config.yaml

# Example run
cd ExampleData && ./runExample.sh

# Create conda environment
conda env create -f environment.yml
```

## NOTES
- zUMIs.sh sets `zUMIs_directory` in YAML, R scripts use this to source dependencies
- Binaries (miniconda) moved to `bin/` to reduce root clutter
- All source() paths in R scripts updated to new structure
