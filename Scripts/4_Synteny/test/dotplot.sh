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

# python -m jcvi.formats.gff bed --type=mRNA --key=ID --primary_only /home/tbessonn/3_Rename_chromosome/Gerris_lacustris/Gerris_lacustris.filtered_renamed.gff -o Gerris_lacustris.bed
# python -m jcvi.formats.gff bed --type=mRNA --key=ID --primary_only /home/tbessonn/3_Rename_chromosome/Gerris_odontogaster/Gerris_odontogaster.filtered_renamed.gff -o Gerris_odontogaster.bed
# python -m jcvi.formats.gff bed --type=mRNA --key=ID --primary_only /home/tbessonn/3_Rename_chromosome/Aquarius_najas/Aquarius_najas.filtered_renamed.gff -o Aquarius_najas.bed
# python -m jcvi.formats.gff bed --type=mRNA --key=ID --primary_only /home/tbessonn/3_Rename_chromosome/Aquarius_paludum/Aquarius_paludum.filtered_renamed.gff -o Aquarius_paludum.bed
# python -m jcvi.formats.gff bed --type=mRNA --key=ID --primary_only /home/tbessonn/3_Rename_chromosome/Microvelia_longipes/Microvelia_longipes.filtered_renamed.gff -o Microvelia_longipes.bed
# python -m jcvi.formats.gff bed --type=mRNA --key=ID --primary_only /home/tbessonn/3_Rename_chromosome/Rhagovelia_antilleana/Rhagovelia_antilleana.filtered_renamed.gff -o Rhagovelia_antilleana.bed


# python -m jcvi.formats.fasta format /home/tbessonn/1_Eviann/Gerris_lacustris/GCA_951217055.1_ihGerLacu2.1_genomic.fna.proteins.fasta Gerris_lacustris.pep
# python -m jcvi.formats.fasta format /home/tbessonn/1_Eviann/Gerris_odontogaster/gerris_odontogaster_long.PolcaCorrected.sixth_polished.fa.proteins.fasta Gerris_odontogaster.pep
# python -m jcvi.formats.fasta format /home/tbessonn/1_Eviann/Aquarius_najas/Anajas_softmasked_genome.fa.proteins.fasta Aquarius_najas.pep
# python -m jcvi.formats.fasta format /home/tbessonn/1_Eviann/Aquarius_paludum/GCA_052327185.1_ASM5232718v1_genomic.fna.proteins.fasta Aquarius_paludum.pep
# python -m jcvi.formats.fasta format /home/tbessonn/1_Eviann/Microvelia_longipes/Mlon_polished_genome_round2.fasta.proteins.fasta Microvelia_longipes.pep
# python -m jcvi.formats.fasta format /home/tbessonn/1_Eviann/Rhagovelia_antilleana/rhagovelia_antilleana_genome_fourth_polish.fasta.renamed.proteins.fasta Rhagovelia_antilleana.pep


#Pairwise synteny search
python -m jcvi.compara.catalog ortholog Gerris_lacustris Gerris_odontogaster --dbtype=prot --no_strip_names
python -m jcvi.compara.catalog ortholog Aquarius_paludum Aquarius_najas --dbtype=prot --no_strip_names
python -m jcvi.compara.catalog ortholog Microvelia_longipes Rhagovelia_antilleana --dbtype=prot --no_strip_names
python -m jcvi.compara.catalog ortholog Microvelia_longipes Gerris_lacustris --dbtype=prot --no_strip_names
python -m jcvi.compara.catalog ortholog Rhagovelia_antilleana Gerris_lacustris --dbtype=prot --no_strip_names

/home/tbessonn/anchors

# 1) construire des tables gene -> (contig, start, end)
awk 'BEGIN{OFS="\t"} {print $4,$1,$2,$3}' /home/tbessonn/3_JCVI/Gerris_lacustris.bed > A.map.tsv
awk 'BEGIN{OFS="\t"} {print $4,$1,$2,$3}' /home/tbessonn/3_JCVI/Gerris_odontogaster.bed > B.map.tsv

# 2) annoter anchors avec contigs/coords
awk 'BEGIN{OFS="\t"}
     $1=="###"{blk++; next}
     NF==3{print blk,$1,$2,$3}' /home/tbessonn/3_JCVI/Gerris_lacustris.Gerris_odontogaster.lifted.anchors > anchors.withblk.tsv

# join côté A (via geneA)
join -t $'\t' -1 2 -2 1 <(sort -k2,2 anchors.withblk.tsv) <(sort -k1,1 A.map.tsv) \
  > tmp.tsv
# tmp: blk geneA geneB score contigA startA endA

# join côté B (via geneB)
join -t $'\t' -1 3 -2 1 <(sort -k3,3 tmp.tsv) <(sort -k1,1 B.map.tsv) \
  > anchors.annotated.tsv

# anchors.annotated.tsv contient :
# blk geneA geneB score contigA startA endA contigB startB endB
head anchors.annotated.tsv

# Pour voir quels couples (contigA, contigB) existent, par bloc
awk 'BEGIN{OFS="\t"} {print $1,$5,$8}' anchors.annotated.tsv | sort | uniq -c | sort -nr | head -20
