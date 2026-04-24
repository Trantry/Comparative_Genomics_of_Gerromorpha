#!/bin/bash
#SBATCH --job-name=dwonload_SP
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source "${HOME}/miniconda3/etc/profile.d/conda.sh"

# Set the conda channels
# conda config --add channels bioconda
# conda config --set channel_priority strict

# # Creating a conda environment
# conda create -n metaeuk metaeuk -y
# conda install -c bioconda mmseqs2 -y

conda activate metaeuk

cd /home/tbessonn/test

metaeuk databases UniRef100 UniRef100-DB tmp

metaeuk filtertaxseqdb \
UniRef100-DB \
UniRef100-DB.arthropoda \
--taxon-list 6656
mmseqs convert2fasta UniRef100-DB.arthropoda UniRef100_arthropoda.fasta

# url='https://rest.uniprot.org/uniprotkb/search?format=fasta&query=taxonomy_id:6656&size=500'
# : > uniprotkb_arthropoda.fasta

# while [ -n "$url" ]; do
#   curl -sS -D h "$url" >> uniprotkb_arthropoda.fasta
#   url=$(awk -F'[<>]' 'tolower($0) ~ /^link:/ && $0 ~ /rel="next"/ {print $2}' h | head -n1)
# done
