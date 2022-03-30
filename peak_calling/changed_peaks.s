#!/bin/bash

# script to find changed peaks between conditions

# definne variables: treatment, directories of interest
dir="intersected_peaks"
tx="solvent"
#tx="naph"
outdir="p16_changed"

# create directories if needed
mkdir -p intersected_peaks/
mkdir -p p16_changed/

# first need to select 3 columns (BED) from IDR output
for file in k4_solvent_neg k4_solvent_pos k4_naph_neg k4_naph_pos.bed; do
	awk '{print $1"\t"$2"\t"$3}' peaks/"$file".bed > "$dir/"$file".bed
done

# then will do 3 intersections
for hist in k4 k27; do

# peaks only in p16- (lost in p16+)
	bedtools intersect -a "$dir"/"$hist"_"$tx"_neg.bed -b "$dir"/"$hist"_"$tx"_pos.bed -v > \
	"$outdir"/"$hist"_"$tx"_p16pos_lost.bed

# peaks only in p16+ (gained in p16+)
	bedtools intersect -a "$dir"/"$hist"_"$tx"_pos.bed -b "$dir"/"$hist"_"$tx"_neg.bed -v > \
	"$outdir"/"$hist"_"$tx"_p16pos_gained.bed

# peaks that are shared in p16-, p16+ (& merge peaks within 1kb just in case)
	bedtools intersect -a "$dir"/"$hist"_"$tx"_neg.bed -b "$dir"/"$hist"_"$tx"_pos.bed | \
	bedtools merge -i - -d 1000 > "$outdir"/"$hist"_"$tx"_constant.bed

done

# count number of peaks in each, append to file
for peaks in "$outdir"/*.bed ; do
	
	echo "$peaks"
	echo "wc -l $peaks" >> "$outdir"/peak_counts.txt

done

