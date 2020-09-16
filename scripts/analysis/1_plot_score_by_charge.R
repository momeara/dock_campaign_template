#!/usr/bin/env Rscript
# -*- tab-width:2;indent-tabs-mode:t;show-trailing-whitespace:t;rm-trailing-spaces:t -*-
# vi: set ts=2 noet:


library(plyr)
library(tidyverse)

plot_score_by_charge <- function(
    reference_dock_run_ids,
    active_dock_run_ids,
    output_fname){

}
            
#################


scores <- tibble::tibble(
    run_id = c(
        # actives
        "nsm-a015_symm_20200828,fragments_round_1_hits_20200828,,20200828",
        "nsm-a015_HIE463_symm_20200831,fragments_round_1_hits_20200828,,20200831",
        "nsm-a031_symm_20200818,fragments_round_1_hits_20200828,,20200828",
        "nsm-a031_HIE463_symm_20200901,fragments_round_1_hits_20200828,,20200901",        
        # decoys
        "nsm-a015_symm_20200828,fragments_round_1_hits_decoys_20200828,,20200828",
        "nsm-a015_HIE463_symm_20200831,fragments_round_1_hits_decoys_20200828,,20200831",        
        "nsm-a031_symm_20200818,fragments_round_1_hits_decoys_20200828,,20200828",
        "nsm-a031_HIE463_symm_20200901,fragments_round_1_hits_decoys_20200828,,20200901",
        # library
        "nsm-a015_symm_20200828,zinc_shards_instock_20200828,,20200828",
        "nsm-a015_HIE463_symm_20200831,zinc_shards_instock_20200828,,20200831",
        "nsm-a031_symm_20200818,zinc_shards_instock_20200828,,20200828",
        "nsm-a031_HIE463_symm_20200901,zinc_shards_instock_20200828,,20200901"),
    H463 = c(
        # actives
        "Protonated (HIP)",
        "Neutral (HIE)",
        "Protonated (HIP)",
        "Neutral (HIE)",
        # decoys
        "Protonated (HIP)",
        "Neutral (HIE)",
        "Protonated (HIP)",
        "Neutral (HIE)",
        # library
        "Protonated (HIP)",
        "Neutral (HIE)",
        "Protonated (HIP)",
        "Neutral (HIE)"),        
    fragment = c(
        # actives
        "nsm-a015 Aminobenzamide",
        "nsm-a015 Aminobenzamide",        
        "nsm-a031 4-Aminobenzoic acid",
        "nsm-a031 4-Aminobenzoic acid",
        # decoys
        "nsm-a015 Aminobenzamide",
        "nsm-a015 Aminobenzamide",        
        "nsm-a031 4-Aminobenzoic acid",
        "nsm-a031 4-Aminobenzoic acid",
        # library
        "nsm-a015 Aminobenzamide",
        "nsm-a015 Aminobenzamide",        
        "nsm-a031 4-Aminobenzoic acid",
        "nsm-a031 4-Aminobenzoic acid"),
    type = c(
        "active",
        "active",
        "active",
        "active",                
        "decoy",
        "decoy",
        "decoy",
        "decoy",
        "library",
        "library",
        "library",                
        "library")) %>%
    dplyr::rowwise() %>%
    dplyr::do({
        run <- .
        readr::read_tsv(
            file = paste0("docking_runs/", run$run_id, "/extract_all.sort.txt"),
            col_names = FALSE) %>%
            dplyr::transmute(
                ligand_id = X2,
                total_energy = X21) %>%
            dplyr::mutate(
                run_id = run$run_id,
                fragment = run$fragment,
                H463 = run$H463,
                type = run$type)            
    })

scores <- scores %>% dplyr::filter(total_energy <= 0)
        

ggplot2::ggplot() +
    ggplot2::theme_bw() +
    ggplot2::geom_density(
        data = scores %>%
           dplyr::filter(type == "library"),
        mapping = ggplot2::aes(
            x = total_energy,
            y = log10(..density.. + 1)),
        fill = "blue",
        alpha = .3) +
    ggplot2::geom_rug(
        data = scores %>%
            dplyr::filter(type == "decoy"),
        mapping = ggplot2::aes(
            x = total_energy),
        color = "black") +
    ggplot2::geom_vline(
        data = scores %>%
            dplyr::filter(type == "active"),
        mapping = ggplot2::aes(
            xintercept = total_energy),
        color = "brown") +
    ggplot2::facet_grid(
        cols = dplyr::vars(fragment),
        rows = dplyr::vars(H463)) +
    ggplot2::scale_x_continuous(
        name = "Dock Total Score (kcal/mol)") +
    ggplot2::scale_y_continuous(
        name = "Log(density)") +
    ggplot2::ggtitle(
        label = "Enrichment of Xtal Framents",
        subtitle = "vs. DUDE decoys and ZINC in-stock and Mw < 200")

ggplot2::ggsave(
    filename = "product/docking_setup/fragment_enrichment_vs_decoys_zinc_shards_20200901.pdf",
    width = 7,
    height = 5)

ggplot2::ggsave(
    filename = "product/docking_setup/fragment_enrichment_vs_decoys_zinc_shards_20200901.png",
    width = 7,
    height = 5)



            
    
    
                
