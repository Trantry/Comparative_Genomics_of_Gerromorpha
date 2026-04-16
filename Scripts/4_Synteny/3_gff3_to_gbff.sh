#!/bin/bash
#SBATCH --job-name=gff3_to_gbff
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=224G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate syny

#script de Pombert JF un peut modifier avec copilot pour qu'il marche avec les gff evian
cd /home/tbessonn/3_Rename_chromosome

/home/tbessonn/miniconda3/envs/syny/bin/gff3_to_gbff.pl \
    --fasta */*.fa \
    --gff3 */*.gff \
    --outdir /home/tbessonn/3_SYNY \
    --gcode 1 \
    --verbose

/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/6_odp/test.pl \
    --fasta /home/tbessonn/3_Rename_chromosome/Adelphocoris_suturalis/Adelphocoris_suturalis.filtered_renamed.fa \
    --gff3 /home/tbessonn/3_Rename_chromosome/Adelphocoris_suturalis/Adelphocoris_suturalis.filtered_renamed.gff \
    --outdir /home/tbessonn/test \
    --gcode 1 \
    --verbose
