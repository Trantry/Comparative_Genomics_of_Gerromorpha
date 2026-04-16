#!/bin/bash
#SBATCH --array=1-16
#SBATCH --job-name=Seqkit
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=120G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate seqkit
#Variables
WORKDIR=/home/tbessonn/3_Seqkit
GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/All_genomes_heteroptera.txt
MINLEN_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/Minlen_genome.txt
read KEY GENOME < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GENOME_FILE")
read KEY MINLEN < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$MINLEN_FILE")

mkdir -p $WORKDIR/$KEY
cd $WORKDIR/$KEY

seqkit seq -m $MINLEN $GENOME \
    -o $KEY.filtered.fa
#For Ranatra chinensis after that I removed by myself the contig not named CM... (so all the JBFD...)
