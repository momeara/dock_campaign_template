#!/usr/bin/env Rscript
# -*- tab-width:2;indent-tabs-mode:t;show-trailing-whitespace:t;rm-trailing-spaces:t -*-
# vi: set ts=2 noet:

library(plyr)
library(dplyr)
library(stringr)
library(tidyr)
library(readr)

#' Parse the header section out of a mol2 file into a table
load_mol2_features <- function(
	mol2_fname,
	verbose=FALSE,
	col_types=readr::cols(
		.default = readr::col_double(),
		name = readr::col_character(),
		pose_id = readr::col_character(),
		ligand_source_file = readr::col_character(),
		long_name = readr::col_character(),
		protonation = readr::col_character(),
		smiles = readr::col_character())){
	if(verbose){
		cat("Loading features from '", mol2_fname, "' ...", sep="")
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
		dplyr::filter(key != "name") %>%
		tidyr::spread(key, value) %>%
		readr::type_convert(col_type=col_types)
	if(verbose){
		cat("found ", ncol(z), " features for ", nrow(z), " molecules\n", sep="")
	}
	z
}

load_all_mol2_features <- function(dock_dir){
	features <- Sys.glob(paste0(dock_dir, "/*/test.mol2.gz")) %>%
		purrr::map_dfr(load_mol2_features, verbose=TRUE)
}

