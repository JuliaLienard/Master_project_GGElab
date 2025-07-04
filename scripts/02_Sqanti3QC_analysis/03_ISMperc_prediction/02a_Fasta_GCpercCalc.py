#!/usr/bin/ python3

"""
Author : Julia Lienard 
Date : 2025/05/05

Description: This script calculates the percentage of GC of the provided FASTA sequences.
The fasta files obtained after IsoSeq Collapse were used here.

Usage: python Fasta_GCpercCalc.py

Change the input file name in the script directly when changing for another one.

"""

def calculate_gc_content(sequence):
    g = sequence.count('G')
    c = sequence.count('C')
    total = len(sequence)
    gc_content = (g + c) / total * 100
    return gc_content


with open("../collapsed_bc02.fasta", "r") as inputFA, open("bc02_sequences_GC.txt", "w") as output:
	output.write('isoform_id\tSeq_GC_perc\n')
	for line in inputFA:
		if line.startswith(">"):
			header = line.strip().split("|")
			isoform_id = header[0].lstrip(">")
			seq = next(inputFA)
			output.write(f'{isoform_id}\t{round(calculate_gc_content(seq),3)}\n')