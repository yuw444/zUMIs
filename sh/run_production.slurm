#!/bin/bash
#SBATCH --job-name=zUMIs_production
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=7gb
#SBATCH --time=2-00:00:00
#SBATCH --account=chlin
#SBATCH --output=%x.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ywang@mcw.edu

source /home/yu89975/miniconda/etc/profile.d/conda.sh
conda activate zUMIs

cd /scratch/g/chlin/Yu/zUMIs

rm -rf production_output/* production_config.yml 2>/dev/null || true

bash run_production.sh

echo "Pipeline completed at $(date)"
