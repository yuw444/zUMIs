#!/bin/bash
#SBATCH --job-name=cd4
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=45
#SBATCH --mem-per-cpu=3gb
#SBATCH --time=24:00:00
#SBATCH --account=chlin
#SBATCH --output=%x.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ywang@mcw.edu

module load R/4.2.1

Rscript /scratch/u/yu89975/Sh2b3/Sh2b3/src/scenic/lin_cd4.R

