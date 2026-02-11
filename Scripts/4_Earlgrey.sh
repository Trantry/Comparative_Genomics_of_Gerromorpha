#!/bin/bash
#SBATCH --array=0-4
#SBATCH --job-name=Pentatomorpha_earlgrey
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=364G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

# Minimal SLURM array: one genome per line in genomes.txt (absolute paths).
# Place genomes*.txt next to this script.

WORKDIR=/home/tbessonn/2_Earlgrey
#GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/genomes_gerromorpha.txt
#GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/genomes_cimicomorpha.txt
#GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/genomes_nepomorpha.txt
GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/genomes_pentatomorpha.txt
read KEY GENOME < <(sed -n "$((SLURM_ARRAY_TASK_ID+1))p" $GENOME_FILE)

OUTDIR=$WORKDIR/$KEY
mkdir -p $OUTDIR

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate earlgrey
earlGrey -g $GENOME -s $KEY -o $OUTDIR -d yes -t 32 -e yes

conda deactivate
