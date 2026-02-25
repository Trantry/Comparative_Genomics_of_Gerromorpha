#!/bin/bash
#SBATCH --array=0-19
#SBATCH --job-name=Quast
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=01-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

WORKDIR=/home/tbessonn/0_Quast
GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/All_genomes_heteroptera.txt

read KEY GENOME < <(sed -n "$((SLURM_ARRAY_TASK_ID+1))p" $GENOME_FILE)

OUTDIR=$WORKDIR/$KEY
mkdir -p $OUTDIR

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate quast

quast --threads 8 $GENOME -o $OUTDIR

conda deactivate
