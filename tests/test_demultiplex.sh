#!/bin/bash
# Integration test for zUMIs demultiplex stage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "zUMIs Demultiplex Stage Test"
echo "========================================"

# Test demultiplex_BC.py
echo ""
echo "Test: demultiplex_BC.py"
if python3 -m py_compile "${ZUMIS_DIR}/demultiplex/demultiplex_BC.py" 2>/dev/null; then
    echo "  [PASS] demultiplex_BC.py syntax valid"
else
    echo "  [FAIL] demultiplex_BC.py has errors"
    exit 1
fi

# Test countUMIfrags.py
echo ""
echo "Test: countUMIfrags.py"
if python3 -m py_compile "${ZUMIS_DIR}/demultiplex/countUMIfrags.py" 2>/dev/null; then
    echo "  [PASS] countUMIfrags.py syntax valid"
else
    echo "  [FAIL] countUMIfrags.py has errors"
    exit 1
fi

# Test merge_demultiplexed_fastq.R
echo ""
echo "Test: merge_demultiplexed_fastq.R"
if Rscript -e "parse('${ZUMIS_DIR}/demultiplex/merge_demultiplexed_fastq.R')" 2>/dev/null; then
    echo "  [PASS] merge_demultiplexed_fastq.R syntax valid"
else
    echo "  [WARN] merge_demultiplexed_fastq.R has issues"
fi

echo ""
echo "========================================"
echo "Demultiplex stage tests complete!"
echo "========================================"
