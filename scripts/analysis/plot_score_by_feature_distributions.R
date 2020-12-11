
library(plyr)
library(tidyverse)

date_code <- "20201203"
output_path <- "product/figures/score_distribution"


tag <- "nSMase2 Fragment site LSD screen: top 5000 by score"
pose_features_fname <- "poses_top300000_features.tsv"

pose_features <- readr::read_tsv(
    pose_features_fname)

plot <- ggplot2::ggplot(
    data = pose_features %>%
        dplyr::mutate(ligand_charge = as.factor(ligand_charge))) +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "bottom") + 
    ggplot2::geom_density(
        mapping = ggplot2::aes(
            x = total_energy,
            y = log10(..density.. + 1),
            fill = ligand_charge,
            group = ligand_charge),
        color = "black",
        size = .3,
        alpha = .5) +
    ggplot2::scale_x_continuous("Docking Score (lower is better)") +
    ggplot2::scale_y_continuous("log10(Density+1)") +
    ggplot2::scale_fill_discrete("Ligand Charge") +
    ggplot2::ggtitle(
        label = "Score by Ligand Charge",
        subtitle = "tag")

ggplot2::ggsave(
    paste0(output_path, "/score_ligand_charge_", date_code, ".pdf"),
    width = 6,
    height = 4)
ggplot2::ggsave(
    paste0(output_path, "/score_ligand_charge_", date_code, ".png"),
    width = 6,
    height = 4)

                
        
            
