# PROJECT KNOWLEDGE BASE

**Generated:** 2026-02-13
**Commit:** 2039a90913b1b12e4fa48212fe6054badc1d1c09
**Branch:** main

## OVERVIEW
zUMIs - UCLA/Mount Sinai RNA-seq pipeline. Perl/R/Python/Bash workflow for single-cell RNA-seq analysis with barcode demultiplexing, mapping (STAR), and expression quantification.

## STRUCTURE
```
./
├── zUMIs.sh              # Main entry point (Bash orchestrator)
├── zUMIs.yaml            # Pipeline config schema
├── *.R                   # R scripts (mapping, stats, QC)
├── *.pm                  # Perl modules
├── misc/                 # Utility scripts (Python/R)
└── ExampleData/          # Test data + example YAML
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Run pipeline | `./zUMIs.sh -y config.yaml` | Bash orchestrator |
| Config schema | `./zUMIs.yaml` | YAML config reference |
| Mapping logic | `zUMIs-mapping.R` | STAR alignment |
| Stats/QC | `zUMIs-stats2.R` | Expression metrics |
| Demultiplexing | `misc/demultiplex_BC.py` | Barcode demux |
| UMI correction | `misc/countUMIfrags.py` | UMI counting |

## CONVENTIONS
- **CLI**: `./zUMIs.sh -y <yaml> -d <out_dir>`
- **R scripts**: Use `Rscript` + YAML input via `yaml::read_yaml`
- **Python scripts**: `argparse` + `if __name__ == "__main__": main()`
- **Perl modules**: `.pm` files for shared functions
- **Config**: YAML-based, validated by `checkyaml.R`

## ANTI-PATTERNS (THIS PROJECT)
- `splitfq.sh`: Undefined `FILE` variable in split command; function exits prematurely with `exit 1`
- `mergeBAM.sh`: Merge command is commented out - merge step not executed
- No test suite - testing conventions not established

## UNIQUE STYLES
- Mixed language pipeline (Bash→R→Python→Perl)
- YAML-driven workflow configuration
- Perls: Approx.pm (approximate matching), distilReads.pm (read processing)
- Shiny config UI: `zUMIs-config_shiny.R`

## COMMANDS
```bash
# Run full pipeline
./zUMIs.sh -y config.yaml -d output_dir

# Validate config
Rscript checkyaml.R config.yaml

# Example run
cd ExampleData && ./runExample.sh
```

## NOTES
- No centralized CLI - multiple entry points scattered (`zUMIs.sh`, individual Python/R scripts)
- No CI/CD workflows in `.github/` (only issue templates)
- No linting/formatting configs (eslint, black, etc.)
- Miniconda parts indicate bundled dependencies (multipart archive)
