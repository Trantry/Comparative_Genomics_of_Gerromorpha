#!/bin/bash
#SBATCH --job-name=codeml_M7M8
#SBATCH --array=1-897
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium,Lake
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

#1_Prep data

# ls /home/tbessonn/5_CODEML/4_pal2nal/paml/*.paml \
#   | sed 's|.*/||; s/\.paml$//' \
#   | sort > /home/tbessonn/5_CODEML/6_codeml/og.list
# wc -l /home/tbessonn/5_CODEML/6_codeml/og.list

#2_Creat template for .ctl
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

# model = 0
# NSsites = NSSITES

# icode = 0

# fix_kappa = 0
# kappa = 2

# fix_omega = 0
# omega = 0.4

# cleandata = 1

#3_Launch codeml_M7M8
LIST=/home/tbessonn/5_CODEML/6_codeml/og.list
PAML=/home/tbessonn/5_CODEML/4_pal2nal/paml
TREE=/home/tbessonn/5_CODEML/5_Raxml/species_tree.rooted_Ran_chi.nwk
TPL=/home/tbessonn/5_CODEML/6_codeml/templates/site.tpl.ctl
OUT=/home/tbessonn/5_CODEML/6_codeml/M7M8

OG=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $LIST)
mkdir -p $OUT/$OG
cd $OUT/$OG

sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|M7.out|g" \
  -e "s|NSSITES|7|g" \
  $TPL > M7.ctl
codeml M7.ctl > M7.log 2>&1

sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|M8.out|g" \
  -e "s|NSSITES|8|g" \
  $TPL > M8.ctl
codeml M8.ctl > M8.log 2>&1
