#!/bin/bash
#SBATCH --job-name=collapse
##SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=15gb 
#SBATCH --qos=short
#SBATCH --time=00:45:00 
#SBATCH -o logs/collapse_bc%j.out  # Standard output goes to this file
#SBATCH -e logs/collapse_bc_%j.err  # Standard error goes to this file

module load anaconda
source activate lrRNAseq

pwd;echo "start at ";date # for debug eventually

Refinedreads1=/storage/gge/JuliaLienard/data/files/pr_151/analysis/flnc-1.bam
AlignedReads1=/home/jlienard/BetaCells_kinnex/02_mapping_pbmm2/02_GRCh38_mapping/output/aligned-bc01.bam

# create index for the refined reads flnc
pbindex $Refinedreads1 # remove if done previously

mkdir output

# use iso-seq collapse to collapse mapped reads into unique isoforms
isoseq collapse --do-not-collapse-extra-5exons $AlignedReads1 $Refinedreads1 output/collapsed_bc01.gff

echo "ends at ";date