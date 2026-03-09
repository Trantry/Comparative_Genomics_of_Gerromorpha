#!/bin/bash
#SBATCH --array=1-16
#SBATCH --job-name=Seqret
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=200G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate syny

#Variables
WORKDIR=/home/tbessonn/3_Gff_to_Gbk
GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/All_genomes_heteroptera.txt
GFF_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/4_Synteny/All_gff_heteroptera.txt
read KEY GENOME < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GENOME_FILE")
read KEY GFF < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GFF_FILE")

mkdir -p $WORKDIR/$KEY
cd $WORKDIR/$KEY

if ls "$WORKDIR/$KEY"/*.genbank 1> /dev/null 2>&1; then
    echo "Skipping $KEY: .genbank found in $WORKDIR/$KEY"
else
    seqret -sequence $GENOME \
        -feature -fformat gff -fopenfile $GFF \
        -osformat genbank -osname_outseq $KEY \
        -ofdirectory_outseq $WORKDIR/$KEY \
        -auto
fi
