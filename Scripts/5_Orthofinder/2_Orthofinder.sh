#!/bin/bash
#SBATCH --job-name=orthofinder_rooted_defaut
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=256G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate ortho

orthofinder -f /home/tbessonn/4_orthofinder/filtered -a 64 -t 64 -s /home/tbessonn/4_orthofinder/tree/species_tree_ranatra_rooted.nwk

#orthofinder -f /home/tbessonn/4_orthofinder -a 64 -t 64 -M msa -A famsa -T iqtree3 -s /home/tbessonn/4_orthofinder/tree/species_tree_ranatra_rooted.nwk
