#!/bin/bash
#SBATCH --array=1
#SBATCH --job-name=Compare_GFF
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate agat

cd /home/tbessonn/1_tkt

agat_sp_compare_two_annotations.pl --gff1 /home/tbessonn/1_Eviann/Gerris_buenoi/genome.softmasked.fa.pseudo_label.gff \
    --gff2 /home/tbessonn/ressources/annotation/gerromorpha/gerris_buenoi/genome.genes.flybasewithcurated.gff3 \
    -o /home/tbessonn/1_tkt/test
