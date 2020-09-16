#!/usr/bin/env Rscript
# -*- tab-width:2;indent-tabs-mode:t;show-trailing-whitespace:t;rm-trailing-spaces:t -*-
# vi: set ts=2 noet:

library(plyr)
library(dplyr)
library(stringr)
library(tidyr)
library(readr)

#' Parse the header section out of a mol2 file into a table
gather_pose_features <- function(
	mol2_fname,
	verbose=FALSE,
	fields = NULL,
	col_types=readr::cols(
		.default = readr::col_double(),
		name = readr::col_character(),
		pose_id = readr::col_character(),
		ligand_source_file = readr::col_character(),
		long_name = readr::col_character(),
		protonation = readr::col_character(),
		smiles = readr::col_character())){
	if(verbose){
		cat("Loading features from '", mol2_fname, "' ...\n", sep = "")
	}
	if (!file.exists(mol2_fname)) {
			cat("ERROR: mol2 file '", mol2_fname, "' does not exist\n", sep = "")
			return(data.frame())
	}
	if(length(readLines(mol2_fname, n = 1)) == 0 && verbose){
			cat("WARNING: mol2 file '", mol2_fname, "' is empty.\n", sep = "")
			return(data.frame())
	}

	z <- mol2_fname %>%
		readr::read_lines() %>%
		tibble::tibble(line=.) %>%
		dplyr::filter(line %>% stringr::str_detect("^##########")) %>%
		dplyr::mutate(
			key = line %>%
				stringr::str_sub(11, 31) %>%
				stringr::str_trim() %>%
				stringr::str_to_lower() %>%
				stringr::str_replace_all(" ", "_"),
			value = line %>% stringr::str_sub(33) %>%
				stringr::str_trim()) %>%
		dplyr::select(-line) %>%
		dplyr::mutate(name = ifelse(key=="name", value, NA)) %>%
		dplyr::mutate(row_number = row_number())
	# it may be the case that the molecule is in the file multiple times with the same name
	z <- z %>%
		dplyr::left_join(
			z %>% dplyr::filter(!is.na(name)) %>%
				dplyr::group_by(name) %>%
				dplyr::mutate(
					pose_id = paste0(name, "_", row_number())) %>%
				dplyr::ungroup() %>%
				dplyr::select(row_number, name, pose_id),
			by=c("row_number", "name")) %>%
		dplyr::select(-row_number)
	z <- z %>%
		tidyr::fill(name, pose_id) %>%
		dplyr::filter(key != "name")
	if(!(is.null(fields))){
		z <- z %>% dplyr::filter(key %in% fields)
  }
	z <- z %>%
		tidyr::spread(key, value) %>%
		readr::type_convert(col_type=col_types)
	if(verbose){
		cat("found ", ncol(z), " features for ", nrow(z), " substances\n", sep="")
	}
	z
}

# if run as a script
if (sys.nframe() == 0){
		library("optparse")
		options <- optparse::OptionParser() %>%
				optparse::add_option(
						opt_str = c("-v", "--verbose"),
						action = "store_true",
						default = FALSE,
						help = "Print extra output [default: FALSE]") %>%
			  optparse::add_option(
						opt_str = "--mol2_files",
						action = "store",
						default = "./ligand*/test.mol2.gz",
						help = "Directory where dock was run [default: ./*/test.mol2.gz]") %>%
			  optparse::add_option(
						opt_str = "--fields",
						action = "store",
						default = NULL,
						help = "Directory where dock was run [default: <all>]") %>%
				optparse::add_option(
						opt_str = "--output_fname",
						action = "store",
						default = "pose_features.tsv",
						help = "Output .tsv file for docking") %>%
			  optparse::parse_args()

		mol2_files <- options$mol2_files %>% Sys.glob()

		if (options$verbose) {
				cat("Gathering docking features from ", length(mol2_files), " mol2 files.\n", sep = "")
		}

		mol2_files %>%
				purrr::map_dfr(
						.f = gather_pose_features,
						fields = options$fields,
						verbose = options$verbose) %>%
				readr::write_tsv(path = options$output_fname)
}


