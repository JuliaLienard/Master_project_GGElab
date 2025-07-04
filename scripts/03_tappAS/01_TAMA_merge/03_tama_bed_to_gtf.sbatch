#!/bin/bash
#SBATCH --job-name=tamabedTOgtf
#SBATCH --time=02:00:00 #elapsed 00:03:36
#SBATCH --qos=short
##SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=15gb #12G needed 
#SBATCH --output=logs/tama_bedTOgtf_%j.out  # Standard output goes to this file
#SBATCH --error=logs/tama_bedTOgtf_%j.err # Standard error goes to this file

# This script runs TAMA tama_convert_bed_gtf_ensembl_no_cds.py on the bed files generated after tama merge (merging of collapsed.bed files from iso Collapse)

# for debug eventually
pwd;echo "start at ";date

module load anaconda
source activate tama

python /home/jlienard/tama/tama_go/format_converter/tama_convert_bed_gtf_ensembl_no_cds.py bc01_bc02_isocollapseTamamerged.bed bc01_bc02_isocollapseTamamerged.gtf

echo "ends at ";date