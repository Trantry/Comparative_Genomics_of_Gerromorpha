#!/bin/bash
#SBATCH --job-name=Isoforme_filtre
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

cd /home/tbessonn/4_orthofinder

for f in *.fasta; do
  python /home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/5_Orthofinder/filter_isoforme.py < $f > filtered/$f
done
