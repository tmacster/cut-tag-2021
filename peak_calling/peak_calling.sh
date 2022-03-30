#!/bin/bash

#########################################
# script to process files: 
# make bigwigs 
# call peaks using MACS2
# make bedgraphs --> then call peaks using SEACR
#########################################


hist1="k27"
hist2="k4"
dir="sorted_bam"

#mkdir -p bigwigs 
#mkdir -p bigwigs_scaled
mkdir -p macs2
mkdir -p macs2/logfiles
mkdir -p bed
mkdir -p bedgraphs2
mkdir -p sorted_bam2

for hist in $hist1 $hist2 ; do
	mkdir -p sorted_bam2/"$hist"
done

for i in "$dir"/"$hist1"/*.bam "$dir"/"$hist2"/*.bam ; do
	base=$(basename "$i" _sorted.bam) #define a variable for sample ID (from file name)
	hist=$(dirname "${i#*/}") #define a variable for k27 vs k4 (from directory name)
		filename="$base"_"$hist"

	echo "1. converting $i: bam to bigwig"
	echo ""

	#bamCoverage -b "$i" --outFileName bigwigs/"$filename".bw -p max

	echo "2. converting $i: bam to 1x normalized bigwig"
	echo ""

	#bamCoverage -b "$i" --outFileName bigwigs_scaled/"$filename"_rpgc.bw \
	#--normalizeUsing RPGC --effectiveGenomeSize 2652783500 -p max

	if [[ $hist =~ "k27" ]]; then
		echo "3. calling peaks using MACS2 for $base. Sample is $hist1; will call broad peaks."
		echo ""
		
		macs2 callpeak -t "$i" -q 0.01 -f BAMPE --keep-dup all \
		-n "$filename" -g mm --outdir macs2 \
		--broad 2> macs2/logfiles/"$filename"_log.txt
	elif [[ $hist =~ "k4" ]]; then
		echo "3. calling peaks using MACS2 for $base. Sample is $hist2; will call narrow peaks."
		echo ""

		macs2 callpeak -t "$i" -q 0.01 -f BAMPE --keep-dup all \
		-n "$filename" -g mm --outdir macs2 2> macs2/logfiles/"$filename"_log.txt
	fi

	echo "4. re-sorting BAM file by read name"
	echo ""
	samtools sort -n "$i" -o sorted_bam2/"$hist"/"$base"_sorted.bam

	echo ""
	echo "5. generating bam index for $base"
	samtools index sorted_bam2/"$hist"/"$base"_sorted.bam sorted_bam2/"$hist"/"$base"_sorted.bai

done


for i in sorted_bam2/"$hist"/*.bam; do 
	base=$(basename "$i" _sorted.bam)
	hist=$(dirname "${i#*/}")
		filename="$base"_"$hist"

	echo ""
	echo "making bedgraph file from $i" # following instructions from SEACR github

	#bamCoverage -b "$i" --outFileName bedgraphs2/"$filename".bedgraph --outFileFormat bedgraph --binSize 10 -p max
	bedtools bamtobed -bedpe -i "$i" > bed/"$filename".bed
	awk '$1 != "." && $1==$4 && $6-$2 < 1000 {print $0}' bed/"$filename"_clean.bed
	cut -f 1,2,6 "$filename"_clean.bed | sort -k1,1 -k2,2n -k3,3n > "$filename"_fragments.bed

	bedtools genomecov -bg -i "$filename"_fragments.bed -g ~/refs/mm10/mm10.chrom.sizes > bedgraphs2/"$filename".bedgraph

	echo "calling peaks"
	echo ""

	#bash SEACR_1.3.sh bedgraphs2/"$filename".bedgraph 0.01 non stringent seacr/"$filename"

	echo "done with $i"

done

echo "Processing is done!"
