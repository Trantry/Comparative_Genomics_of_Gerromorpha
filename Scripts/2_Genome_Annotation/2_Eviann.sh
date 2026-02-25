#!/bin/bash
#SBATCH --array=1-20
#SBATCH --job-name=Eviann
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate eviann

#Variables
WORKDIR=/scratch/Cascade/tbessonn/Eviann
OUTDIR=/home/tbessonn/1_Eviann
EVIANN=${HOME}/miniconda3/envs/eviann/bin/eviann.sh
PROT=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/Heteroptera_Sternorrhyncha_G_buenoi_prot.fasta
TRANSCRIPTOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_transcriptomes_heteroptera.txt
#For paired-end:
#paste <(ls $PWD/*_1.fastq) <(ls $PWD/*_2.fastq) > paired.txt
# For single-end:
#ls "$PWD"/*.fastq | grep -Ev '(_1|_2)\.fastq$' >> paired.txt
RNASEQ_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_RNA-seq_heteroptera.txt
GENOME_FILE=/home/tbessonn/Comparative_Genomics_of_Gerromorpha/Scripts/2_Genome_Annotation/All_genomes_heteroptera.txt
read KEY GENOME < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$GENOME_FILE")
read KEY RNASEQ  < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$RNASEQ_FILE")
read KEY TRANSCRIPTOME < <(sed -n "${SLURM_ARRAY_TASK_ID}p" "$TRANSCRIPTOME_FILE")

mkdir -p $WORKDIR/$KEY
cd $WORKDIR/$KEY

if ls "$OUTDIR/$KEY"/*.gff 1> /dev/null 2>&1; then
    echo "Skipping $KEY: .gff found in $OUTDIR/$KEY"
else
    $EVIANN -g $GENOME \
            -p $PROT \
            -r $RNASEQ \
            -e $TRANSCRIPTOME \
            -t 32
fi
