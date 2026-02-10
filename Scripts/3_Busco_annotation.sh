#!/bin/bash
#SBATCH --job-name=busco_annotation
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=02-00:00:00
#SBATCH --partition=Cascade
#SBATCH --output=/home/tbessonn/stdout/%A_%a.out # standard output file format
#SBATCH --error=/home/tbessonn/stderr/%A_%a.err # error file format

mkdir -p /scratch/Cascade/tbessonn/busco_annotation
WORKDIR=/scratch/Cascade/tbessonn/busco_annotation
ROOTDIR=/home/tbessonn/1_Eviann

# building an associative array with the genomes of 8 species of gerromorpha
declare -A assembly
assembly[A_paludum]="$ROOTDIR/A_paludum/GCA_052327185.1_ASM5232718v1_genomic.fna.transcripts.fasta"
assembly[A_najas]="$ROOTDIR/A_najas/Anajas_softmasked_genome.fa.transcripts.fasta"
assembly[G_buenoi]="$ROOTDIR/G_buenoi/genome.softmasked.fa.transcripts.fasta"
assembly[G_lacustris]="$ROOTDIR/G_lacustris/GCA_951217055.1_ihGerLacu2.1_genomic.fna.transcripts.fasta"
assembly[G_odontogaster]="$ROOTDIR/G_odontogaster/gerris_odontogaster_long.PolcaCorrected.sixth_polished.fa.transcripts.fasta"
assembly[H_lingyangjiaoensis]="$ROOTDIR/H_lingyangjiaoensis/GCA_026182355.1_ASM2618235v1_genomic.fna.transcripts.fasta"
#assembly[M_longipes]="$ROOTDIR/"
assembly[R_antilleana]="$ROOTDIR/R_antilleana/rhagovelia_antilleana_genome_fourth_polish.fasta.renamed.transcripts.fasta"
assembly[T_zetteli]="$ROOTDIR/T_zetteli/tzet_genome_flye_v4_unmasked.fasta.transcripts.fasta"

# building an associative array with the genomes of 1 species of non gerromorpha (Nepomorpha)
assembly[R_chinensis]="$ROOTDIR/R_chinensis/GCA_040954505.1_ASM4095450v1_genomic.fna.transcripts.fasta"

# building an associative array with the genomes of 5 species of non gerromorpha (Cimicomorpha)
assembly[A_suturalis]="$ROOTDIR/A_suturalis/GCA_030762985.1_ASM3076298v1_genomic.fna.transcripts.fasta"
assembly[A_lucorum]="$ROOTDIR/A_lucorum/GCA_009739505.2_ASM973950v2_genomic.fna.transcripts.fasta"
assembly[C_lectularius_Genbank]="$ROOTDIR/C_lectularius_Genbank/GCA_000648675.3_Clec_2.1_genomic.fna.transcripts.fasta"
assembly[R_fuscipes]="$ROOTDIR/R_fuscipes/GCA_040020575.1_Rfu_1.0_genomic.fna.transcripts.fasta"
assembly[T_infestans]="$ROOTDIR/T_infestans/GCA_965641795.1_ihTriInfe1.hap1.1_genomic.fna.transcripts.fasta"

# building an associative array with the genomes of 5 species of non gerromorpha (Pentatomomorpha)
assembly[A_truncatus]="$ROOTDIR/A_truncatus/GCA_965153375.1_ihAraTrun1.hap1.1_genomic.fna.transcripts.fasta"
assembly[E_furcellata]="$ROOTDIR/E_furcellata/GCA_052550355.1_ASM5255035v1_genomic.fna.transcripts.fasta"
assembly[G_acuteangulatus]="$ROOTDIR/G_acuteangulatus/GCA_946811695.1_ihGonAcut1.1_genomic.fna.transcripts.fasta"
assembly[O_fasciatus]="$ROOTDIR/O_fasciatus/GCA_000696205.2_Ofas_2.0_genomic.fna.transcripts.fasta"
assembly[R_pedestris]="$ROOTDIR/R_pedestris/GCA_019009955.1_ASM1900995v1_genomic.fna.transcripts.fasta"

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
        --cpu 16 \
        -f
    fi
done

# collect only the short_summary files and move it into /home/tbessonn/busco/<key>
for key in "${!assembly[@]}"
do
    if [ ! -f "/home/tbessonn/2_busco_annotation/$key/short_summary.specific.hemiptera_odb12.$key.json" ]
    then
        mkdir -p "/home/tbessonn/2_busco_annotation/$key"
        mv -f "$WORKDIR/$key/short_summary.specific.hemiptera_odb12.$key.txt" "/home/tbessonn/2_busco_annotation/$key/"
        mv -f "$WORKDIR/$key/short_summary.specific.hemiptera_odb12.$key.json" "/home/tbessonn/2_busco_annotation/$key/"
    fi
done

conda deactivate
