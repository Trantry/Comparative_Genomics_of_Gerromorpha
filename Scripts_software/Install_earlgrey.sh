#!/bin/bash
#SBATCH --job-name=install_earlgrey
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
mamba create -n earlgrey -c conda-forge -c bioconda earlgrey
mamba activate earlgrey
