#!/bin/bash
#SBATCH --job-name=install_orthofinder
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source "${HOME}/miniconda3/etc/profile.d/conda.sh"

# Configuration des canaux conda
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

# Installation avec Conda/Mamba
conda init
source ~/.bashrc

# Installation avec conda
conda create -y --name ortho
conda install -y --name ortho orthofinder

conda activate ortho
orthofinder -h
