#!/bin/bash

# next use idr to determine overlap between replicates

mkdir -p idr
mkdir -p idr/logfiles

in_dir="macs2"
S1_S3="k27_solvent_neg"
S2_S4="k27_solvent_pos"
S5_S7="k27_naph_neg"
S6_S8="k27_naph_pos"
S9_S11="k4_solvent_neg"
S10_S12="k4_solvent_pos"
S13_S15="k4_naph_neg"
S14_S16="k4_naph_pos"

echo "IDR to assess replicate peak similarity"
echo "Comparing S1 and S3"
echo ""

idr -s "$in_dir"/S1_k27*.broadPeak "$in_dir"/S3_k27*.broadPeak --input-file-type broadPeak \
	--output-file idr/"$S1_S3".bed --log-output-file idr/logfiles/"$S1_S3".txt \
	--plot --soft-idr-threshold 0.1


idr -s "$in_dir"/S2_k27*.broadPeak "$in_dir"/S4_k27*.broadPeak --input-file-type broadPeak \
	--output-file idr/"$S2_S4".bed --log-output-file idr/logfiles/"$S2_S4".txt \
	--plot --soft-idr-threshold 0.1

idr -s "$in_dir"/S5_k27*.broadPeak "$in_dir"/S7_k27*.broadPeak --input-file-type broadPeak \
	--output-file idr/"$S5_S7".bed --log-output-file idr/logfiles/"$S5_S7".txt \
	--plot --soft-idr-threshold 0.1

idr -s "$in_dir"/S6_k27*.broadPeak "$in_dir"/S8_k27*.broadPeak --input-file-type broadPeak \
	--output-file idr/"$S6_S8".bed --log-output-file idr/logfiles/"$S6_S8".txt \
	--plot --soft-idr-threshold 0.1

idr -s "$in_dir"/S9_k4*.narrowPeak "$in_dir"/S11_k4*.narrowPeak --input-file-type narrowPeak \
	--output-file idr/"$S9_S11".bed --log-output-file idr/logfiles/"$S9_S11".txt \
	--plot --soft-idr-threshold 0.1

idr -s "$in_dir"/S10_k4*.narrowPeak "$in_dir"/S12_k4*.narrowPeak --input-file-type narrowPeak \
	--output-file idr/"$S10_S12".bed --log-output-file idr/logfiles/"$S10_S12".txt \
	--plot --soft-idr-threshold 0.1


idr -s "$in_dir"/S13_k4*.narrowPeak "$in_dir"/S15_k4*.narrowPeak --input-file-type narrowPeak \
	--output-file idr/"$S13_S15".bed --log-output-file idr/logfiles/"$S13_S15".txt \
	--plot --soft-idr-threshold 0.1

idr -s "$in_dir"/S14_k4*.narrowPeak "$in_dir"/S16_k4*.narrowPeak --input-file-type narrowPeak \
	--output-file idr/"$S14_S16".bed --log-output-file idr/logfiles/"$S14_S16".txt \
	--plot --soft-idr-threshold 0.1


# now print out peak numbers from this
for i in idr/*.broadPeak idr/*.narrowPeak ; do
	
	echo "$i"
	echo "wc -l $i" >> peak_counts.txt

done

