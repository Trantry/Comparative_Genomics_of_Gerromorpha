#!/bin/bash
#SBATCH --job-name=Download_SRA
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48G
#SBATCH --time=05-15:00:00
#SBATCH --partition=Cascade
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err


# Pour chaque */SraAccList.csv, télécharge chaque accession puis convertit en FASTQ dans le même dossier.
for csv in /scratch/Cascade/tbessonn/RNA-seq/*/SraAccList.csv; do
  dir=$(dirname "$csv")
  tail -n +2 "$csv" | while read acc; do
    prefetch "$acc" --max-size u -O "$dir"
    (cd "$dir" && fasterq-dump "$acc" -e 16 --outdir "$dir")
  done
done
