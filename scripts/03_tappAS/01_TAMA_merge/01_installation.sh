# installing TAMA on garnatxa (HPC)
# https://github.com/GenomeRIK/tama/wiki/Tama-Merge

# Tama uses python version 2, so we need a conda environment:

module load anaconda
mamba create -n tama python=2
# version 2.7 installed

# in a chosen directory:
git clone https://github.com/GenomeRIK/tama.git

#install biopython
# https://github.com/biopython/biopython/blob/master/README.rst

cd /home/jlienard/.conda/envs/tama/bin/
pip install biopython==1.76 # last version python2 compatible