#!/bin/bash

# small script to clean up BEDPE files (have a bunch of weird rows in them)

for i in bed/*.bed ; do 
	base=$(basename "$i" .bed)
	
	# remove rows that start with "."
	# keep read pairs on the same chromosome and fragment length <1kb 
	
	echo "cleaning up bedpe file"
	echo ""

	# extract the fragment-related columns and sort
	awk '$1 != "."' bed/"$base".bed > bed/"$base"2.bed
	
	echo ""
	echo "making bedgraph file from $i" # following instructions from SEACR github
	bedtools genomecov -bg -i bed/"$base"2.bed -g ~/refs/mm10/mm10.chrom.sizes > bedgraphs2/"$base".bedgraph

	echo "calling peaks"
	echo ""

	bash SEACR_1.3.sh bedgraphs2/"$base".bedgraph 0.01 non stringent seacr/"$base"

	echo "done with $i"

	#rm bed/"$base"_clean.bed
	#rm bed/"$base".bed

done

echo "Processing is done!"
