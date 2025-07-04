#!/usr/bin/ python3
'''
Author : Julia Lienard 
Date : 20245/06/10

Description: The script takes the outputs from 01_Extract_stats_FL_classificationSQ_FLNC.py (basename + "_RBN_counts_FLNC.txt)
and compares the annotated gene names of each file, to output only the genes that are common between the input files, while
calculating the difference between the two sample RBN values.
Here the script was developped for an analysis of two samples, we thus generate two outputs with 01_Extract_stats_FL_classificationSQ_FLNC.py and use them with the current script.

Usage : 02_Common_genes_classificationSQ_noRound_FLNC.py input1_RBN_counts_FLNC.txt input2_RBN_counts_FLNC.txt


'''

# 1. Import required modules
import sys
import os

input1 = sys.argv[1]
input2 = sys.argv[2]


# 2. Extracting the basename of each input file to name the output file
FileName1 = os.path.basename(input1).split("_")
basename1 = FileName1[0]

FileName2 = os.path.basename(input2).split("_")
basename2 = FileName2[0]


# 3. Create the output directory if it does not exist
output_dir = "02_output"
os.makedirs(output_dir, exist_ok=True)

with open(input1, "r") as input1List, open(input2, "r") as input2List, open("02_output/" + basename1 + basename2 + "common_genes_RBN_diff_FLNC.txt", "w") as outputFile:
    outputFile.write(f'associated_gene\tchr\tsample1_FSM\tsample2_FSM\tsample1_(NIC+NNC)\tsample2_(NIC+NNC)\tsample1_RBN\tsample2_RBN\tRBN_Difference\n')

    next(input1List) # Skip header in input1

# Step 1: Read input2 into a dictionary

    input2_dict = {}
    next(input2List)  # Skip header

    for rows_input2 in input2List:
        columns_s2 = rows_input2.strip().split("\t")
        if len(columns_s2) < 5:
            continue  # or print a warning
        gene_input2 = columns_s2[0]
        FSM_s2 = columns_s2[2]
        NIC_NNC_s2 = columns_s2[3]
        RBN_s2 = columns_s2[4]
        input2_dict[gene_input2] = (FSM_s2, NIC_NNC_s2, RBN_s2)


    # Step 2: Process input1 and compare with input2
    for rows_input1 in input1List:
        columns_s1 = rows_input1.strip().split("\t")
        if len(columns_s1) < 5:
            continue  # or print a warning
        gene_input1 = columns_s1[0]
        chr_input1 = columns_s1[1]
        FSM_s1 = columns_s1[2]
        NIC_NNC_s1 = columns_s1[3]
        RBN_s1 = columns_s1[4]

        if gene_input1 in input2_dict:
            FSM_s2, NIC_NNC_s2, RBN_s2 = input2_dict[gene_input1]
            try:
                RBN_diff = float(RBN_s1) - float(RBN_s2)
            except ValueError:
                continue
            RBN_diff = float(RBN_s1) - float(RBN_s2)
            outputFile.write(f'{gene_input1}\t{chr_input1}\t{FSM_s1}\t{FSM_s2}\t{NIC_NNC_s1}\t{NIC_NNC_s2}\t{RBN_s1}\t{RBN_s2}\t{RBN_diff}\n')