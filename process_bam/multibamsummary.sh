#!/bin/bash

hist1="k27"
hist2="k4"

# loop through files to correlate reps and plot
# pairwise correlation (Spearman)

multiBamSummary bins --bamfiles ~/cnt_2021/sorted_bam/"$hist1"/S[1-8]_sorted.bam -o "$hist1"_bamsummary.npz -p max
multiBamSummary bins --bamfiles ~/cnt_2021/sorted_bam/"$hist2"/*_sorted.bam -o "$hist2"_bamsummary.npz -p max


# now plot, with k27 vs k4 as separate files

for i in "$hist1" "$hist2"; do
	echo "plotting correlation $i"
	echo ""

	plotCorrelation -in "$i"_bamsummary.npz --corMethod spearman \
	 --skipZeros --plotTitle "$i bam correlation" \
	 --whatToPlot heatmap --plotFileFormat pdf \
	 --colorMap RdYlBu --plotNumbers \
	 -o "$i"_bam_spearman.pdf \
	 --outFileCorMatrix "$i"_bam_spearman_counts.txt

	 plotPCA -in "$i"_bamsummary.npz --transpose \
	 --plotFileFormat pdf \
	 -o "$i"_bam_PCA.pdf \
	 --plotTitle "$i PCA of read counts" 

done

