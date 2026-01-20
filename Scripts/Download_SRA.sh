#!/bin/bash
#SBATCH --job-name=Download_SRA
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=05-15:00:00
#SBATCH --partition=Lake
#SBATCH --output=/home/tbessonn/stdout/%A_%a.out # standard output file format
#SBATCH --error=/home/tbessonn/stderr/%A_%a.err # error file format


# Simple : pour chaque */SraAccList.csv, télécharge chaque accession puis convertit en FASTQ dans le même dossier.
for csv in /scratch/Bio/tbessonn/RNA_seq/*/SraAccList.csv; do
  dir=$(dirname "$csv")
  tail -n +2 "$csv" | while read acc; do
    prefetch "$acc" --max-size u -O "$dir"
    (cd "$dir" && fasterq-dump "$acc" -e 16 --outdir "$dir")
  done
done
