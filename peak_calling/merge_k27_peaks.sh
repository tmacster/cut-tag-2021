#!/bin/bash

######################################
# merge and intersect peaks
######################################

# first will merge peaks that are very close (only for h3k27me3)

window="3000"

mkdir -p merged_peaks

for peaks in macs2/*_k27_*.broadPeak ; do 
	filename=$(basename "$peaks" .broadPeak)

	echo "Merging peaks within $window bp"
	echo ""

	bedtools merge -i macs2/"$filename".broadPeak -d "$window" > merged_peaks/"$filename".bed

	# count number of original vs merged peaks
	echo "$peaks"
	echo "wc -l $peaks" >> merged_peaks/counts.txt
	echo ""
	echo "$filename"
	echo "wc -l $filename.bedtools" >> merged_peaks/counts.txt

	echo "intersecting biological replicates"
	echo ""

done

mkdir -p k27_shared_peaks

bedtools intersect -a merged_peaks/S1*.bed -b merged_peaks/S3*.bed | sort -k1,1 -k2,2n - | \
	bedtools merge -i stdin -d 5000 > k27_shared_peaks/k27_solvent_neg.bed

bedtools intersect -a merged_peaks/S2*.bed -b merged_peaks/S4*.bed | sort -k1,1 -k2,2n - | \
	bedtools merge -i stdin -d 5000 > k27_shared_peaks/k27_solvent_pos.bed

bedtools intersect -a merged_peaks/S5*.bed -b merged_peaks/S7*.bed | sort -k1,1 -k2,2n - | \
	bedtools merge -i stdin -d 5000 > k27_shared_peaks/k27_naph_neg.bed

bedtools intersect -a merged_peaks/S6*.bed -b merged_peaks/S8*.bed | sort -k1,1 -k2,2n - | \
	bedtools merge -i stdin -d 5000 > k27_shared_peaks/k27_naph_pos.bed
