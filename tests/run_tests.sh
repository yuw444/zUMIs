#!/bin/bash
# Test runner for zUMIs pipeline stages
# Usage: ./run_tests.sh [stage|all]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="$(dirname "$SCRIPT_DIR")"
EXAMPLE_DIR="${ZUMIS_DIR}/ExampleData"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED++))
}

log_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Test: Shell script syntax
test_shell_syntax() {
    local script=$1
    log_info "Testing shell syntax: $script"
    if bash -n "$script" 2>/dev/null; then
        log_pass "$script syntax OK"
        return 0
    else
        log_fail "$script has syntax errors"
        return 1
    fi
}

# Test: R script syntax
test_r_syntax() {
    local script=$1
    log_info "Testing R syntax: $script"
    if Rscript -e "parse('$script')" 2>/dev/null; then
        log_pass "$script syntax OK"
        return 0
    else
        log_fail "$script has syntax errors"
        return 1
    fi
}

# Test: Python script syntax
test_python_syntax() {
    local script=$1
    log_info "Testing Python syntax: $script"
    if python3 -m py_compile "$script" 2>/dev/null; then
        log_pass "$script syntax OK"
        return 0
    else
        log_fail "$script has syntax errors"
        return 1
    fi
}

# Test: YAML validity
test_yaml_syntax() {
    local yaml=$1
    log_info "Testing YAML syntax: $yaml"
    if python3 -c "import yaml; yaml.safe_load(open('$yaml'))" 2>/dev/null; then
        log_pass "$yaml is valid YAML"
        return 0
    else
        log_fail "$yaml has YAML errors"
        return 1
    fi
}

# Test: File exists
test_file_exists() {
    local file=$1
    local desc=$2
    if [ -f "$file" ]; then
        log_pass "$desc: $file exists"
        return 0
    else
        log_fail "$desc: $file not found"
        return 1
    fi
}

# Test: Directory exists
test_dir_exists() {
    local dir=$1
    local desc=$2
    if [ -d "$dir" ]; then
        log_pass "$desc: $dir exists"
        return 0
    else
        log_fail "$desc: $dir not found"
        return 1
    fi
}

# Run all tests
run_all_tests() {
    echo "========================================"
    echo "zUMIs Pipeline Test Suite"
    echo "========================================"
    echo ""

    echo "--- Stage 1: Filtering ---"
    test_shell_syntax "${ZUMIS_DIR}/filtering/splitfq.sh"
    test_shell_syntax "${ZUMIS_DIR}/filtering/mergeBAM.sh"
    test_file_exists "${ZUMIS_DIR}/filtering/fqfilter_v2.pl" "Perl filter"
    test_file_exists "${ZUMIS_DIR}/filtering/Approx.pm" "Perl module"
    echo ""

    echo "--- Stage 2: Demultiplex ---"
    test_python_syntax "${ZUMIS_DIR}/demultiplex/demultiplex_BC.py"
    test_python_syntax "${ZUMIS_DIR}/demultiplex/countUMIfrags.py"
    echo ""

    echo "--- Stage 3: Barcode Detection ---"
    test_r_syntax "${ZUMIS_DIR}/barcode/zUMIs-BCdetection.R"
    test_r_syntax "${ZUMIS_DIR}/barcode/barcodeIDFUN.R"
    echo ""

    echo "--- Stage 4: Mapping ---"
    test_r_syntax "${ZUMIS_DIR}/mapping/zUMIs-mapping.R"
    echo ""

    echo "--- Stage 5: Counting ---"
    test_r_syntax "${ZUMIS_DIR}/counting/zUMIs-dge2.R"
    test_r_syntax "${ZUMIS_DIR}/counting/runfeatureCountFUN.R"
    test_r_syntax "${ZUMIS_DIR}/counting/UMIstuffFUN.R"
    echo ""

    echo "--- Stage 6: Stats ---"
    test_r_syntax "${ZUMIS_DIR}/stats/zUMIs-stats2.R"
    test_r_syntax "${ZUMIS_DIR}/stats/statsFUN.R"
    echo ""

    echo "--- Stage 7: Postprocess ---"
    test_r_syntax "${ZUMIS_DIR}/postprocess/rds2loom.R"
    test_r_syntax "${ZUMIS_DIR}/postprocess/runVelocyto.R"
    echo ""

    echo "--- Configuration ---"
    test_yaml_syntax "${ZUMIS_DIR}/zUMIs.yaml"
    test_yaml_syntax "${ZUMIS_DIR}/ExampleData/runExample.yaml"
    test_file_exists "${ZUMIS_DIR}/environment.yml" "Conda env"
    echo ""

    echo "--- Directory Structure ---"
    test_dir_exists "${ZUMIS_DIR}/filtering" "Filtering stage"
    test_dir_exists "${ZUMIS_DIR}/demultiplex" "Demultiplex stage"
    test_dir_exists "${ZUMIS_DIR}/barcode" "Barcode stage"
    test_dir_exists "${ZUMIS_DIR}/mapping" "Mapping stage"
    test_dir_exists "${ZUMIS_DIR}/counting" "Counting stage"
    test_dir_exists "${ZUMIS_DIR}/stats" "Stats stage"
    test_dir_exists "${ZUMIS_DIR}/postprocess" "Postprocess stage"
    test_dir_exists "${ZUMIS_DIR}/bin" "Binaries"
    echo ""

    echo "========================================"
    echo "Test Summary"
    echo "========================================"
    echo -e "Passed: ${GREEN}${PASSED}${NC}"
    echo -e "Failed: ${RED}${FAILED}${NC}"
    echo ""

    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    fi
}

# Main
case "${1:-all}" in
    all)
        run_all_tests
        ;;
    filtering)
        echo "Testing Filtering Stage..."
        test_shell_syntax "${ZUMIS_DIR}/filtering/splitfq.sh"
        test_shell_syntax "${ZUMIS_DIR}/filtering/mergeBAM.sh"
        ;;
    demultiplex)
        echo "Testing Demultiplex Stage..."
        test_python_syntax "${ZUMIS_DIR}/demultiplex/demultiplex_BC.py"
        test_python_syntax "${ZUMIS_DIR}/demultiplex/countUMIfrags.py"
        ;;
    barcode)
        echo "Testing Barcode Detection Stage..."
        test_r_syntax "${ZUMIS_DIR}/barcode/zUMIs-BCdetection.R"
        ;;
    mapping)
        echo "Testing Mapping Stage..."
        test_r_syntax "${ZUMIS_DIR}/mapping/zUMIs-mapping.R"
        ;;
    counting)
        echo "Testing Counting Stage..."
        test_r_syntax "${ZUMIS_DIR}/counting/zUMIs-dge2.R"
        ;;
    stats)
        echo "Testing Stats Stage..."
        test_r_syntax "${ZUMIS_DIR}/stats/zUMIs-stats2.R"
        ;;
    config)
        echo "Testing Configuration..."
        test_yaml_syntax "${ZUMIS_DIR}/zUMIs.yaml"
        test_yaml_syntax "${ZUMIS_DIR}/ExampleData/runExample.yaml"
        exit 0
        ;;
    *)
        echo "Usage: $0 [stage|all]"
        echo "  Stages: filtering, demultiplex, barcode, mapping, counting, stats, config, all"
        exit 1
        ;;
esac
