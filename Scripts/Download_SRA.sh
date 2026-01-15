#!/bin/bash
#SBATCH --job-name=Download_SRA
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=100G
#SBATCH --time=05-15:00:00
#SBATCH --partition=Cascade
#SBATCH --output=/home/tbessonn/stdout/%A_%a.out # standard output file format
#SBATCH --error=/home/tbessonn/stderr/%A_%a.err # error file format


# Simple : pour chaque */SraAccList.csv, télécharge chaque accession puis convertit en FASTQ dans le même dossier.
for csv in /home/tbessonn/ressources/RNA_seq/*/SraAccList.csv; do
  dir=$(dirname "$csv")
  tail -n +2 "$csv" | while read acc; do
    prefetch "$acc" --max-size 1t -O "$dir"
    (cd "$dir" && fasterq-dump "$acc" -e 24 --outdir "$dir")
  done
done
