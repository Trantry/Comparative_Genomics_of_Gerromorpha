#!/bin/bash
#SBATCH --job-name=busco_gff
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

WORKDIR=/home/tbessonn/1_gffread/BUSCO

# building an associative array with the genomes of 8 species of gerromorpha
declare -A assembly
assembly[G_buenoi]=/home/tbessonn/1_gffread/G_buenoi_Uppsala/G_buenoi_Uppsala.transcripts.fa
assembly[G_odontogaster_1]=/home/tbessonn/1_gffread/G_odontogaster_1/G_odontogaster_1.transcripts.fa
assembly[G_odontogaster_2]=/home/tbessonn/1_gffread/G_odontogaster_2/G_odontogaster_2.transcripts.fa
assembly[M_longipes]=/home/tbessonn/1_gffread/M_longipes_utr/M_longipes_utr.transcripts.fa
assembly[R_antilleana_Arnaud]=/home/tbessonn/1_gffread/R_antilleana_arnaud/R_antilleana_arnaud.transcripts.fa
assembly[R_antilleana_David_braker]=/home/tbessonn/1_gffread/R_antilleana_david_braker/R_antilleana_david_braker.transcripts.fa
assembly[R_antilleana_David_braker_utr]=/home/tbessonn/1_gffread/R_antilleana_david_braker_utr/R_antilleana_david_braker_utr.transcripts.fa

# building an associative array with the genomes of 1 species of non gerromorpha (Nepomorpha)
assembly[R_chinensis]=/home/tbessonn/1_gffread/R_chinensis/R_chinensis.transcripts.fa

# building an associative array with the genomes of 5 species of non gerromorpha (Cimicomorpha)
assembly[A_lucorum]=/home/tbessonn/1_gffread/A_lucorum/A_lucorum.transcripts.fa
assembly[C_lectularius_Refseq]=/home/tbessonn/1_gffread/C_lectularius_Refseq/C_lectularius_Refseq.transcripts.fa
assembly[R_fuscipes]=/home/tbessonn/1_gffread/R_fuscipes/R_fuscipes.transcripts.fa

## Run busco analysis
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate busco

for key in "${!assembly[@]}"
do
    GENOME=${assembly[$key]}
    if [ ! -f "$WORKDIR/$key/short_summary.specific.hemiptera_odb12.$key.json" ]
    then
        busco -i "$GENOME" \
        -l hemiptera_odb12 \
        -m genome \
        -o $key \
        --out_path "$WORKDIR" \
        --cpu 16
    fi
done
