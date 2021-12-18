#!/bin/bash

##############################################
# inspired by Michelle Percharde, PhD (2018) #
# mm10, PE version                           #
# analyze CUT&Tag.                           #
##############################################

# usage requires zipped files (.fq.gz)

flagcheck=0

while getopts ':ghi:' flag; do 
 case ${flag} in
  i) dir=$OPTARG
  flagcheck-1 ;;
  g) gz='true' ;;
  h) echo ""
echo "	-h	Help mode, prints usage"
echo "	-g	Input FASTQ is .gz compressed"
echo "	-i	input file directory/. use "./" for current dir (not recommended)"
echo ""
flagcheck = 1
exit 1 ;;
 esac
done

if [ "$flagcheck" == 0 ] ; then
	echo ""
	echo "Incorrect or no -i specified, please read help (-h) and try again!"
	echo ""
	exit 1
fi

mkdir -p trimmed/fastqc/
mkdir -p sorted_bam/
mkdir -p alignment_summaries/
mkdir -p bedgraphs/

for file in "$dir"*_1* ; do 
	echo ""
	if [ "$gz" == "true" ] ; then
		base=$(basename $file _1.fq.gz)
		name1=$(basename $file .fq.gz)
			name2=$(basename $file _1.fq.gz)_2
			file1=$file
			file2="$dir"${name2}.fq.gz
		trimfile1=${name1}_val_1.fq.gz
		trimfile2=${name2}_val_2.fq.gz
	fi
	
	echo "analyzing file: $name1, $name2"
	echo "trimmed will be $trimfile1 $trimfile2"
	echo "file1 is $file1, file2 is $file2"
	
	echo ""
	echo "CUT&Run pipeline courtesy of Michelle Percharde, PhD"
	echo ""
	
	echo "1. trimming paired files for $base with QC"
	echo ""
	trim_galore --fastqc --fastqc_args " --outdir trimmed/fastqc/" --nextera --paired -o trimmed/ $file1 $file2
	
	echo""
	echo "2. aligning $base to mm10 and sorting"
	echo ""
	(bowtie2 -p 8 /data/refs/mm10 -1 trimmed/$trimfile1 -2 trimmed/$trimfile2 --end-to-end --very-sensitive --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 1000 | samtools view -Suo - - | samtools sort - -o sorted_bam/${base}_sorted.bam) 2> alignment_summaries/${base}_alignment.txt
	
	#for long reads, use soft-clipping of the first 4 bases: --local --very-sensitive-local --no-mixed --no-discordant
	
	echo ""
	echo "3. generating bam index for $base"
	echo ""
	samtools index sorted_bam/${base}_sorted.bam sorted_bam/${base}_sorted.bai
	echo ""
	
	echo "4. making bedgraph"
	bedtools genomecov -ibam sorted_bam/${base}_sorted.bam -bga -pc | LC_COLLATE=C sort -k1,1 -k2,2n - > bedgraphs/${base}.bedGraph
	
	#rm $file1
	#rm $file2
	echo "$base DONE!"
	echo ""
	
done
