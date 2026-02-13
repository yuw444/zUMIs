# misc/ - Utility Scripts

**Part of:** ../AGENTS.md

## OVERVIEW
Standalone utility scripts for barcode demultiplexing, UMI correction, and expression counting. Called by main pipeline or run independently.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Barcode demux | `demultiplex_BC.py` | Python - pysam-based demultiplexing |
| Barcode demux (alt) | `demultiplex_BC.pl` | Perl version |
| UMI counting | `countUMIfrags.py` | Python - UMI deduplication |
| UMI correction | `correct_UBtag.py` | Python - UMI tag correction |
| RDS to Loom | `rds2loom.R` | R - expression matrix conversion |
| Feature counts | `featureCounts.R` | R - read counting wrapper |
| Merge demux | `merge_demultiplexed_fastq.R` | R - merge FASTQ outputs |

## CONVENTIONS
- Python: `argparse` CLI, `if __name__ == "__main__": main()` pattern
- Perl: `.pl` suffix, typical Perl read processing
- R: `Rscript` execution, YAML input optional

## ANTI-PATTERNS
- Missing dependency resolution - `pysam` may not be installed in base env

## NOTES
- Python scripts in `misc/` can run standalone
- Some overlap in functionality (Python vs Perl demux)
