#!/bin/bash

STRUCTURE_FNAME=../../structures/<structure_fname>.pdb
XTAL_LIG_FNAME=../../structures/<xtal-lig_fname>.pdb

#libary folder 'databases/<library_tag>'
DATABASE_NAME=<DATABASE_NAME>

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ${STRUCTURE_FNAME} rec.pdb
cp ${XTAL_LIG_FNAME} xtal-lig.pdb

echo "Setting up dock and the screening library ..."
source ../../scripts/dock_blastermaster_standard.sh
source ../../scripts/dock_setup_library.sh ${DATABASE_NAME}

echo "Running dock ..."
source ../../scripts/dock_submit.sh

echo "Collecint dock results ..."
source ../../scripts/dock_extract_all.sh
source ../../scripts/dock_get_poses.sh
