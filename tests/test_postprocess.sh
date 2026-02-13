#!/bin/bash
# Integration test for zUMIs postprocess stage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "zUMIs Postprocess Stage Test"
echo "========================================"

# Test rds2loom.R
echo ""
echo "Test: rds2loom.R"
if Rscript -e "parse('${ZUMIS_DIR}/postprocess/rds2loom.R')" 2>/dev/null; then
    echo "  [PASS] rds2loom.R syntax valid"
else
    echo "  [FAIL] rds2loom.R has errors"
    exit 1
fi

# Test runVelocyto.R
echo ""
echo "Test: runVelocyto.R"
if Rscript -e "parse('${ZUMIS_DIR}/postprocess/runVelocyto.R')" 2>/dev/null; then
    echo "  [PASS] runVelocyto.R syntax valid"
else
    echo "  [FAIL] runVelocyto.R has errors"
    exit 1
fi

# Test zUMIs-config_shiny.R
echo ""
echo "Test: zUMIs-config_shiny.R"
if Rscript -e "parse('${ZUMIS_DIR}/postprocess/zUMIs-config_shiny.R')" 2>/dev/null; then
    echo "  [PASS] zUMIs-config_shiny.R syntax valid"
else
    echo "  [FAIL] zUMIs-config_shiny.R has errors"
    exit 1
fi

echo ""
echo "========================================"
echo "Postprocess stage tests complete!"
echo "========================================"
