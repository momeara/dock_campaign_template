#!/bin/bash

#structure folder 'prepared_structures/<structure_tag>'
PREPARED_STRUCTURE=<structure_tag>

#database folder 'databases/<_tag>'
DATABASE=<database_tag>

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp -r ../../prepared_structures/${PREPARED_STRUCTURE}/* .

source ../../scripts/dock_setup_library.sh ${DATABASE}

echo "Running dock ..."
$DOCKBASE/docking/submit/submit.csh

echo "Collecint dock results ..."
source ../../scripts/dock_extract_all.sh
source ../../scripts/dock_get_poses.sh


time python $DOCKBASE/analysis/get_docking_statistics.py . dirlist docking_statistics.txt
