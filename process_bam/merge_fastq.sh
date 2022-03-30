#!/bin/bash

# script to merge paired-end sequencing files (fq) from different lanes
# designed for samples S1-S8 (H3K27me3) / S9-S16 (H3K4me3)

START1=1
END1=8
hist1="k27"
for i in $(seq $START1 $END1) ; do
	echo "concatenating file $i"
	echo ""

	cat ${hist1}/"$i"_*_R1_*.fastq.gz > raw/S"$i"_1.fq.gz
	cat ${hist1}/"$i"_*_R2_*.fastq.gz > raw/S"$i"_2.fq.gz
done

START2=9
END2=16
hist2="k4"
for i in $(seq $START2 $END2) ; do
	echo "concatenating file $i"
	echo ""

	cat ${hist2}/"$i"_*_R1_*.fastq.gz > raw/S"$i"_1.fq.gz
	cat ${hist2}/"$i"_*_R2_*.fastq.gz > raw/S"$i"_2.fq.gz
done
