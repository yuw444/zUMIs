#!/bin/bash
# Integration test for zUMIs stats stage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "zUMIs Stats Stage Test"
echo "========================================"

# Test zUMIs-stats2.R
echo ""
echo "Test: zUMIs-stats2.R"
if Rscript -e "parse('${ZUMIS_DIR}/stats/zUMIs-stats2.R')" 2>/dev/null; then
    echo "  [PASS] zUMIs-stats2.R syntax valid"
else
    echo "  [FAIL] zUMIs-stats2.R has errors"
    exit 1
fi

# Test statsFUN.R
echo ""
echo "Test: statsFUN.R"
if Rscript -e "parse('${ZUMIS_DIR}/stats/statsFUN.R')" 2>/dev/null; then
    echo "  [PASS] statsFUN.R syntax valid"
else
    echo "  [FAIL] statsFUN.R has errors"
    exit 1
fi

echo ""
echo "========================================"
echo "Stats stage tests complete!"
echo "========================================"
