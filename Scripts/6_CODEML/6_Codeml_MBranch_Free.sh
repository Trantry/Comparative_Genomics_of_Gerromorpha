#!/bin/bash
#SBATCH --job-name=codeml_free_vs_one
#SBATCH --array=1-897
#SBATCH --cpus-per-task=1
#SBATCH --mem=6G
#SBATCH --time=03-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

LIST=/home/tbessonn/5_CODEML/6_codeml/og.list
PAML=/home/tbessonn/5_CODEML/4_pal2nal/paml
TREE=/home/tbessonn/5_CODEML/5_Raxml/species_tree.rooted_Ran_chi.nwk
TPL=/home/tbessonn/5_CODEML/6_codeml/templates/branch.tpl.ctl
OUT=/home/tbessonn/5_CODEML/6_codeml/free_vs_one

OG=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $LIST)
mkdir -p $OUT/$OG
cd $OUT/$OG

# one-ratio
sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|one_ratio.out|g" \
  -e "s|MODEL|0|g" \
  $TPL > one_ratio.ctl
codeml one_ratio.ctl > one_ratio.log 2>&1

# free-ratio
sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|free_ratio.out|g" \
  -e "s|MODEL|1|g" \
  $TPL > free_ratio.ctl
codeml free_ratio.ctl > free_ratio.log 2>&1
