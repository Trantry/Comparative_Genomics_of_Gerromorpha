#!/bin/bash
#SBATCH --array=0
#SBATCH --job-name=Syny
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=120G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate syny

cd /home/tbessonn/3_SYNY

run_syny.pl -a *.gbk \
    -t 24 \
    --minsize 27210132 \
    --aligner mashmap \
    -o /home/tbessonn/3_SYNY
