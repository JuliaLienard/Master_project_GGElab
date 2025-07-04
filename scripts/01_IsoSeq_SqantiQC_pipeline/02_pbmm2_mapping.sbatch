#!/bin/bash

#SBATCH --job-name=pbmm2
##SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=38gb
#SBATCH --qos=short
#SBATCH --time=05:00:00 # lasted 2h56

#SBATCH -o 02_pbmm2_bc%j.out  # Standard output goes to this file
#SBATCH -e 02_pbmm2_bc%j.err  # Standard error goes to this file

# clustered.bam files generated after IsoSeq cluster2 are used here for the mapping

pwd; echo "starts at"; date

# Set variables
Ref=/storage/gge/genomes/human202212/Homo_sapiens.GRCh38.dna.primary_assembly.fa

# Load modules and activate the environment
module load anaconda
source activate lrRNAseq # the pbmm2 tool is installed in this environment

mkdir -p output

for file in /home/jlienard/BetaCells_kinnex/01_clustering_reads/output/clustered-bc*.bam; do
    sample=$(basename "$file" .bam | sed 's/clustered-//')
    output="aligned-${sample}.bam"
    echo "Processing: $file -> $output"
    # Alignment
    pbmm2 align --preset ISOSEQ $Ref "$file" "output/$output" --sort -j 8
    
done

echo "ends at"; date