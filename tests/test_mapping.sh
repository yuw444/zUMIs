#!/bin/bash
# Integration test for zUMIs mapping stage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "zUMIs Mapping Stage Test"
echo "========================================"

# Test zUMIs-mapping.R
echo ""
echo "Test: zUMIs-mapping.R"
if Rscript -e "parse('${ZUMIS_DIR}/mapping/zUMIs-mapping.R')" 2>/dev/null; then
    echo "  [PASS] zUMIs-mapping.R syntax valid"
else
    echo "  [FAIL] zUMIs-mapping.R has errors"
    exit 1
fi

# Test zUMIs-bbmap.R
echo ""
echo "Test: zUMIs-bbmap.R"
if Rscript -e "parse('${ZUMIS_DIR}/mapping/zUMIs-bbmap.R')" 2>/dev/null; then
    echo "  [PASS] zUMIs-bbmap.R syntax valid"
else
    echo "  [FAIL] zUMIs-bbmap.R has errors"
    exit 1
fi

echo ""
echo "========================================"
echo "Mapping stage tests complete!"
echo "========================================"
