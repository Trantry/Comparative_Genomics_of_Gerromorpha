#!/bin/bash
#SBATCH --array=0-13
#SBATCH --job-name=gffread
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --time=01-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

mkdir -p /home/tbessonn/1_gffread
WORKDIR=/home/tbessonn/1_gffread

# Fichier tabulé à 3 colonnes: KEY \t ANNOT \t GENOME
ANNOT_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/path_old_gtf.txt

read KEY ANNOT GENOME < <(sed -n "$((SLURM_ARRAY_TASK_ID+1))p" "$ANNOT_FILE")

OUTDIR="$WORKDIR/$KEY"
mkdir -p "$OUTDIR"

gffread "$ANNOT" -g "$GENOME" -w "$OUTDIR/${KEY}.transcripts.fa"
