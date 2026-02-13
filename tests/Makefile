# zUMIs Test Suite Makefile

ZUMIS_DIR := $(shell cd .. && pwd)

.PHONY: all test filtering demultiplex barcode mapping counting stats postprocess config clean help

# Default target
all: test

# Run all tests
test: filtering demultiplex barcode mapping counting stats postprocess config
	@echo ""
	@echo "========================================"
	@echo "All zUMIs pipeline tests passed!"
	@echo "========================================"

# Run filtering stage tests
filtering:
	@echo "========================================"
	@echo "Testing: Filtering Stage"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/test_filtering.sh

# Run demultiplex stage tests
demultiplex:
	@echo "========================================"
	@echo "Testing: Demultiplex Stage"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/test_demultiplex.sh

# Run barcode detection stage tests
barcode:
	@echo "========================================"
	@echo "Testing: Barcode Detection Stage"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/test_barcode.sh

# Run mapping stage tests
mapping:
	@echo "========================================"
	@echo "Testing: Mapping Stage"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/test_mapping.sh

# Run counting stage tests
counting:
	@echo "========================================"
	@echo "Testing: Counting Stage"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/test_counting.sh

# Run stats stage tests
stats:
	@echo "========================================"
	@echo "Testing: Stats Stage"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/test_stats.sh

# Run postprocess stage tests
postprocess:
	@echo "========================================"
	@echo "Testing: Postprocess Stage"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/test_postprocess.sh

# Run config tests
config:
	@echo "========================================"
	@echo "Testing: Configuration"
	@echo "========================================"
	@bash $(ZUMIS_DIR)/tests/run_tests.sh config

# Clean test output
clean:
	@rm -rf $(ZUMIS_DIR)/tests/data
	@echo "Cleaned test data"

# Show help
help:
	@echo "zUMIs Test Suite"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all         - Run all tests (default)"
	@echo "  test        - Run all tests"
	@echo "  filtering   - Test filtering stage"
	@echo "  demultiplex - Test demultiplex stage"
	@echo "  barcode     - Test barcode detection stage"
	@echo "  mapping     - Test mapping stage"
	@echo "  counting    - Test counting stage"
	@echo "  stats       - Test stats stage"
	@echo "  postprocess - Test postprocess stage"
	@echo "  config      - Test configuration files"
	@echo "  clean       - Clean test output"
	@echo "  help        - Show this help message"
