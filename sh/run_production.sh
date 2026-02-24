#!/bin/bash
set -euo pipefail

export PATH="/home/yu89975/miniconda/envs/zUMIs/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZUMIS_DIR="${SCRIPT_DIR}"

OUTPUT_DIR="${1:-${SCRIPT_DIR}/production_output}"
CONFIG="${SCRIPT_DIR}/production_config.yml"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log_stage() { echo -e "\n${CYAN}========================================${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${CYAN}========================================${NC}"; }
log_info()  { echo -e "${YELLOW}[INFO]${NC} $1"; }
log_pass()  { echo -e "${GREEN}[PASS]${NC} $1"; }
log_fail()  { echo -e "${RED}[FAIL]${NC} $1"; }

echo "========================================"
echo "  zUMIs Production Pipeline"
echo "========================================"
log_info "Output directory: ${OUTPUT_DIR}"
log_info "Config: ${CONFIG}"

mkdir -p "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/zUMIs_output/"
mkdir -p "${OUTPUT_DIR}/zUMIs_output/expression"
mkdir -p "${OUTPUT_DIR}/zUMIs_output/stats"
mkdir -p "${OUTPUT_DIR}/zUMIs_output/.tmpMerge"

log_stage "Creating Production Config"

cat > "${CONFIG}" << 'EOF'
project: PBMCs_run2
sequence_files:
  file1:
    name: /scratch/g/chlin/Yu/zUMIs/tests/data/PBMCs.run2.read_1.fq.gz
    base_definition:
      - cDNA(25-100)
      - UMI(12-21)
    find_pattern: ATTGCGCAATG;2
  file2:
    name: /scratch/g/chlin/Yu/zUMIs/tests/data/PBMCs.run2.read_2.fq.gz
    base_definition:
      - cDNA(1-100)
      - BC(101-120)
reference:
  STAR_index: /scratch/g/chlin/library/hg38/star/
  GTF_file: /scratch/g/chlin/library/hg38/genes/genes.gtf
  additional_STAR_params: '--clip3pAdapterSeq CTGTCTCTTATACACATCT'
  additional_files:
out_dir: OUTPUT_PLACEHOLDER
read_layout: PE
num_threads: 20
mem_limit: 50
filter_cutoffs:
  BC_filter:
    num_bases: 4
    phred: 20
  UMI_filter:
    num_bases: 3
    phred: 20
barcodes:
  barcode_num: ~
  barcode_file: null
  automatic: yes
  BarcodeBinning: 1
  demultiplex: no
  nReadsperCell: 100
  discardReads: yes
counting_opts:
  introns: yes
  downsampling: '0'
  strand: 1
  Ham_Dist: 1
  velocyto: no
  primaryHit: yes
  twoPass: no
make_stats: yes
which_Stage: Filtering
samtools_exec: samtools
pigz_exec: pigz
STAR_exec: STAR
Rscript_exec: Rscript
EOF

sed -i "s|OUTPUT_PLACEHOLDER|${OUTPUT_DIR}|g" "${CONFIG}"

log_info "Config created: ${CONFIG}"

log_stage "Validating YAML Config"
Rscript "${ZUMIS_DIR}/filtering/checkyaml.R" "${CONFIG}" > "${OUTPUT_DIR}/Test_run.zUMIs_YAMLerror.log" 2>&1 || true
iserror=$(tail -n1 "${OUTPUT_DIR}/Test_run.zUMIs_YAMLerror.log" | awk '{print $2}' || true)
if [[ "${iserror:-0}" == "1" ]]; then
    log_fail "YAML validation failed. See: ${OUTPUT_DIR}/Test_run.zUMIs_YAMLerror.log"
    exit 1
fi
log_pass "YAML validation passed"

if grep -q 'zUMIs_directory:' "${CONFIG}" ; then
    sed -i "s|zUMIs_directory:.*|zUMIs_directory: ${ZUMIS_DIR}|" "${CONFIG}"
else
    echo "zUMIs_directory: ${ZUMIS_DIR}" >> "${CONFIG}"
fi

export ZUMIS_YAML="${CONFIG}"
export ZUMIS_DIR

FAILED=0

run_stage() {
    local stage_name="$1"
    local stage_map=""
    case "${stage_name}" in
        filtering) stage_map="Filtering" ;;
        barcode)    stage_map="Filtering" ;;
        mapping)    stage_map="Mapping" ;;
        counting)   stage_map="Counting" ;;
        stats)      stage_map="Summarising" ;;
        postprocess) stage_map="Summarising" ;;
    esac
    
    sed -i "s|which_Stage:.*|which_Stage: ${stage_map}|" "${CONFIG}"
    log_info "Updated which_Stage to: ${stage_map}"
    
    log_stage "Stage: ${stage_name}"
    
    
    case "${stage_name}" in
        filtering)
            bash "${SCRIPT_DIR}/zUMIs.sh" -y "${CONFIG}" -d "${SCRIPT_DIR}" || return 1
            ;;
        barcode)
            bash "${SCRIPT_DIR}/zUMIs.sh" -y "${CONFIG}" -d "${SCRIPT_DIR}" || return 1
            ;;
        mapping)
            bash "${SCRIPT_DIR}/zUMIs.sh" -y "${CONFIG}" -d "${SCRIPT_DIR}" || return 1
            ;;
        counting)
            bash "${SCRIPT_DIR}/zUMIs.sh" -y "${CONFIG}" -d "${SCRIPT_DIR}" || return 1
            ;;
        stats)
            bash "${SCRIPT_DIR}/zUMIs.sh" -y "${CONFIG}" -d "${SCRIPT_DIR}" || return 1
            ;;
        postprocess)
            bash "${SCRIPT_DIR}/zUMIs.sh" -y "${CONFIG}" -d "${SCRIPT_DIR}" || return 1
            ;;
    esac
   
    log_pass "Stage ${stage_name} completed"


}

for stage in filtering barcode mapping counting stats postprocess; do
    if ! run_stage "${stage}"; then
        log_fail "Pipeline failed at stage: ${stage}"
        FAILED=1
        break
    fi
done

echo ""
log_stage "Production Pipeline Summary"
if [ ${FAILED} -eq 0 ]; then
    log_pass "All stages completed successfully!"
    log_info "Output directory: ${OUTPUT_DIR}"
    exit 0
else
    log_fail "Some stages failed!"
    exit 1
fi
