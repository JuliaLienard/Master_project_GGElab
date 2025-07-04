#!/bin/bash
#SBATCH --job-name=cluster2
##SBATCH --ntasks=1
#SBATCH --cpus-per-task=15
#SBATCH --mem=60gb
#SBATCH --qos=short
#SBATCH --time=05:00:00 
#SBATCH -o cluster2_%j.out  # Standard output goes to this file
#SBATCH -e cluster2_%j.err  # Standard error goes to this file

# loading required module and environment
module load anaconda
source activate lrRNAseq # environment containing isoseq tools installed among others

# for debug eventually
pwd;echo "start at ";date 

# paths to files and output
Refinedreads=/storage/gge/JuliaLienard/data/files/pr_151/analysis/flnc-2.bam
outpur_dir=/home/jlienard/BetaCells_kinnex/01_clustering_reads

# use iso-seq cluster2 to remove duplicate isoforms:De novo isoform-level clustering
isoseq cluster2 --singletons --use-qvs $Refinedreads $outpur_dir/clustered-bc02.bam

echo "ends at ";date