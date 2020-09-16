#!/usr/bin/env Rscript
# -*- tab-width:2;indent-tabs-mode:t;show-trailing-whitespace:t;rm-trailing-spaces:t -*-
# vi: set ts=2 noet:


library(readr)

gather_interaction_fingerprints <- function(run_dir, force=FALSE, verbose=TRUE){
	ifps_path <- paste0(run_dir, "/interaction_fingerprints.tsv")
	if(!file.exists(ifps_path) | force){
		cat("Computing interaction fingerprints for run '", run_dir, "' -> '", ifps_path, "'\n", sep="")
		system(
			paste0(
				"python scripts/compute_interaction_fingerprints.py ",
				"--receptor ", run_dir, "/working/rec.crg.pdb ",
				"--ligands ", run_dir, "/poses.mol2 ",
				"--output ", ifps_path))
	}
	if(!file.exists(ifps_path)){
		stop(paste0("interaction_fingerprints path: '", ifps_path, "' does not exist!", sep=""))
	}
	ifps <- readr::read_tsv(
		ifps_path,
		col_types=c(
			ligand_id = readr::col_character(),
			residue = readr::col_integer(),
			interaction_type = readr::col_integer(),
			count = readr::col_integer()))
	ifps
}
