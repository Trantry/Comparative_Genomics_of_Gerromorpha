#!/bin/bash
#SBATCH --job-name=pal2nal
#SBATCH --array=1-897
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=04:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate seqkit

INOG=/home/tbessonn/5_CODEML/3_orthofinder/OrthoFinder/Results_May13/Single_Copy_Orthologue_Sequences
INALN=/home/tbessonn/5_CODEML/3_orthofinder/Single_Copy_Orthologue_Alignments_clustalo
CDS=/home/tbessonn/5_CODEML/2_filtered_isoforme
OUT=/home/tbessonn/5_CODEML/4_pal2nal
LIST=$INOG/og.list

mkdir -p $OUT/ids $OUT/cds $OUT/paml

F=$(sed -n ${SLURM_ARRAY_TASK_ID}p $LIST)
OG=${F%.fa}

grep '^>' $INOG/$F | sed 's/^>//' > $OUT/ids/$OG.ids

> $OUT/cds/$OG.cds.fa
while read id; do
  sp=${id%%|*}
  seqkit grep -n -p "$id" $CDS/${sp}_cds.fa >> $OUT/cds/$OG.cds.fa
done < $OUT/ids/$OG.ids

pal2nal.pl $INALN/$OG.aln.fa $OUT/cds/$OG.cds.fa -output fasta -nogap -nomismatch > $OUT/paml/$OG.fasta
pal2nal.pl $INALN/$OG.aln.fa $OUT/cds/$OG.cds.fa -output paml -nogap -nomismatch > $OUT/paml/$OG.paml
