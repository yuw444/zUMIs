#!/bin/bash
# Integration test for zUMIs counting stage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "zUMIs Counting Stage Test"
echo "========================================"

# Test zUMIs-dge2.R
echo ""
echo "Test: zUMIs-dge2.R"
if Rscript -e "parse('${ZUMIS_DIR}/counting/zUMIs-dge2.R')" 2>/dev/null; then
    echo "  [PASS] zUMIs-dge2.R syntax valid"
else
    echo "  [FAIL] zUMIs-dge2.R has errors"
    exit 1
fi

# Test runfeatureCountFUN.R
echo ""
echo "Test: runfeatureCountFUN.R"
if Rscript -e "parse('${ZUMIS_DIR}/counting/runfeatureCountFUN.R')" 2>/dev/null; then
    echo "  [PASS] runfeatureCountFUN.R syntax valid"
else
    echo "  [FAIL] runfeatureCountFUN.R has errors"
    exit 1
fi

# Test UMIstuffFUN.R
echo ""
echo "Test: UMIstuffFUN.R"
if Rscript -e "parse('${ZUMIS_DIR}/counting/UMIstuffFUN.R')" 2>/dev/null; then
    echo "  [PASS] UMIstuffFUN.R syntax valid"
else
    echo "  [FAIL] UMIstuffFUN.R has errors"
    exit 1
fi

# Test featureCounts.R
echo ""
echo "Test: featureCounts.R"
if Rscript -e "parse('${ZUMIS_DIR}/counting/featureCounts.R')" 2>/dev/null; then
    echo "  [PASS] featureCounts.R syntax valid"
else
    echo "  [FAIL] featureCounts.R has errors"
    exit 1
fi

echo ""
echo "========================================"
echo "Counting stage tests complete!"
echo "========================================"
