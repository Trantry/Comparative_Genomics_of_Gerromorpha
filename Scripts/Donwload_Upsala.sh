#!/bin/bash
#SBATCH --job-name=Download
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=05-00:00:00
#SBATCH --partition=Cascade
#SBATCH --output=/home/tbessonn/stdout/%A_%a.out # standard output file format
#SBATCH --error=/home/tbessonn/stderr/%A_%a.err # error file format

mkdir -p water_striders
cd water_striders
wget -r -np -nH --cut-dirs=2 -R "index.html*" https://export.uppmax.uu.se/snic2019-35-58/water_striders/
