#!/usr/bin/ python3
'''
Author : Julia Lienard 
Date : 20245/06/10

Description: The script counts in a the output from 00_Merge_SqQCclass_FLcounts.R (merging basename_classification.txt 
[SqantiQC output] file with the FLNC_counts) for each annotated gene (non annotated are ignored), the number of isoforms (FLNC) of FSM, NIC + NNC categories and the ratio
(NIC+NNC)/(FSM+NIC+NNC)). The isoforms with RTS_stage = TRUE are removed (ie. one of the junctions could be a RT 
switching artifact). The script reports these numbers in an output table, named basename_RBN_counts.txt.

output files from Sqanti3QC (classification.txt for this analysis can be found here: 
/home/jlienard/BetaCells_kinnex/04_sqantiQC/02_Using_GRCh38_mapping/output
output from IsoSeq Collapse to find the <sample>.flnc_count.txt and prior use of 00_Merge_SqQCclass_FLcounts.R is found:
/home/jlienard/BetaCells_kinnex/03_collapsing_isoseq_collapse/02_Using_GRCh38_mapping/output/

Usage : 01f_Extract_stats_FL_classificationSQ_FLNC.py classification.txt

'''

# Import required modules
import sys
import sys
import os

class_file=sys.argv[1]
FileName = os.path.basename(class_file).split("_")
basename = FileName[0]

# STEP1: create temporary file with only isoform lines that are FSM, NNC or NIC:
with open(class_file, "r") as SQ_classif, open(basename + "_tmp_SQ_classif", "w") as tmp_classif:
	header = SQ_classif.readline()  # Read the first line (header)
	tmp_classif.write(header)
	for line in SQ_classif:
		columns = line.strip().split("\t")
		category = columns[5]
		RTS_stage = columns[15]
		if RTS_stage == "FALSE" and category in ["full-splice_match", "novel_in_catalog", "novel_not_in_catalog"]:
			tmp_classif.write(line)

# STEP2: use the reduced temporary classification file to get the FL counts for FSM, NNC and NIC for each gene in a second temporary file
with open(basename + "_tmp_SQ_classif", "r") as class_input, open(basename + "_FSM_NIC_NNC_counts_tmp.txt", "w") as output_file:
	next(class_input) # skip header line
	group_associated_gene = None
	chrom_associated = None
	FSM_count = 0 # initialize the counts
	NIC_NNC_count = 0
	
	output_file.write(f'associated_gene\tchr\tFSM_count\tNIC+NNC_count\n')

	for line in class_input:
		isoform_line = line.strip().split("\t")
		FL_count = int(isoform_line[48])
		associated_gene = isoform_line[6].strip()
		struct_category = isoform_line[5].strip()
		chrom = isoform_line[1]
		if associated_gene != "": # check that the associated_gene is not empty ie. an annotated gene exists
			if group_associated_gene == None:
				group_associated_gene = associated_gene
				chrom_associated = chrom
	
			if group_associated_gene == associated_gene:
				if struct_category == "full-splice_match":
					FSM_count += FL_count
				if struct_category == "novel_in_catalog" or struct_category == "novel_not_in_catalog":
					NIC_NNC_count += FL_count
                    
			if group_associated_gene != associated_gene:
				output_file.write(f'{group_associated_gene}\t{chrom}\t{FSM_count}\t{NIC_NNC_count}\n')
				FSM_count = 0 # initialize the counts
				NIC_NNC_count = 0
				group_associated_gene = associated_gene
				chrom_associated = chrom
				if struct_category == "full-splice_match":
					FSM_count += FL_count
				if struct_category == "novel_in_catalog" or struct_category == "novel_not_in_catalog":
					NIC_NNC_count += FL_count

	output_file.write(f'{group_associated_gene}\t{chrom}\t{FSM_count}\t{NIC_NNC_count}\n')

# for more efficiency the tmp_classif file is parsed only once, but duplicated annotated genes corresponding to
# different isoform groups are also output as many times as there are groups associated with this gene, so now we
# merge counts for similar annotated genes

# Create the output directory if it does not exist
output_dir = "01_output"
os.makedirs(output_dir, exist_ok=True)

final_output = "01_output/" + basename + "_FSM_NIC_NNC_counts_.txt"

with open(basename+"_FSM_NIC_NNC_counts_tmp.txt", "r") as tmp_file, open ("01_output/" + basename + "_RBN_counts_FLNC.txt", "w") as final_output:
	final_output.write(f'associated_gene\tchr\tFSM_count\tNIC+NNC_count\t(NIC+NNC)/(FSM+NIC+NNC)\n')
	
	dic_annot_genes = {} # Create an empty dictionary to store the counts
	next(tmp_file)
	for Line in tmp_file:
		columns = Line.strip().split("\t")
		gene_name = columns[0]
		chr_n = columns[1]
		FSM = int(columns[2])  # Convert to integers
		NIC_NNC = int(columns[3])
		

	    # If the gene already exists in the dictionary, update its values
		if gene_name in dic_annot_genes:
			dic_annot_genes[gene_name][1] += FSM  # Update FSM count
			dic_annot_genes[gene_name][2] += NIC_NNC  # Update NIC+NNC count
		else:
			# If the gene does not exist, initialize it with the current counts
			dic_annot_genes[gene_name] = [chr_n, FSM, NIC_NNC]

	# Write the results to the output
	for gene_name, counts in dic_annot_genes.items():
		RBN = float((counts[2])/(counts[1]+counts[2]))
		final_output.write(f"{gene_name}\t{counts[0]}\t{counts[1]}\t{counts[2]}\t{RBN}\n")
			
# remove temporary file
os.remove(basename + "_FSM_NIC_NNC_counts_tmp.txt")
os.remove(basename + "_tmp_SQ_classif")