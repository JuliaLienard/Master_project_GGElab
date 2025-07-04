#!/bin/bash
#SBATCH --job-name=tamaMerge
#SBATCH --time=10:00:00 # it tooks 05:08:18
#SBATCH --qos=short
##SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=15gb # 14G used!
#SBATCH --output=logs/IsoCollapse_tamaMerge_%j.out  # Standard output goes to this file
#SBATCH --error=logs/IsoCollapse_tamaMerge_%j.err # Standard error goes to this file

# This script runs TAMA format_converter first on the transcriptome annotation files of bc01 and bc02 after Iso Collapse (gtf to bed format) and then TAMA merge

# for debug eventually
pwd;echo "start at ";date

module load anaconda
source activate tama

# Converting gtf files in bed files which are the required input file format for Tama Merge
for file in /home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh32_mapping/output/collapsed_bc0*.gtf ;
    do
        output_bed="/home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh32_mapping/output/$(basename "$file" .gtf).bed"
        python /home/jlienard/tama/tama_go/format_converter/tama_format_gff_to_bed12_cupcake.py $file "$output_bed"
    done

# tama merge
## usage : python tama_merge.py -f filelist.txt -p Output_prefix
## create first filelist.txt
for bedfile in /home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh32_mapping/output/collapsed_bc0*.bed;
    do
        sample_name=$(basename "$bedfile" .bed | sed 's/collapsed_//')
        echo -e "${bedfile}\tcapped\t1,1,1\t$sample_name" >> "/home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh32_mapping/output/01_tama_merge/filelist.txt"
    done
# echo -e allows interpretation of escape sequences like \n (new line), \t (tab), and \c (suppress new line)

python /home/jlienard/tama/tama_merge.py -f /home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh32_mapping/output/01_tama_merge/filelist.txt -p bc01_bc02_isocollapseTamamerged -a 5 -m 0 -z 5 -d merge_dup

# -a: 5'end threshold
# -m: exon ends/splice junction threshold
# -z: 3'end threshold
# -d: merging duplicate transcript groups (no_merge (default) or merge_dup)

echo "ends at ";date