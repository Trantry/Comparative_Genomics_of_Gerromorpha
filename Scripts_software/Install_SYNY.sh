#!/bin/bash
#SBATCH --job-name=SYNY
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=00-01:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source "${HOME}/miniconda3/etc/profile.d/conda.sh"

# Creating a conda environment
conda create -n syny

# Activating the conda environment
conda activate syny

## Installing syny within the conda environment
conda install syny -c conda-forge -c bioconda -y
conda install -c bioconda -c conda-forge -y emboss
