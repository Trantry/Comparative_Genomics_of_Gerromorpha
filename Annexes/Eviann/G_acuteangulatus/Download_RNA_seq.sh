#!/bin/bash
#SBATCH --job-name=Eviann
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=00-15:00:00
#SBATCH --partition=Cascade
#SBATCH --output=/home/tbessonn/stdout/%A_%a.out # standard output file format
#SBATCH --error=/home/tbessonn/stderr/%A_%a.err # error file format

cd /home/tbessonn/ressources/RNA_seq/G_acuteangulatus

wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR128/026/ERR12861026/ERR12861026_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR128/026/ERR12861026/ERR12861026_1.fastq.gz
