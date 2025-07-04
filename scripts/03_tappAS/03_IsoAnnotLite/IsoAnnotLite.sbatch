#!/bin/bash
#SBATCH --job-name=IsoAnnot
##SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=70gb
#SBATCH --qos=short
#SBATCH --time=03:00:00 
#SBATCH -o logs/IsoAnnotLite_tamaMergebc01_02_corr_%j.out  # Standard output goes to this file
#SBATCH -e logs/IsoAnnotLite_tamaMergebc01_02_%j.err  # Standard error goes to this file

# Running IsoAnnotLite on its own on the tama merged collapsed reads from bc01 and bc02 kinnex samples, then processed with SqantiQC
# Alejandro helped me fix an issue with IsoAnnotLite that needs the "_corrected.gtf.cds.gff" from SqantiQC instead of what is specified _corrected.gtf. 

# for debug eventually
pwd;echo "start at ";date

module load anaconda
source activate sqanti3

Ensembl_tappAS="/home/jlienard/human/GRCh38/Homo_sapiens_GRCh38_Ensembl_86.gff3"

 python /home/jlienard/sqanti/SQANTI3/src/utilities/IsoAnnotLite_SQ3.py \
 ../bc01_bc02_isocollapseTamamerged_corrected.gtf.cds.gff \
 ../bc01_bc02_isocollapseTamamerged_classification.txt \
../bc01_bc02_isocollapseTamamerged_junctions.txt \
-gff3 $Ensembl_tappAS -o Ensembl86/bc01_bc02_isocollapseTamamerged_Ensembl86 -novel -saveTranscriptIDs -stdout output

# output: /home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh38_mapping/output/02_sqantiQC/IsoAnnotLite