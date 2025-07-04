#!/bin/bash
#SBATCH --job-name=sqantireads
##SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50gb
#SBATCH --qos=short
#SBATCH --time=10:00:00 
#SBATCH -o logs/sqantireads_v6_%j.out  # Standard output goes to this file
#SBATCH -e logs/sqantireads_v6_%j.err  # Standard error goes to this file

# for debug eventually
pwd;echo "start at ";date 

# Load modules and activate the environment
module load anaconda
source activate sqanti3

# Paths to the 3 mandatory unput data files:
sqantiQC_out_InputDir=/home/jlienard/BetaCells_kinnex/04_sqantiQC/02_Using_GRCh38_mapping/output
RefAnnot=/storage/gge/genomes/human202212/Homo_sapiens.GRCh38.109.gtf
RefFasta=/storage/gge/genomes/human202212/Homo_sapiens.GRCh38.dna.primary_assembly.fa

sqantireads_outputDir=/home/jlienard/BetaCells_kinnex/05_sqanti_reads/02_Using_GRCh38_mapping

# Running

python3 /home/jlienard/sqanti/SQANTI3/sqanti3_reads.py  \
--design design_v6.csv \
--annotation $RefAnnot \
--genome $RefFasta \
--dir $sqantireads_outputDir \
--input_dir $sqantiQC_out_InputDir \
--verbose

echo "ends at ";date