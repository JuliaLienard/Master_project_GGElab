#!/usr/bin/ python3

"""
Author : Julia Lienard 
Date : 2025/04/04

Description: This script will filter the sequences in the Homo_sapiens.GRCh38.cdna.all.fa 
for a list of transcript ID provided, and calculates the percentage of GC of the corresponding cdna sequences.

The input fasta file has new lines within the sequences and can be removed while creating a new fasta as follow :
awk 'BEGIN{seq=""} /^>/{if(seq) print seq; print $0; seq=""} !/^>/{seq=seq$0} END{if(seq) print seq}'  Homo_sapiens.GRCh38.cdna.all.fa > Homo_sapiens.GRCh38.cdna.all_NoNewLine.fa

Usage: python Filter_Ensembl_cdna_fasta_GCpercCalc.py

"""
def calculate_gc_content(sequence):
    g = sequence.count('G')
    c = sequence.count('C')
    total = len(sequence)
    gc_content = (g + c) / total * 100
    return gc_content

# Initialize the dictionary to store gene names and their corresponding IDs
with open("bc_transcriptID.txt", "r") as transcriptList:
	dic_transcriptID = {}
	for row in transcriptList:
		Line = row.strip().split("\t") # Split the line by tab
		ID = Line[1]
		gene_name = Line[0]
		dic_transcriptID[ID] = gene_name # Store the ID with gene name as the key


with open("../Homo_sapiens.GRCh38.cdna.all_NoNewLine.fa", "r") as inputFA, open("bc_transcript_GC.txt", "w") as output:
	output.write('Gene_name\ttranscriptID\tSeq_GC_perc\n')
	for line in inputFA:
		if line.startswith(">"):
			header = line.strip().split("\t")
			transcriptID_long = header[0]
			transcriptID = transcriptID_long[1:].split(".")
			transcriptID_final = transcriptID[0]
			if transcriptID_final in dic_transcriptID:
				seq = next(inputFA)
				output.write(f'{dic_transcriptID[transcriptID_final]}\t{transcriptID_final}\t{round(calculate_gc_content(seq),4)}\n')