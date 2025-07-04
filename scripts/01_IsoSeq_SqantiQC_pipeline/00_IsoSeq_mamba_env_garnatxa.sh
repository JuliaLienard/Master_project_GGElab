Installation on garnatxa of the tools needed for Isoseq pipeline

# create mamba environment in my garnatxa interactive session
module load anaconda
mamba create -n lrRNAseq
mamba activate lrRNAseq

# list the available environments:
mamba info --envs

# remove an environment
mamba activate # mamba version 1.5.11
mamba env remove -n NameOfEnv

# install modules
## lima https://lima.how/ and https://github.com/PacificBiosciences/pbbioconda
conda install -c bioconda lima
lima --version
# version installed 2.12.0

## isoseq https://github.com/pacificbiosciences/isoseq/
conda install -c bioconda isoseq  # isoseq-4.2.0

## pbmm2 https://github.com/PacificBiosciences/pbmm2/
conda install -c bioconda pbmm2 # pbmm2-1.16.99

## bamtools to get statistics on the reads
conda install -c bioconda bamtools # version 2.5.2

# pbcore (includes also pbstats) https://github.com/PacificBiosciences/pbcore
conda config --show channels
conda config --add channels bioconda # do same with conda-forge if not there
conda install pbcore

# list the tools installed in the env
mamba list