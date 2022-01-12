#!/bin/bash

#structure folder:
STRUCTURE=$(readlink -f ../../structures/<structure_tag>)

COVALENT_RESIDUE_NUMBER=422
COVALENT_RESIDUE_NAME=CYS
COVALENT_RESIDUE_ATOMS=HG

source ${DOCK_TEPLATE}/scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ${STRUCTURE}/rec.pdb rec.pdb
cp ${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

# run blastermaster standard to protonate the receptor
# then use the protonated receptor as the input to blastermaster covalent
source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_standard.sh
mv working working_standard
cp working_standard/rec.crg.pdb rec.pdb
mkdir working

source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_covalent.sh \
       ${COVALENT_RESIDUE_NUMBER} \
       ${COVALENT_RESIDUE_NAME} \
       ${COVALENT_RESIDUE_ATOMS}

source ${DOCK_TEMPLATE}/scripts/dock_indock_tight_covalent.sh

mv INDOCK dockfiles/

source ${DOCK_TEMPLATE}/scripts/dock_visualize_setup.sh
