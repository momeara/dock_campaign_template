#!/bin/bash

#structure folder 'structures/<structure_tag>'
STRUCTURE=<structure_tag>

#database folder 'databases/<_tag>'
DATABASE=<database_tag>

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ../../structures/${STRUCTURE}/rec.pdb rec.pdb
cp ../../structures/${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

echo "Setting up dock and the screening library ..."
source ../../scripts/dock_blastermaster_standard.sh
source ../../scripts/dock_setup_library.sh ${DATABASE}

echo "Running dock ..."
source ../../scripts/dock_submit.sh

echo "Collecint dock results ..."
source ../../scripts/dock_extract_all.sh
source ../../scripts/dock_get_poses.sh
