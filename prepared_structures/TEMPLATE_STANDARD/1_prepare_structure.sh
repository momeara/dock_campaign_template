#!/bin/bash

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi


#structure folder 'structures/<structure_id>'
STRUCTURE=$(readlink -f ../../structures/<structure_id>)

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ${STRUCTURE}/rec.pdb rec.pdb
cp ${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_standard.sh
