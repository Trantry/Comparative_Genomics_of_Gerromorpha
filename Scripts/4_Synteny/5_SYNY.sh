#!/bin/bash
#SBATCH --job-name=syny26
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=332G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate syny


cd /home/tbessonn/3_SYNY/

run_syny.pl -a *.gbff \
    -t 32 \
    --aligner mashmap \
    --mpid 90 \
    --min_asize 5500 \
    -g 0 1 5 10 20 \
    -e 1e-30 \
    --resume \
    -c pair \
    --max_links 1000 \
    --max_ticks 1000 \
    --max_points_per_track 1000 \
    -o /home/tbessonn/3_SYNY/output26



#cd /home/tbessonn/Heatmap/gbff

#run_syny.pl -a *.gbff \
#    -t 32 \
#    --no_map \
#    --no_circos \
#    -g 0 1 5 10 20 \
#    -e 1e-30 \
#    -o /home/tbessonn/Heatmap/gbff/output3
