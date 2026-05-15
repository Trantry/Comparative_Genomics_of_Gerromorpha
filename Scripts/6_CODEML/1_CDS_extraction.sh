#!/bin/bash
#SBATCH --array=1-21
#SBATCH --job-name=CDS_from_GFF
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=54G
#SBATCH --time=01-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source "${HOME}/miniconda3/etc/profile.d/conda.sh"

#Variables
WORKDIR=/home/tbessonn/5_CODEML
GFF_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/3_AGAT/All_gff.txt
GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_genomes_heteroptera.txt
read KEY GFF < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GFF_FILE")
read KEY GENOME < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GENOME_FILE")

mkdir -p $WORKDIR/1_CDS/$KEY
cd $WORKDIR/1_CDS/$KEY

#1 CDS extraction
gffread $GFF -g $GENOME -x ${KEY}_cds.fa -y ${KEY}_prot.fa

#2 Rename
conda activate seqkit

seqkit replace -p '^(\S+)' -r "${KEY}|\$1" "${KEY}_cds.fa"  > "${KEY}_cds_rename.fa"
seqkit replace -p '^(\S+)' -r "${KEY}|\$1" "${KEY}_prot.fa" > "${KEY}_prot_rename.fa"

#3 Filtering longest isoforme
mkdir -p $WORKDIR/2_filtered_isoforme/

python3 /home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/5_Orthofinder/filter_isoforme.py \
  < ${KEY}_prot_rename.fa \
  > $WORKDIR/2_filtered_isoforme/${KEY}.fa

#4 Matching de CDS to the longest isoforme
grep '^>' $WORKDIR/2_filtered_isoforme/${KEY}.fa \
  | sed 's/^>//' \
  > $WORKDIR/2_filtered_isoforme/${KEY}.keep_ids.txt

seqkit grep -f $WORKDIR/2_filtered_isoforme/${KEY}.keep_ids.txt \
  ${KEY}_cds_rename.fa \
  > $WORKDIR/2_filtered_isoforme/${KEY}_cds.fa

mkdir -p $WORKDIR/3_orthofinder/

cp $WORKDIR/2_filtered_isoforme/${KEY}.fa $WORKDIR/3_orthofinder/
