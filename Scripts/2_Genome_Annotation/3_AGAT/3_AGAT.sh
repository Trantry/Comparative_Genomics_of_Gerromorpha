#!/bin/bash
#SBATCH --array=1-21
#SBATCH --job-name=AGAT
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate agat

# #Variables
OUTDIR=/home/tbessonn/1_AGAT/2_AGAT
INTERPRO_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/3_AGAT/All_interprotsv.txt
BLAST_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/3_AGAT/All_blast.txt
GFF_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/3_AGAT/All_gff.txt
# #Interpro
read KEY TSV < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$INTERPRO_FILE")
#Blast
read KEY OUTFMT < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$BLAST_FILE")
read KEY GFF < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GFF_FILE")
cd $OUTDIR/

agat_sp_manage_functional_annotation.pl \
  --gff $GFF \
  --blast $OUTFMT \
  --db /Xnfs/khila/database/UniprotKB_arthropoda_db_04_2026/uniprotkb_arthropoda.fasta \
  --interpro $TSV \
  --output $OUTDIR/${KEY}

# agat_sp_functional_statistics.pl --gff /home/tbessonn/1_AGAT/Gerris_odontogaster/gerris_odontogaster_long.PolcaCorrected.sixth_polished.fa.pseudo_label.gff -o /home/tbessonn/1_AGAT/test/caca
