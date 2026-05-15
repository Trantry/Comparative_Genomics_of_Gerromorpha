#!/bin/bash
#SBATCH --job-name=codeml_MBranch
#SBATCH --array=1-897
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

#1_Creat template for .ctl
# seqfile = SEQFILE
# treefile = TREEFILE
# outfile = OUTFILE

# noisy = 3
# verbose = 1
# runmode = 0

# seqtype = 1
# CodonFreq = 2

# clock = 0
# aaDist = 0

# model = MODEL
# NSsites = 0

# icode = 0

# fix_kappa = 0
# kappa = 2

# fix_omega = 0
# omega = 0.4

# cleandata = 1

#3_Launch codeml_Branch Model
LIST=/home/tbessonn/5_CODEML/6_codeml/og.list
PAML=/home/tbessonn/5_CODEML/4_pal2nal/paml

TREE_NULL=/home/tbessonn/5_CODEML/5_Raxml/species_tree.rooted_Ran_chi.nwk
TREE_MARK=/home/tbessonn/5_CODEML/5_Raxml/species_tree.rooted_Ran_chi_marked.nwk

TPL=/home/tbessonn/5_CODEML/6_codeml/templates/branch.tpl.ctl
OUT=/home/tbessonn/5_CODEML/6_codeml/branch_gerromorpha

OG=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$LIST")
mkdir -p $OUT/$OG
cd $OUT/$OG

# one-ratio (null)
sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE_NULL|g" \
  -e "s|OUTFILE|one_ratio.out|g" \
  -e "s|MODEL|0|g" \
  $TPL > one_ratio.ctl
codeml one_ratio.ctl > one_ratio.log 2>&1

# two-ratio (alt, foreground=#1)
sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE_MARK|g" \
  -e "s|OUTFILE|two_ratio.out|g" \
  -e "s|MODEL|2|g" \
  $TPL > two_ratio.ctl
codeml two_ratio.ctl > two_ratio.log 2>&1
