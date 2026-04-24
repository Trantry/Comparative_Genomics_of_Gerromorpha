#!/bin/bash
#SBATCH --job-name=jcvi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=224G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source "${HOME}/miniconda3/etc/profile.d/conda.sh"

# cd /home/tbessonn/bin

# git clone https://github.com/tanghaibao/jcvi

# cd jcvi/

# conda env create -f environment.yml

#conda activate jcvi

# jcvi --version

conda activate jcvi
cd /home/tbessonn/3_JCVI

# python -m jcvi.formats.gff bed --type=mRNA --key=Name --primary_only /home/tbessonn/1_Eviann/Gerris_lacustris/GCA_951217055.1_ihGerLacu2.1_genomic.fna.pseudo_label.gff -o Gerris_lacustris.bed
# python -m jcvi.formats.gff bed --type=mRNA --key=Name --primary_only /home/tbessonn/1_Eviann/Gerris_odontogaster/gerris_odontogaster_long.PolcaCorrected.sixth_polished.fa.pseudo_label.gff -o Gerris_odontogaster.bed

python -m jcvi.formats.fasta format --primary_only /home/tbessonn/1_Eviann/Gerris_lacustris/GCA_951217055.1_ihGerLacu2.1_genomic.fna.proteins.fasta Gerris_lacustris.cds
python -m jcvi.formats.fasta format --primary_only /home/tbessonn/1_Eviann/Gerris_odontogaster/gerris_odontogaster_long.PolcaCorrected.sixth_polished.fa.proteins.fasta Gerris_odontogaster.cds
