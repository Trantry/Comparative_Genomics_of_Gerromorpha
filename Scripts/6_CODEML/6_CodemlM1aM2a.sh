#!/bin/bash
#SBATCH --job-name=codeml_M1aM2A
#SBATCH --array=1-897
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=04-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

LIST=/home/tbessonn/5_CODEML/6_codeml/og.list
PAML=/home/tbessonn/5_CODEML/4_pal2nal/paml
TREE=/home/tbessonn/5_CODEML/5_Raxml/species_tree.rooted_Ran_chi.nwk
TPL=/home/tbessonn/5_CODEML/6_codeml/templates/site.tpl.ctl
OUT=/home/tbessonn/5_CODEML/6_codeml/M1aM2a

OG=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$LIST")
mkdir -p "$OUT/$OG"
cd "$OUT/$OG"

sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|M1a.out|g" \
  -e "s|NSSITES|1|g" \
  "$TPL" > M1a.ctl
codeml M1a.ctl > M1a.log 2>&1

sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|M2a.out|g" \
  -e "s|NSSITES|2|g" \
  "$TPL" > M2a.ctl
codeml M2a.ctl > M2a.log 2>&1
