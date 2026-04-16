#!/bin/bash
#SBATCH --array=0
#SBATCH --job-name=rename_chromosome
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate base

python /home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/rename_chromosome.py \
  --mapping /home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/correspondence_table.txt \
  --genomes /home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/All_filtered_genomes_heteroptera.txt \
  --gffs /home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/All_gff_heteroptera.txt \
  --out-dir /home/tbessonn/3_Rename_chromosome \
  --skip-missing \
  --match-basename
