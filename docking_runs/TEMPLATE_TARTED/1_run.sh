#!/bin/bash

# Adjust the parameters of a parent docking run
# E.g. by adjusting the partial charges of certain receptor residues sometimes called tarting:
# http://wiki.bkslab.org/index.php/DOCK_3.7_tutorial_(Anat)#Tarting_a_residue_in_DOCK3.7


#docking run folder 'docking_runs/<docking_run_id>
PARENT_DOCKING_RUN=$(readlink -f ../<docking_run_id>)

#database folder 'databases/<database_id>'
DATABASE=$(readlink -f ../../databases/<database_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo "tarting prepared structure from ${PARENT_DOCKING_RUN}"
mkdir working
cp ${PARENT_DOCKING_RUN}/rec.pdb ./
cp ${PARENT_DOCKING_RUN}/xtal-lig.pdb ./
cp ${PARENT_DOCKING_RUN}/working/rec.crg.pdb working/
cp ${PARENT_DOCKING_RUN}/working/prot.table.ambcrg.ambH ./
cp ${PARENT_DOCKING_RUN}/working/amb.crg.oxt ./


##########################################################################
# Example tarting                                                        
# decrease charge of the terminal nitrogen on K435 by -0.4 charge units
##########################################################################
sed -i 's/LYS A 435/LYU A 435/g' working/rec.crg.pdb
cat prot.table.ambcrg.ambH \
    | grep -P '.......LYS' \
    | sed 's/^\(.......\)LYS/\1LYU/g' \
    | sed 's/ CD    LYU        0.048  3/ CD    LYU        0.148  3/g' \
    | sed 's/ CE    LYU        0.218  3/ CE    LYU        0.518  3/g' \
    | sed 's/ NZ    LYU       -0.272  9/ NZ    LYU       -0.672  9/g' \
    >> prot.table.ambcrg.ambH
cat amb.crg.oxt \
    | grep -P '......lys' \
    | sed 's/^\(......\)lys/\1lyu/g' \
    | sed 's/CD    lyu        0.048/CD    lyu        0.148/g' \
    | sed 's/CE    lyu        0.218/CE    lyu        0.518/g' \
    | sed 's/NZ    lyu       -0.272/NZ    lyu       -0.672/g' \
    >> amb.crg.oxt

echo "Setting up dock and the screening library ..."
source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_tarted.sh
source ${DOCK_TEMPLATE}/scripts/dock_setup_library.sh ${DATABASE}

echo "Running dock ..."
source ${DOCK_TEMPLATE}/scripts/dock_submit.sh

echo "Collecint dock results ..."
source ${DOCK_TEMPLATE}/scripts/dock_extract_all.sh
source ${DOCK_TEMPLATE}/scripts/dock_get_poses.sh
source ${DOCK_TEMPLATE}/scripts/dock_statistics.sh
