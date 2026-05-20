#!/bin/bash
#SBATCH --job-name=codeml_MBranchsite
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

# model = 2
# NSsites = 2

# icode = 0

# fix_kappa = 0
# kappa = 2

# fix_omega = FIXOMEGA
# omega = OMEGA

# cleandata = 1

#2_Launch codeml_Branch Model
LIST=/home/tbessonn/5_CODEML/6_codeml/og.list
PAML=/home/tbessonn/5_CODEML/4_pal2nal/paml
TREE=/home/tbessonn/5_CODEML/5_Raxml/species_tree.rooted_Ran_chi_marked_ancestor.nwk
TPL=/home/tbessonn/5_CODEML/6_codeml/templates/branchsite.tpl.ctl
OUT=/home/tbessonn/5_CODEML/6_codeml/branchsite_gerromorpha

OG=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $LIST)
mkdir -p $OUT/$OG
cd $OUT/$OG

# ALT: fix_omega=0 (omega estimé)
sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|bsA_alt.out|g" \
  -e "s|FIXOMEGA|0|g" \
  -e "s|OMEGA|0.4|g" \
  $TPL > bsA_alt.ctl
codeml bsA_alt.ctl > bsA_alt.log 2>&1

# NULL: fix_omega=1 omega=1
sed \
  -e "s|SEQFILE|$PAML/$OG.paml|g" \
  -e "s|TREEFILE|$TREE|g" \
  -e "s|OUTFILE|bsA_null.out|g" \
  -e "s|FIXOMEGA|1|g" \
  -e "s|OMEGA|1|g" \
  $TPL > bsA_null.ctl
codeml bsA_null.ctl > bsA_null.log 2>&1
