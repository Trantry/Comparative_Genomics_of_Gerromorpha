#!/bin/bash
#SBATCH --job-name=busco
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err

mkdir -p /scratch/Cascade/tbessonn/1_busco
WORKDIR=/scratch/Cascade/tbessonn/1_busco
ROOTDIR=/home/tbessonn/ressources/genomes

# building an associative array with the genomes of 9 species of gerromorpha
declare -A assembly
assembly[A_paludum]="$ROOTDIR/gerromorpha/aquarius_paludum/ncbi_dataset/ncbi_dataset/data/GCA_052327185.1/GCA_052327185.1_ASM5232718v1_genomic.fna"
assembly[A_najas]="$ROOTDIR/gerromorpha/Aquarius_najas/Anajas_softmasked_genome.fa"
assembly[G_buenoi]="$ROOTDIR/gerromorpha/gerris_buenoi/water_strider_11Jul2018_yVXgK.fasta"
assembly[G_buenoi_new]="$ROOTDIR/gerromorpha/gerris_buenoi/new/genome.softmasked.fa"
assembly[G_lacustris_ref]="$ROOTDIR/gerromorpha/gerris_lacustris/ncbi_dataset-2/ncbi_dataset/data/GCA_951217055.1/GCA_951217055.1_ihGerLacu2.1_genomic.fna"
assembly[G_lacustris_haplo]="$ROOTDIR/gerromorpha/gerris_lacustris/ncbi_dataset-3/ncbi_dataset/data/GCA_951217045.1/GCA_951217045.1_ihGerLacu2.1_alternate_haplotype_genomic.fna"
assembly[G_odontogaster]="$ROOTDIR/gerromorpha/gerris_odontogaster/gerris_odontogaster_long.PolcaCorrected.sixth_polished.fa"
assembly[H_lingyangjiaoensis]="$ROOTDIR/gerromorpha/hermatobates_lingyangjiaoensis/ncbi_dataset/ncbi_dataset/data/GCA_026182355.1/GCA_026182355.1_ASM2618235v1_genomic.fna"
assembly[M_longipes]="$ROOTDIR/gerromorpha/microvelia_longipes/Mlon_polished_genome_round2.fasta"
assembly[R_antilleana]="$ROOTDIR/gerromorpha/rhagovelia_antilleana/unmasked_genome/rhagovelia_antilleana_genome_fourth_polish.fasta.renamed"
assembly[T_zetteli]="$ROOTDIR/gerromorpha/tetraripis_zetteli/tzet_genome_flye_v4_unmasked.fasta"

# building an associative array with the genomes of 6 species of non gerromorpha (Nepomorpha)
assembly[D_zealandiae]="$ROOTDIR/non_gerromorpha/nepomorpha/diaprepocoris_zealandiae/ncbi_dataset/ncbi_dataset/data/GCA_050613935.1/GCA_050613935.1_ASM5061393v1_genomic.fna"
assembly[L_indicus]="$ROOTDIR/non_gerromorpha/nepomorpha/lethocerus_indicus/ncbi_dataset/ncbi_dataset/data/GCA_019843655.1/GCA_019843655.1_UK_Lind_1.0_genomic.fna"
assembly[N_cinerea]="$ROOTDIR/non_gerromorpha/nepomorpha/nepa_cinerea/ncbi_dataset/ncbi_dataset/data/GCA_050640425.1/GCA_050640425.1_ASM5064042v1_genomic.fna"
assembly[P_sp]="$ROOTDIR/non_gerromorpha/nepomorpha/potamocoris_sp_YW-2020/ncbi_dataset/ncbi_dataset/data/GCA_044343965.1/GCA_044343965.1_ASM4434396v1_genomic.fna"
assembly[R_chinensis]="$ROOTDIR/non_gerromorpha/nepomorpha/ranatra_chinensis/ncbi_dataset/ncbi_dataset/data/GCA_040954505.1/GCA_040954505.1_ASM4095450v1_genomic.fna"
assembly[T_incerta]="$ROOTDIR/non_gerromorpha/nepomorpha/tenagobia_incerta/ncbi_dataset/ncbi_dataset/data/GCA_044343685.1/GCA_044343685.1_ASM4434368v1_genomic.fna"

# building an associative array with the genomes of 8 species of non gerromorpha (Cimicomorpha)
assembly[A_suturalis]="$ROOTDIR/non_gerromorpha/cimicomorpha/adelphocoris_suturalis/ncbi_dataset/ncbi_dataset/data/GCA_030762985.1/GCA_030762985.1_ASM3076298v1_genomic.fna"
assembly[A_lucorum]="$ROOTDIR/non_gerromorpha/cimicomorpha/apolygus_lucorum/ncbi_dataset/ncbi_dataset/data/GCA_009739505.2/GCA_009739505.2_ASM973950v2_genomic.fna"
assembly[C_lectularius_Genbank]="$ROOTDIR/non_gerromorpha/cimicomorpha/cimex_lectularius/ncbi_dataset/ncbi_dataset/data/GCA_000648675.3/GCA_000648675.3_Clec_2.1_genomic.fna"
assembly[C_lectularius_Refseq]="$ROOTDIR/non_gerromorpha/cimicomorpha/cimex_lectularius/ncbi_dataset/ncbi_dataset/data/GCF_000648675.2/GCF_000648675.2_Clec_2.1_genomic.fna"
assembly[N_tenius]="$ROOTDIR/non_gerromorpha/cimicomorpha/nesidiocoris_tenuis/ncbi_dataset/ncbi_dataset/data/GCA_036186465.1/GCA_036186465.1_ASM3618646v1_genomic.fna"
assembly[P_geniculatus]="$ROOTDIR/non_gerromorpha/cimicomorpha/panstrongylus_geniculatus/ncbi_dataset/ncbi_dataset/data/GCA_019603395.1/GCA_019603395.1_ASM1960339v1_genomic.fna"
assembly[R_prolixus_Refseq]="$ROOTDIR/non_gerromorpha/cimicomorpha/rhodnius_prolixus/ncbi_dataset/ncbi_dataset/data/GCF_049639745.1/GCF_049639745.1_Rpr_genomic.fna"
assembly[R_prolixus_Genbank]="$ROOTDIR/non_gerromorpha/cimicomorpha/rhodnius_prolixus/ncbi_dataset/ncbi_dataset/data/GCA_049639745.1/GCA_049639745.1_Rpr_genomic.fna"
assembly[R_fuscipes]="$ROOTDIR/non_gerromorpha/cimicomorpha/rhynocoris_fuscipes/ncbi_dataset/ncbi_dataset/data/GCA_040020575.1/GCA_040020575.1_Rfu_1.0_genomic.fna"
assembly[T_infestans]="$ROOTDIR/non_gerromorpha/cimicomorpha/triatoma_infestans/ncbi_dataset/ncbi_dataset/data/GCA_965641795.1/GCA_965641795.1_ihTriInfe1.hap1.1_genomic.fna"

# building an associative array with the genomes of 9 species of non gerromorpha (Pentatomomorpha)
assembly[A_truncatus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/aradus_truncatus/ncbi_dataset/ncbi_dataset/data/GCA_965153375.1/GCA_965153375.1_ihAraTrun1.hap1.1_genomic.fna"
assembly[E_furcellata]="$ROOTDIR/non_gerromorpha/pentatomomorpha/eocanthecona_furcellata/ncbi_dataset/ncbi_dataset/data/GCA_052550355.1/GCA_052550355.1_ASM5255035v1_genomic.fna"
assembly[G_acuteangulatus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/gonocerus_acuteangulatus/ncbi_dataset/ncbi_dataset/data/GCA_946811695.1/GCA_946811695.1_ihGonAcut1.1_genomic.fna"
assembly[H_halys_Genbank]="$ROOTDIR/non_gerromorpha/pentatomomorpha/halyomorpha_halys/ncbi_dataset/ncbi_dataset/data/GCA_000696795.3/GCA_000696795.3_Hhal_1.1_genomic.fna"
assembly[H_halys_Refseq]="$ROOTDIR/non_gerromorpha/pentatomomorpha/halyomorpha_halys/ncbi_dataset/ncbi_dataset/data/GCF_000696795.3/GCF_000696795.3_Hhal_1.1_genomic.fna"
assembly[L_phyllopus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/leptoglossus_phyllopus/ncbi_dataset/ncbi_dataset/data/GCA_041002905.1/GCA_041002905.1_ihLepPhyl2_genomic.fna"
assembly[N_viridula]="$ROOTDIR/non_gerromorpha/pentatomomorpha/nezara_viridula/ncbi_dataset/ncbi_dataset/data/GCA_928085145.1/GCA_928085145.1_PGI_NEZAVIv3_genomic.fna"
assembly[O_fasciatus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/oncopeltus_fasciatus/ncbi_dataset/ncbi_dataset/data/GCA_000696205.2/GCA_000696205.2_Ofas_2.0_genomic.fna"
assembly[P_apterus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/pyrrhocoris_apterus/ncbi_dataset/ncbi_dataset/data/GCA_039877355.1/GCA_039877355.1_ASM3987735v1_genomic.fna"
assembly[R_pedestris]="$ROOTDIR/non_gerromorpha/pentatomomorpha/riptortus_pedestris/ncbi_dataset/ncbi_dataset/data/GCA_019009955.1/GCA_019009955.1_ASM1900995v1_genomic.fna"

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

# collect only the short_summary files and move it into /home/tbessonn/busco/<key>
for key in "${!assembly[@]}"
do
    if [ ! -f "/home/tbessonn/busco/$key/short_summary.specific.hemiptera_odb12.$key.json" ]
    then
        mkdir -p "/home/tbessonn/0_busco/$key"
        mv -f "/scratch/Cascade/tbessonn/1_busco/$key/short_summary.specific.hemiptera_odb12.$key.txt" "/home/tbessonn/0_busco/$key/"
        mv -f "/scratch/Cascade/tbessonn/1_busco/$key/short_summary.specific.hemiptera_odb12.$key.json" "/home/tbessonn/0_busco/$key/"
    fi
done

cd /home/tbessonn/0_busco

busco --plot /home/tbessonn/0_busco/

conda deactivate
