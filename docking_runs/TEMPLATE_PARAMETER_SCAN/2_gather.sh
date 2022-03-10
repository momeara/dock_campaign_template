#!/bin/bash

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi


echo "Gather dock results ..."
find results -maxdepth 2 -mindepth 2 -type d > dirlist
python ${DOCKBASE}/analysis/extract_all_blazing_fast.py dirlist extract_all.txt 10
python ${DOCKBASE}/analysis/getposes_blazing_faster.py '' extract_all.sort.uniq.txt 500 poses.mol2 test.mol2.gz

source ${DOCK_TEMPLATE}/scripts/dock_statistics.sh

# Check that this works correctly
Rscript ${DOCK_TEMPLATE}/scripts/analysis/gather_pose_features.R \
	--verbose \
	--mol2_files="results/*/*/test.mol2.gz*"

