#!/bin/bash
#SBATCH --array=1-21
#SBATCH --job-name=Interproscan
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

#Variables
WORKDIR=/home/tbessonn/1_AGAT/1_Interpro
PROT_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_prot_heteroptera.txt

read KEY PROT < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$PROT_FILE")
mkdir -p $WORKDIR/$KEY
cd $WORKDIR/$KEY

/home/tbessonn/bin/Interproscan/interproscan-5.77-108.0/interproscan.sh \
    -i $PROT \
    -f tsv \
    -goterms \
    -cpu 32 \
    -T /scratch/Cascade/tbessonn/TMP/$KEY \
    -o $WORKDIR/$KEY/$KEY.tsv
