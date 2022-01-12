#!/bin/bash

#structure folder 'structures/<structure_id>'
STRUCTURE=$(readlink -f ../../structures/<structure_id>)

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ${DOCK_TEMPLATE}/structures/${STRUCTURE}/rec.pdb rec.pdb
cp ${DOCK_TEMPLATE}/structures/${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_standard.sh

mv INDOCK dockfiles/

source ${DOCK_TEMPLATE}/scripts/dock_visualize_setup.sh
