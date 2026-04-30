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
WORKDIR=/home/tbessonn/Test_BUSCO

declare -A assembly
assembly[A_paludum]=/home/tbessonn/3_Rename_chromosome/Aquarius_paludum/Aquarius_paludum.filtered_renamed.fa
assembly[A_najas]=/home/tbessonn/3_Rename_chromosome/Aquarius_najas/Aquarius_najas.filtered_renamed.fa
assembly[G_odontogaster]=/home/tbessonn/3_Rename_chromosome/Gerris_odontogaster/Gerris_odontogaster.filtered_renamed.fa
assembly[G_lacustris]=/home/tbessonn/3_Rename_chromosome/Gerris_lacustris/Gerris_lacustris.filtered_renamed.fa
assembly[A_suturalis]=/home/tbessonn/3_Rename_chromosome/Adelphocoris_suturalis/Adelphocoris_suturalis.filtered_renamed.fa
assembly[A_lucorum]=/home/tbessonn/3_Rename_chromosome/Apolygus_lucorum/Apolygus_lucorum.filtered_renamed.fa
assembly[E_furcellata]=/home/tbessonn/3_Rename_chromosome/Eocanthecona_furcellata/Eocanthecona_furcellata.filtered_renamed.fa
assembly[G_acuteangulatus]=/home/tbessonn/3_Rename_chromosome/Gonocerus_acuteangulatus/Gonocerus_acuteangulatus.filtered_renamed.fa
assembly[M_longipes]=/home/tbessonn/3_Rename_chromosome/Microvelia_longipes/Microvelia_longipes.filtered_renamed.fa
assembly[P_apterus]=/home/tbessonn/3_Rename_chromosome/Pyrrhocoris_apterus/Pyrrhocoris_apterus.filtered_renamed.fa
assembly[R_chinensis]=/home/tbessonn/3_Rename_chromosome/Ranatra_chinensis/Ranatra_chinensis.filtered_renamed.fa
assembly[R_antilleana]=/home/tbessonn/3_Rename_chromosome/Rhagovelia_antilleana/Rhagovelia_antilleana.filtered_renamed.fa
assembly[R_fuscipes]=/home/tbessonn/3_Rename_chromosome/Rhynocoris_fuscipes/Rhynocoris_fuscipes.filtered_renamed.fa
assembly[R_pedestris]=/home/tbessonn/3_Rename_chromosome/Riptorus_pedestris/Riptorus_pedestris.filtered_renamed.fa
assembly[T_infestans]=/home/tbessonn/3_Rename_chromosome/Triatoma_infestans/Triatoma_infestans.filtered_renamed.fa
assembly[C_lectularius]=/home/tbessonn/3_Rename_chromosome/Cimex_lectularius/Cimex_lectularius.filtered_renamed.fa

for key in "${!assembly[@]}"
do
    GENOME=${assembly[$key]}
    if [ ! -f "$WORKDIR/$key/short_summary.specific.hemiptera_odb12.$key.json" ]
    then
        busco -i $GENOME \
        -l hemiptera_odb12 \
        -m genome \
        -o $key \
        --out_path $WORKDIR \
        --cpu 16
    fi
done
