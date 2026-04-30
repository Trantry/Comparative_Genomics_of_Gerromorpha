#!/bin/bash
#SBATCH --array=1-21
#SBATCH --job-name=Blastp
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=254G
#SBATCH --time=01-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

#Variables
WORKDIR=/home/tbessonn/1_AGAT/1_Blastp
REFDB=$WORKDIR/UniprotKB_arthropoda
PROT_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_prot_heteroptera.txt
read KEY PROT < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$PROT_FILE")

#1st Blastp vs UniprotKB
# mkdir -p $WORKDIR/$KEY
# cd $WORKDIR/$KEY
# #diamond makedb --in /Xnfs/khila/database/UniprotKB_arthropoda_db_04_2026/uniprotkb_arthropoda.fasta -d /home/tbessonn/1_ANNIE/1_Blastp/UniprotKB_arthropoda

# if ls "$WORKDIR/$KEY"/*.outfmt6 1> /dev/null 2>&1; then
#     echo "Skipping $KEY: .outfmt6 found in $WORKDIR/$KEY"
# else
#     diamond blastp \
#     --query $PROT \
#     --db $REFDB \
#     --outfmt 6 \
#     --sensitive \
#     --max-target-seqs 1 \
#     --evalue 1e-3 \
#     --threads 32 \
#     --out $WORKDIR/$KEY/$KEY.outfmt6
# fi

#2nd Blastp vs Swissport DB
# mkdir -p $WORKDIR/2nd_BLAST/$KEY
# cd $WORKDIR/2nd_BLAST/$KEY

# # diamond makedb --in $PROT -d $WORKDIR/2nd_BLAST/$KEY/$KEY

# if ls $WORKDIR/2nd_BLAST/$KEY/*.outfmt6 1> /dev/null 2>&1; then
#     echo "Skipping $KEY: .outfmt6 found in $WORKDIR/2nd_BLAST/$KEY"
# else
#     diamond blastp \
#     --query /Xnfs/khila/database/UniprotKB_arthropoda_db_04_2026/uniprotkb_arthropoda.fasta \
#     --db $WORKDIR/2nd_BLAST/$KEY/$KEY \
#     --outfmt 6 \
#     --sensitive \
#     --max-target-seqs 1 \
#     --evalue 1e-3 \
#     --threads 32 \
#     --out $WORKDIR/2nd_BLAST/$KEY/$KEY.outfmt6
# fi

#RBH (reciprocal best hit)
FWD=$WORKDIR/$KEY/$KEY.outfmt6
REV=$WORKDIR/2nd_BLAST/$KEY/$KEY.outfmt6

mkdir -p $WORKDIR/RBH

cut -f1,2 $FWD | sort -u > $WORKDIR/RBH/${KEY}.A.pairs
cut -f1,2 $REV | awk -F'\t' '{print $2"\t"$1}' | sort -u > $WORKDIR/RBH/${KEY}.B.rev
comm -12 $WORKDIR/RBH/${KEY}.A.pairs $WORKDIR/RBH/${KEY}.B.rev | awk -F'\t' 'FNR==NR{a[$1 FS $2]=1;next} (($1 FS $2) in a)' - $FWD > $WORKDIR/RBH/${KEY}.rbh.outfmt6
