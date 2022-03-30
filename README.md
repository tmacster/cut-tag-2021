Collection of scripts made for analyzing CUT&Tag data (H3K27me3 and H3K4me3).

Steps: 

process_bam/
- reorganize raw fq files
- align to mm10

peak_calling/
- produce processed files: bigwigs, bedgraphs
- call peaks: using MACS2
- IDR
- peak intersections by bedtools

downstream/
R scripts for plotting

Scripts written by Trisha Macrae, PhD (UCSF / 2022)
