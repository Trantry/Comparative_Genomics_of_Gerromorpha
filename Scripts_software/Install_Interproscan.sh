#!/bin/bash
#SBATCH --job-name=Interpro_install
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

cd /home/tbessonn/bin/Interproscan/
wget -O interproscan-5.77-108.0-64-bit.tar.gz \
  https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.77-108.0/interproscan-5.77-108.0-64-bit.tar.gz

wget -O interproscan-5.77-108.0-64-bit.tar.gz.md5 \
  https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.77-108.0/interproscan-5.77-108.0-64-bit.tar.gz.md5

md5sum -c interproscan-5.77-108.0-64-bit.tar.gz.md5
python3 setup.py -f interproscan.properties
