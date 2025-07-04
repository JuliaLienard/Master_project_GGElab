#!/bin/bash
#SBATCH --job-name=sqantiQC
##SBATCH --ntasks=1
#SBATCH --cpus-per-task=4 # only 2 CPUs used, got a warning
#SBATCH --mem=45gb # mem peak 40G
#SBATCH --qos=short
#SBATCH --time=18:00:00 # elapsed 02:09:00
#SBATCH -o logs/sqantiQC_tamamerge_bcV2_%j.out  # Standard output goes to this file
#SBATCH -e logs/sqantiQ_tamamergeC_bcV2_%j.err  # Standard error goes to this file

# for debug eventually
pwd;echo "start at ";date 

# Load modules and activate the environment
module load anaconda
source activate sqanti3

# Paths to the 3 mandatory unput data files:
RefAnnot=/storage/gge/genomes/human202212/Homo_sapiens.GRCh38.109.gtf
RefFasta=/home/jlienard/human/Homo_sapiens.GRCh38.dna.primary_assembly.fa

TamaMergeInput=/home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh32_mapping/output/01_tama_merge/bc01_bc02_isocollapseTamamerged.gtf
# providing paths for other optional arguments
OutputDir=/home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh32_mapping/output/02_sqantiQC
## Pre-computed tappAS annotation files for human for isoAnnotLite run in SQANTI3
tappas_GRCh38_human=/home/jlienard/human/Homo_sapiens_GRCh38_RefSeq_78.gff3
polyA=/home/jlienard/BetaCells_kinnex/04_sqantiQC/mouse_and_human.polyA_motif.txt

sample=$(basename "$TamaMergeInput" .gtf)
echo "Processing: $sample"; date
    
# Running SqantiQC
python3 /home/jlienard/SQANTI3v5.3.4/sqanti3_qc.py -n 2 -o "$sample" -d "$OutputDir" --report pdf --polyA_motif_list "$polyA" --skipORF --isoAnnotLite --gff3 "$tappas_GRCh38_human" "$TamaMergeInput" "$RefAnnot" "$RefFasta"

echo "ends at ";date