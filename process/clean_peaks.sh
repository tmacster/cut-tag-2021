#!/bin/bash

# script to process peak files from replicates

dir="k4_shared_peaks"
sol1="k4_solvent_neg_merged"
sol2="k4_solvent_pos_merged"
naph1="k4_naph_neg_merged"
naph2="k4_naph_pos_merged"


# obtain peaks that are totally gained or lost: SOLVENT
bedtools subtract -a "$dir"/"$sol1".bed -b "$dir"/"$sol2".bed -A > "$dir"/k4_sol_gained.bed
bedtools subtract -a "$dir"/"$sol2".bed -b "$dir"/"$sol1".bed -A > "$dir"/k4_sol_lost.bed

# obtain peaks that are totally gained or lost: NAPHTHALENE
bedtools subtract -a "$dir"/"$naph1".bed -b "$dir"/"$naph2".bed -A > "$dir"/k4_naph_gained.bed
bedtools subtract -a "$dir"/"$naph2".bed -b "$dir"/"$naph1".bed -A > "$dir"/k4_naph_lost.bed


# obtain peaks that are partially gained or lost: SOLVENT
bedtools subtract -a "$dir"/"$sol1".bed -b "$dir"/"$sol2".bed > "$dir"/k4_sol_part_gained.bed
bedtools subtract -a "$dir"/"$sol2".bed -b "$dir"/"$sol1".bed > "$dir"/k4_sol_part_lost.bed

# obtain peaks that are partially gained or lost: NAPHTHALENE
bedtools subtract -a "$dir"/"$naph1".bed -b "$dir"/"$naph2".bed > "$dir"/k4_naph_part_gained.bed
bedtools subtract -a "$dir"/"$naph2".bed -b "$dir"/"$naph1".bed > "$dir"/k4_naph_part_lost.bed

# ----------------

dir="k27_shared_peaks"
sol1="k27_solvent_neg_merged"
sol2="k27_solvent_pos_merged"
naph1="k27_naph_neg_merged"
naph2="k27_naph_pos_merged"


# obtain peaks that are totally gained or lost: SOLVENT
bedtools subtract -a "$dir"/"$sol1".bed -b "$dir"/"$sol2".bed -A > "$dir"/k27_sol_gained.bed
bedtools subtract -a "$dir"/"$sol2".bed -b "$dir"/"$sol1".bed -A > "$dir"/k27_sol_lost.bed

# obtain peaks that are totally gained or lost: NAPHTHALENE
bedtools subtract -a "$dir"/"$naph1".bed -b "$dir"/"$naph2".bed -A > "$dir"/k27_naph_gained.bed
bedtools subtract -a "$dir"/"$naph2".bed -b "$dir"/"$naph1".bed -A > "$dir"/k27_naph_lost.bed


# obtain peaks that are partially gained or lost: SOLVENT
bedtools subtract -a "$dir"/"$sol1".bed -b "$dir"/"$sol2".bed > "$dir"/k27_sol_part_gained.bed
bedtools subtract -a "$dir"/"$sol2".bed -b "$dir"/"$sol1".bed > "$dir"/k27_sol_part_lost.bed

# obtain peaks that are partially gained or lost: NAPHTHALENE
bedtools subtract -a "$dir"/"$naph1".bed -b "$dir"/"$naph2".bed > "$dir"/k27_naph_part_gained.bed
bedtools subtract -a "$dir"/"$naph2".bed -b "$dir"/"$naph1".bed > "$dir"/k27_naph_part_lost.bed

