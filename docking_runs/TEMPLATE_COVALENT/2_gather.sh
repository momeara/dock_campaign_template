#!/bin/bash
  
if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi

echo "Gather dock results ..."
ls -d results/* > dirlist
sed -i '$ d' dirlist
python ${DOCKBASE}/analysis/extract_all_blazing_fast.py dirlist extract_all.txt 100
# python ${DOCKBASE}/analysis/getposes_blazing_faster.py '' extract_all.sort.uniq.txt 1000000 poses.mol2 test.mol2.gz.0 > poses_out.txt

# source ${DOCK_TEMPLATE}/scripts/dock_statistics.sh

# Rscript ${DOCK_TEMPLATE}/scripts/analysis/gather_pose_features.R --verbose
