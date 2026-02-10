#!/bin/bash
#SBATCH --job-name=A_najas_Eviann
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=06-00:00:00
#SBATCH --partition=Cascade
#SBATCH --output=/home/tbessonn/stdout/%A_%a.out # standard output file format
#SBATCH --error=/home/tbessonn/stderr/%A_%a.err # error file format

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate eviann

#Variables
WORKDIR=/scratch/Cascade/tbessonn/Eviann
ROOTDIR=/home/tbessonn/ressources/genomes
EVIANN=${HOME}/miniconda3/envs/eviann/bin/eviann.sh
PROT=/home/tbessonn/ressources/Protein/Heteroptera_Sternorrhyncha_G_buenoi_prot.fasta
#Transcriptome=/scratch/Bio/tbessonn/transcriptome/M_longipes/10024092.1_Microvelia_longipes.trinity.fa
Transcriptome=/home/tbessonn/ressources/transcriptomes/A_najas/Aqu_naj_trinity.Trinity.fasta
#For paired-end:
#paste <(ls $PWD/*_1.fastq) <(ls $PWD/*_2.fastq) > paired.txt
# For single-end:
#ls "$PWD"/*.fastq | grep -Ev '(_1|_2)\.fastq$' >> paired.txt
RNASEQ=/home/tbessonn/ressources/RNA_seq/Gerromorpha/A_najas/paired.txt

# building an associative array with the genomes of 9 species of gerromorpha
declare -A assembly
#assembly[A_paludum]="$ROOTDIR/gerromorpha/aquarius_paludum/ncbi_dataset/ncbi_dataset/data/GCA_052327185.1/GCA_052327185.1_ASM5232718v1_genomic.fna"
assembly[A_najas]="$ROOTDIR/gerromorpha/Aquarius_najas/Anajas_softmasked_genome.fa"
#assembly[G_buenoi]="$ROOTDIR/gerromorpha/gerris_buenoi/new/genome.softmasked.fa"
#assembly[G_lacustris]="$ROOTDIR/gerromorpha/gerris_lacustris/ncbi_dataset-2/ncbi_dataset/data/GCA_951217055.1/GCA_951217055.1_ihGerLacu2.1_genomic.fna"
#assembly[G_odontogaster]="$ROOTDIR/gerromorpha/gerris_odontogaster/gerris_odontogaster_long.PolcaCorrected.sixth_polished.fa"
#assembly[H_lingyangjiaoensis]="$ROOTDIR/gerromorpha/hermatobates_lingyangjiaoensis/ncbi_dataset/ncbi_dataset/data/GCA_026182355.1/GCA_026182355.1_ASM2618235v1_genomic.fna"
#assembly[M_longipes]="$ROOTDIR/gerromorpha/microvelia_longipes/Mlon_polished_genome_round2.fasta"
#assembly[R_antilleana]="$ROOTDIR/gerromorpha/rhagovelia_antilleana/unmasked_genome/rhagovelia_antilleana_genome_fourth_polish.fasta.renamed"
#assembly[T_zetteli]="$ROOTDIR/gerromorpha/tetraripis_zetteli/tzet_genome_flye_v4_unmasked.fasta"

# building an associative array with the genomes of 2 species of non gerromorpha (Nepomorpha)
#assembly[L_indicus]="$ROOTDIR/non_gerromorpha/nepomorpha/lethocerus_indicus/ncbi_dataset/ncbi_dataset/data/GCA_019843655.1/GCA_019843655.1_UK_Lind_1.0_genomic.fna"
#assembly[R_chinensis]="$ROOTDIR/non_gerromorpha/nepomorpha/ranatra_chinensis/ncbi_dataset/ncbi_dataset/data/GCA_040954505.1/GCA_040954505.1_ASM4095450v1_genomic.fna"

# building an associative array with the genomes of 5 species of non gerromorpha (Cimicomorpha)
#assembly[A_suturalis]="$ROOTDIR/non_gerromorpha/cimicomorpha/adelphocoris_suturalis/ncbi_dataset/ncbi_dataset/data/GCA_030762985.1/GCA_030762985.1_ASM3076298v1_genomic.fna"
#assembly[A_lucorum]="$ROOTDIR/non_gerromorpha/cimicomorpha/apolygus_lucorum/ncbi_dataset/ncbi_dataset/data/GCA_009739505.2/GCA_009739505.2_ASM973950v2_genomic.fna"
#assembly[C_lectularius_Genbank]="$ROOTDIR/non_gerromorpha/cimicomorpha/cimex_lectularius/ncbi_dataset/ncbi_dataset/data/GCA_000648675.3/GCA_000648675.3_Clec_2.1_genomic.fna"
#assembly[R_fuscipes]="$ROOTDIR/non_gerromorpha/cimicomorpha/rhynocoris_fuscipes/ncbi_dataset/ncbi_dataset/data/GCA_040020575.1/GCA_040020575.1_Rfu_1.0_genomic.fna"
#assembly[T_infestans]="$ROOTDIR/non_gerromorpha/cimicomorpha/triatoma_infestans/ncbi_dataset/ncbi_dataset/data/GCA_965641795.1/GCA_965641795.1_ihTriInfe1.hap1.1_genomic.fna"

# building an associative array with the genomes of 5 species of non gerromorpha (Pentatomomorpha)
#assembly[A_truncatus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/aradus_truncatus/ncbi_dataset/ncbi_dataset/data/GCA_965153375.1/GCA_965153375.1_ihAraTrun1.hap1.1_genomic.fna"
#assembly[E_furcellata]="$ROOTDIR/non_gerromorpha/pentatomomorpha/eocanthecona_furcellata/ncbi_dataset/ncbi_dataset/data/GCA_052550355.1/GCA_052550355.1_ASM5255035v1_genomic.fna"
#assembly[G_acuteangulatus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/gonocerus_acuteangulatus/ncbi_dataset/ncbi_dataset/data/GCA_946811695.1/GCA_946811695.1_ihGonAcut1.1_genomic.fna"
#assembly[O_fasciatus]="$ROOTDIR/non_gerromorpha/pentatomomorpha/oncopeltus_fasciatus/ncbi_dataset/ncbi_dataset/data/GCA_000696205.2/GCA_000696205.2_Ofas_2.0_genomic.fna"
#assembly[R_pedestris]="$ROOTDIR/non_gerromorpha/pentatomomorpha/riptortus_pedestris/ncbi_dataset/ncbi_dataset/data/GCA_019009955.1/GCA_019009955.1_ASM1900995v1_genomic.fna"

for key in "${!assembly[@]}"
do
    GENOME=${assembly[$key]}
    mkdir -p $WORKDIR/$key
    cd $WORKDIR/$key
    $EVIANN -g $GENOME \
            -p $PROT \
            -r $RNASEQ \
            -e $Transcriptome \
            -t 32
done
