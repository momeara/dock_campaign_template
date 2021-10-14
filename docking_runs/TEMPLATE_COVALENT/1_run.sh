#!/bin/bash

# structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../../prepared_structures/<structure_id>)


#database folder 'databases/<database_id>'
DATABASE=$(readlink -f ../../databases/<database_id>)

source ${DOCK_TEMPALTE}/scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp -r ${PREPARED_STRUCTURE}/* .

source ${DOCK_TEMPLATE}/scripts/dock_setup_library.sh ${DATABASE}


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


source ${DOCK_TEMPALTE}/scripts/dock_setup_library.sh ${DATABASE}

echo "Running dock ..."
source ${DOCK_TEMPALTE}/scripts/dock_submit.sh

echo "Collecint dock results ..."
source ${DOCK_TEMPLATE}/scripts/dock_extract_all.sh
source ${DOCK_TEMPLATE}/scripts/dock_get_poses.sh
