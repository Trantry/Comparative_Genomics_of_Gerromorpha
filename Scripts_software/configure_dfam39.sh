#!/bin/bash
#SBATCH --job-name=download_dfam39
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=05-00:00:00
#SBATCH --partition=Cascade,Genoa-premium,Emerald-premium
#SBATCH --output=/home/tbessonn/stdout/%x_%A_%a.out
#SBATCH --error=/home/tbessonn/stderr/%x_%A_%a.err
# first, change directory to the famdb library location
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate earlgrey

cd /home/tbessonn/miniconda3/envs/earlgrey/share/RepeatMasker/Libraries/famdb/

# download the partitions you require from Dfam 3.9. In the below, change the numbers or range inside the square brackets to choose your subsets.
# e.g. to download partitions 0 to 10: [0-10]; or to download partitions 3,5, and 7: [3,5,7]; [0-16] is ALL PARTITIONS
for i in {0..16}; do
  curl -C - --retry 999 --retry-delay 10 \
  -o dfam39_full.${i}.h5.gz \
  https://dfam.org/releases/current/families/FamDB/dfam39_full.${i}.h5.gz
done

# decompress Dfam 3.9 paritions
gunzip *.gz

# move up to RepeatMasker main directory
cd /home/tbessonn/miniconda3/envs/earlgrey/share/RepeatMasker/

# save the min_init partition as a backup, just in case!
mv /home/tbessonn/miniconda3/envs/earlgrey/share/RepeatMasker/Libraries/famdb/min_init.0.h5 /home/tbessonn/miniconda3/envs/earlgrey/share/RepeatMasker/Libraries/famdb/min_init.0.h5.bak

# Rerun RepeatMasker configuration
perl ./configure -libdir /home/tbessonn/miniconda3/envs/earlgrey/share/RepeatMasker/Libraries/ -trf_prgm /home/tbessonn/miniconda3/envs/earlgrey/bin/trf -rmblast_dir /home/tbessonn/miniconda3/envs/earlgrey/bin -hmmer_dir /home/tbessonn/miniconda3/envs/earlgrey/bin -abblast_dir /home/tbessonn/miniconda3/envs/earlgrey/bin -crossmatch_dir /home/tbessonn/miniconda3/envs/earlgrey/bin -default_search_engine rmblast
