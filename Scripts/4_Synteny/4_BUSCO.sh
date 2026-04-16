#!/bin/bash
#SBATCH --job-name=busco
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate busco
WORKDIR=/home/tbessonn/3_BUSCO

declare -A assembly
assembly[A_paludum]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Aquarius_paludum.faa
assembly[A_najas]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Aquarius_najas.faa
assembly[G_odontogaster]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Gerris_odontogaster.faa
assembly[G_lacustris]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Gerris_lacustris.faa
assembly[A_suturalis]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Adelphocoris_suturalis.faa
assembly[A_lucorum]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Apolygus_lucorum.faa
assembly[E_furcellata]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Eocanthecona_furcellata.faa
assembly[G_acuteangulatus]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Gonocerus_acuteangulatus.faa
assembly[M_longipes]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Microvelia_longipes.faa
assembly[P_apterus]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Pyrrhocoris_apterus.faa
assembly[R_chinensis]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Ranatra_chinensis.faa
assembly[R_antilleana]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Rhagovelia_antilleana.faa
assembly[R_fuscipes]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Rhynocoris_fuscipes.faa
assembly[R_pedestris]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Riptorus_pedestris.faa
assembly[T_infestans]=/home/tbessonn/3_SYNY/minimap/SEQUENCES/PROTEINS/Triatoma_infestans.faa

for key in "${!assembly[@]}"
do
    GENOME=${assembly[$key]}
    if [ ! -f "$WORKDIR/$key/short_summary.specific.hemiptera_odb12.$key.json" ]
    then
        busco -i $GENOME \
        -l hemiptera_odb12 \
        -m proteins \
        -o $key \
        --out_path $WORKDIR \
        --cpu 16
    fi
done
