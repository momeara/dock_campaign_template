#!/bin/bash

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi

#structure folder:
STRUCTURE=$(readlink -f ../../structures/<structure_id>)

# enter residue number for covalent docking
COVALENT_RESIDUE_NUMBER=
COVALENT_RESIDUE_NAME=CYS
COVALENT_RESIDUE_ATOMS=HG

echo "Selected residue for covalent docking:"
echo "   residue nubmer: ${COVALENT_RESIDUE_NUMBER}"
echo "   residue name:   ${COVALENT_RESIDUE_NAME}"
echo "   covalent atoms:  ${COVALENT_RESIDUE_ATOMS}"

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ${STRUCTURE}/rec.pdb rec.pdb
cp ${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

# run blastermaster standard to protonate the receptor
# then use the protonated receptor as the input to blastermaster covalent

