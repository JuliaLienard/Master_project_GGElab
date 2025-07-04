#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 13 17:43:34 2025

@author: jlienard

Description: this scripts take a list of genes (1 per row, using the same gene name as the genome annotation used for
Sqanti3QC) and the classification.txt output file from Sqanti3QC that has been merged with the FL_assoc column of the
collapsed_<sample>.abundance.tsv from IsoCollapse. The script extracts for each gene and corresponding transcript isoform:
    - the isoform id
    - number of exons
    - the structural category
    - structural subcategory
    - FL counts
    - diff_to_TSS
    - diff_to_TTS
and outputs this in a new table.

Usage: python script gene_list sample_class_FLNC.txt

"""

# 1. import modules
import sys
import os

gene_list = sys.argv[1]
sample_class = sys.argv[2]

# 2. Extracting the basename of each input file to name the output file
FileName = os.path.basename(sample_class).split("_")
basename = FileName[0]

# 3. Create the output directory if it does not exist
output_dir = "04_output"
os.makedirs(output_dir, exist_ok=True)

with open(gene_list, "r") as genes:
    set_genes = set()
    for rows in genes:
        gene_name = rows.strip()
        set_genes.add(gene_name)
        
with open(sample_class, "r") as sample_class, open("04_output/" + basename + "_neoantigens_class_FLNC.txt", "w") as output_genes:
    next(sample_class)
    output_genes.write(f'neoantigen\tisoform_id\tnumber_exons\tcategory\tsubcategory\tFL_count\tdiff_to_TSS\tdiff_to_TTS\n')
    for isoforms in sample_class:
        row = isoforms.strip().split("\t")
        isoform_id = row[0]
        associated_gene = row[6]
        number_exons = row[4]
        category = row[5]
        subcategory = row[14]
        FL_count = row[48]
        diff_to_TSS = row[10]
        diff_to_TTS = row[11]
        RTS_stage = row[15]
        if RTS_stage == "FALSE" and associated_gene in set_genes:
            output_genes.write(f'{associated_gene}\t{isoform_id}\t{number_exons}\t{category}\t{subcategory}\t{FL_count}\t{diff_to_TSS}\t{diff_to_TTS}\n')
        
    