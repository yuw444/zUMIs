#!/bin/bash
# Integration test for zUMIs barcode detection stage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "zUMIs Barcode Detection Stage Test"
echo "========================================"

# Test zUMIs-BCdetection.R
echo ""
echo "Test: zUMIs-BCdetection.R"
if Rscript -e "parse('${ZUMIS_DIR}/barcode/zUMIs-BCdetection.R')" 2>/dev/null; then
    echo "  [PASS] zUMIs-BCdetection.R syntax valid"
else
    echo "  [FAIL] zUMIs-BCdetection.R has errors"
    exit 1
fi

# Test barcodeIDFUN.R
echo ""
echo "Test: barcodeIDFUN.R"
if Rscript -e "parse('${ZUMIS_DIR}/barcode/barcodeIDFUN.R')" 2>/dev/null; then
    echo "  [PASS] barcodeIDFUN.R syntax valid"
else
    echo "  [FAIL] barcodeIDFUN.R has errors"
    exit 1
fi

# Test readYaml4fqfilter.R
echo ""
echo "Test: readYaml4fqfilter.R"
if Rscript -e "parse('${ZUMIS_DIR}/barcode/readYaml4fqfilter.R')" 2>/dev/null; then
    echo "  [PASS] readYaml4fqfilter.R syntax valid"
else
    echo "  [FAIL] readYaml4fqfilter.R has errors"
    exit 1
fi

echo ""
echo "========================================"
echo "Barcode detection stage tests complete!"
echo "========================================"
