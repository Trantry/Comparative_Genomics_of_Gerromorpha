#!/bin/bash
#SBATCH --job-name=Download_SRA
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --time=02-15:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

cd /scratch/Cascade/tbessonn/TMP_Transcriptome
# Pour chaque */SraAccList.csv, télécharge chaque accession puis convertit en FASTQ dans le même dossier.
fasterq-dump SRR22799258 SRR5305050 --split-3 -O fastq --threads 4 && pigz -p 4 fastq/*.fastq
