#!/bin/bash
#SBATCH --array=0-19
#SBATCH --job-name=Eviann
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate eviann

#Variables
WORKDIR=/scratch/Cascade/tbessonn/Eviann
EVIANN=${HOME}/miniconda3/envs/eviann/bin/eviann.sh
PROT=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/Heteroptera_Sternorrhyncha_G_buenoi_prot.fasta
TRANSCRIPTOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_transcriptomes_heteroptera.txt
RNASEQ_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_RNA-seq_heteroptera.txt
GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_genomes_heteroptera.txt
read KEY GENOME < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GENOME_FILE")
read KEY RNASEQ  < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$RNASEQ_FILE")
read KEY TRANSCRIPTOME < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$TRANSCRIPTOME_FILE")

OUTDIR=$WORKDIR/$KEY
mkdir -p $OUTDIR


$EVIANN -g $GENOME \
        -p $PROT \
        -r $RNASEQ \
        -e $TRANSCRIPTOME \
        -t 32
