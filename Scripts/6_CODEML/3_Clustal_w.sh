#!/bin/bash
#SBATCH --job-name=clustal_w
#SBATCH --array=1-897
#SBATCH --cpus-per-task=4
#SBATCH --mem=2G
#SBATCH --time=02:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

# cd /home/tbessonn/5_CODEML/3_orthofinder/OrthoFinder/Results_May13/Single_Copy_Orthologue_Sequences
# ls OG*.fa > og.list
# wc -l og.list
IN=/home/tbessonn/5_CODEML/3_orthofinder/OrthoFinder/Results_May13/Single_Copy_Orthologue_Sequences
OUT=/home/tbessonn/5_CODEML/3_orthofinder/Single_Copy_Orthologue_Alignments_clustalo
LIST=$IN/og.list

mkdir -p $OUT

f=$(sed -n ${SLURM_ARRAY_TASK_ID}p $LIST)
base="${f%.fa}"

clustalo -i $IN/$f \
  -o $OUT/${base}.aln.fa \
  --outfmt=fasta --force \
  --threads ${SLURM_CPUS_PER_TASK}
