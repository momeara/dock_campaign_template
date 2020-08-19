#!/bin/bash

# Use DocKOVALENT

#structure folder 'structures/<structure_id>'
STRUCTURE=<structure_id>
COVALENT_RESIDUE_NUMBER=<residue_number>
COVALENT_RESIDUE_NAME=<residue_name>
COVALENT_RESIDUE_ATOMS=<residue_atoms>

#database folder 'databases/<database_id>'
DATABASE=<database_id>

source ../../scripts/dock_clean.sh


echo "Setting up dock and the screening library ..."
source ../../scripts/dock_blastermaster_covalent.sh \
  ${COVALENT_RESIDUE_NUMBER} \
  ${COVALENT_RESIDUE_NAME} \
  ${COVALENT_RESIDUE_ATOMS}

# update INDOCK for covalent docking
#SEARCH MODE
sed -i "s/check_clashes                 yes/check_clashes                 no/" INDOCK

#MATCHING
sed -i "s/bump_maximum                  10.0/bump_maximum                  100.0/" INDOCK
sed -i "s/bump_rigid                    10.0/bump_rigid                    100.0/" INDOCK
sed -i "s/mol2_score_maximum            10.0/mol2_score_maximum            100.0/" INDOCK

#DOCKOVALENT
sed -i "s/dockovalent                   no/dockovalent                   yes/" INDOCK

# these need to be adjusted for the receptor residue used for attachement
# E.g. for CYS attachment:
sed -i "s/bond_ang1                     109.5/bond_ang1                     102/" INDOCK
sed -i "s/bond_ang2                     109.5/bond_ang2                     115/" INDOCK

# Adjust sampling
# WARNING: due to un mitigated steric repulsion, it will typically find
#          interactions at the outer limit of the len_range.
sed -i "s/len_range                     0.0/len_range                     0.06/" INDOCK
sed -i "s/len_step                      0.1/len_step                      0.01/" INDOCK
sed -i "s/ang1_range                    10.0/ang1_range                    3.0/" INDOCK
sed -i "s/ang2_range                    10.0/ang2_range                    3.0/" INDOCK
sed -i "s/ang1_step                     2.5/ang1_step                     .25/" INDOCK
sed -i "s/ang2_step                     2.5/ang2_step                     .25/" INDOCK

#MINIMIZATION
sed -i "s/minimize                      yes/minimize                      no/" INDOCK


source ../../scripts/dock_setup_library.sh ${DATABASE}

echo "Running dock ..."
source ../../scripts/dock_submit.sh

echo "Collecint dock results ..."
source ../../scripts/dock_extract_all.sh
source ../../scripts/dock_get_poses.sh
