#!/bin/bash
#SBATCH --array=1-21
#SBATCH --job-name=ANNIE
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

#Variables
OUTDIR_IPR=/home/tbessonn/1_ANNIE/1_Interpro/ANNIE_output
OUTDIR_BLAST=/home/tbessonn/1_ANNIE/1_Blastp/ANNIE_output
INTERPRO_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/3_ANNIE/All_interprotsv.txt
BLAST_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/3_ANNIE/All_blast.txt
GFF_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/3_ANNIE/All_gff.txt

#Interpro ANNIE
read KEY TSV < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$INTERPRO_FILE")
cd $OUTDIR_IPR/

python3 /home/tbessonn/bin/Annie/annie.py \
    -ipr $TSV \
    -o $OUTDIR_IPR/${KEY}.annie.tsv

#Blast ANNIE
read KEY OUTFMT < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$BLAST_FILE")
read KEY GFF < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GFF_FILE")
cd $OUTDIR_BLAST/

python3 /home/tbessonn/bin/Annie/annie.py \
    -b $OUTFMT \
    -g $GFF \
    -db /Xnfs/khila/database/swissprot/2022_02/uniprot_sprot_trembl.fasta \
    -o $OUTDIR_BLAST/${KEY}.annie.tsv
