#!/bin/bash

hist1="k27"
hist2="k4"

# loop through files to create correlation (pearson)

multiBamSummary bins --bamfiles ~/cnt_2021/sorted_bam/S[1-8]_sorted.bam -o ${hist1}_bamsummary.npz -p max
multiBamSummary bins --bamfiles ~/cnt_2021/sorted_bam/S[9-16]_sorted.bam -o ${hist2}_bamsummary.npz -p max


# now plot, k27 vs k4 as separate files

for i in ${hist1} ${hist2}; do
	echo "plotting correlation $i"
	echo ""

	plotCorrelation -in "$i"_bamsummary.npz --corMethod pearson \
	 --skipZeros --plotTitle "${i} bam correlation" \
	 --whatToPlot heatmap --colorMap RdYlBu --plotNumbers \
	 -o "$i"_bam_pearson.pdf \
	 --outFileMatrix "$i"_bam_pearson_counts.txt

done
