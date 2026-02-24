# zUMIs Test Pipeline - Notes

## Current Status

### What Works
- `run_tests.sh` - Pipeline orchestrator works correctly
- YAML validation passes
- Executable detection works (via PATH=/home/yu89975/miniconda/envs/zUMIs/bin)
- test_filtering.sh starts but has issues

### What's Broken

#### 1. test_filtering.sh - splitfq.sh piping issue
The splitfq.sh script produces binary garbage output when splitting FASTQ files. This happens during the `split` command piping to pigz.

**Symptom**: After "Splitting FASTQ files..." the output is binary garbage instead of split FASTQ files.

**Location**: test_filtering.sh lines 60-66

**Root cause**: The `splitfq.sh` script uses shell piping that may not work correctly with the large test FASTQ files (~19GB, ~23GB).

#### 2. Remaining broken paths in zUMIs.sh (NOT FIXED)
Lines 260 and 279 still reference root-level paths:
- `fqfilter_v2.pl` → should be `filtering/fqfilter_v2.pl`
- `correct_BCtag.pl` → should be `filtering/correct_BCtag.pl`

These don't affect test scripts since they call scripts directly.

## Test Data
- FASTQ files: `/scratch/g/chlin/Yu/zUMIs/tests/data/`
  - Full data:
    - PBMCs.run2.read_1.fq.gz (19GB)
    - PBMCs.run2.read_2.fq.gz (23GB)
  - Sample (100K reads, for testing):
    - sample/read_1_sample.fq.gz (6.9MB)
    - sample/read_2_sample.fq.gz (8.5MB)
- Config: `/scratch/g/chlin/Yu/zUMIs/my_config.yml`
- Output: `/scratch/g/chlin/Yu/zUMIs/tests/output/`

## Fixes Already Applied

### Internal Path Fixes (8 files)
1. `filtering/fqfilter_v2.pl` - use lib path + readYaml4fqfilter.R path
2. `counting/zUMIs-dge2.R` - fcountsLib2 path
3. `counting/UMIstuffFUN.R` - correct_UBtag.py/pl paths
4. `stats/zUMIs-stats2.R` - countUMIfrags.py path

### Test Script Rewrites
- run_tests.sh - Full pipeline orchestrator
- test_filtering.sh - Filtering stage
- test_barcode.sh - Barcode detection
- test_mapping.sh - STAR mapping
- test_counting.sh - Expression counting
- test_stats.sh - QC statistics
- test_postprocess.sh - Loom/velocyto output
- test_demultiplex.sh - Demultiplex check

## Test Results

### Filtering (WORKS but simplified)
- Uses head -400000 to get subset of FASTQ for testing
- Works but produces small output that may not be enough for downstream stages

### Barcode Detection
- Runs but fails due to insufficient data (BCstats.txt is empty)
- Need more reads for proper barcode detection (at least a few million)

### Remaining Stages
- Not tested yet due to barcode stage requiring more data

## Known Issues

1. **splitfq.sh binary output**: The `split --filter` with pigz produces binary garbage. Used head-based approach instead.

2. **Small test data**: Only 400K reads processed - not enough for barcode detection. Consider increasing to 2-4M reads.

3. **Module system interference**: HPC module system adds extra arguments. Added `unset _ModuleTable_` to fix.

## How to Run

```bash
cd /scratch/g/chlin/Yu/zUMIs/tests

# Full pipeline
./run_tests.sh ../my_config.yml

# Single stage
./run_tests.sh ../my_config.yml filtering
./run_tests.sh ../my_config.yml mapping
# etc.
```
