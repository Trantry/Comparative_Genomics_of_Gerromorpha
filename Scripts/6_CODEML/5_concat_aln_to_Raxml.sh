#!/bin/bash
#SBATCH --job-name=RaxML
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=07-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
source $HOME/miniconda3/etc/profile.d/conda.sh
#Backup
cp -r /home/tbessonn/5_CODEML/4_pal2nal/paml /home/tbessonn/5_CODEML/4_pal2nal/paml_backup

cd /home/tbessonn/5_CODEML/4_pal2nal/paml

#shorter names for phyllip format (less than 10 characters)
sed -i \
  -e 's/^>Adelphocoris_suturalis|/>Ade_sut|/' \
  -e 's/^>Apolygus_lucorum|/>Apo_luc|/' \
  -e 's/^>Aquarius_najas|/>Aqu_naj|/' \
  -e 's/^>Aquarius_paludum|/>Aqu_pal|/' \
  -e 's/^>Cimex_lectularius|/>Cim_lec|/' \
  -e 's/^>Eocanthecona_furcellata|/>Eoc_fur|/' \
  -e 's/^>Gerris_buenoi|/>Ger_bue|/' \
  -e 's/^>Gerris_lacustris|/>Ger_lac|/' \
  -e 's/^>Gerris_odontogaster|/>Ger_odo|/' \
  -e 's/^>Gigantometra_gigas|/>Gig_gig|/' \
  -e 's/^>Gonocerus_acuteangulatus|/>Gon_acu|/' \
  -e 's/^>Hermatobates_lingyangjiaoensis|/>Her_lin|/' \
  -e 's/^>Microvelia_longipes|/>Mic_lon|/' \
  -e 's/^>Oncopeltus_fasciatus|/>Onc_fas|/' \
  -e 's/^>Pyrrhocoris_apterus|/>Pyr_apt|/' \
  -e 's/^>Ranatra_chinensis|/>Ran_chi|/' \
  -e 's/^>Rhagovelia_antilleana|/>Rha_ant|/' \
  -e 's/^>Rhynocoris_fuscipes|/>Rhy_fus|/' \
  -e 's/^>Riptorus_pedestris|/>Rip_ped|/' \
  -e 's/^>Tetraripis_zetteli|/>Tet_zet|/' \
  -e 's/^>Triatoma_infestans|/>Tri_inf|/' \
  *.fasta

sed -i 's/|.*//' *.fasta

#shorter names for phyllip format (less than 10 characters)
sed -i \
  -e 's/^Adelphocoris_suturalis$/Ade_sut/' \
  -e 's/^Apolygus_lucorum$/Apo_luc/' \
  -e 's/^Aquarius_najas$/Aqu_naj/' \
  -e 's/^Aquarius_paludum$/Aqu_pal/' \
  -e 's/^Cimex_lectularius$/Cim_lec/' \
  -e 's/^Eocanthecona_furcellata$/Eoc_fur/' \
  -e 's/^Gerris_buenoi$/Ger_bue/' \
  -e 's/^Gerris_lacustris$/Ger_lac/' \
  -e 's/^Gerris_odontogaster$/Ger_odo/' \
  -e 's/^Gigantometra_gigas$/Gig_gig/' \
  -e 's/^Gonocerus_acuteangulatus$/Gon_acu/' \
  -e 's/^Hermatobates_lingyangjiaoensis$/Her_lin/' \
  -e 's/^Microvelia_longipes$/Mic_lon/' \
  -e 's/^Oncopeltus_fasciatus$/Onc_fas/' \
  -e 's/^Pyrrhocoris_apterus$/Pyr_apt/' \
  -e 's/^Ranatra_chinensis$/Ran_chi/' \
  -e 's/^Rhagovelia_antilleana$/Rha_ant/' \
  -e 's/^Rhynocoris_fuscipes$/Rhy_fus/' \
  -e 's/^Riptorus_pedestris$/Rip_ped/' \
  -e 's/^Tetraripis_zetteli$/Tet_zet/' \
  -e 's/^Triatoma_infestans$/Tri_inf/' \
  *.paml


#Concatnetaed for Raxml
perl /home/tbessonn/bin/catfasta2phyml/catfasta2phyml.pl -c -p -s *.fasta \
  > concatenated_OG.phy 2> partitions.txt

mkdir -p ../../5_Raxml
mv concatenated_OG.phy partitions.txt ../../5_Raxml/
cd ../../5_Raxml

#RaxML NG
conda activate phylo

raxml-ng --all \
  --msa concatenated_OG.phy \
  --model GTR+G \
  --bs-trees 100 \
  --seed 12345 \
  --threads 16 \
  --prefix species_tree
