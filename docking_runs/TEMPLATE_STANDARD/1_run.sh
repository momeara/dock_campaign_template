#!/bin/bash

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi

#structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../../prepared_structures/<structure_id>)

#database folder 'databases/<database_id>'
DATABASE=$(readlink -f ../../databases/<database_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo "Running dock ..."
bash ${DOCK_TEMPLATE}/scripts/dock_submit.sh \
     ${DATABASE}/database.sdi \
     ${PREPARED_STRUCTURE}/dockfiles \
     results

echo "Collecint dock results ..."
ls results/ | grep -v joblist | sed "s#^#results/#" > dirlist
python ${DOCKBASE}/analysis/extract_all_blazing_fast.py dirlist extract_all.txt 10
python ${DOCKBASE}/analysis/getposes_blazing_faster.py '' extract_all.sort.uniq.txt 500 poses.mol2

source ${DOCK_TEMPLATE}/scripts/dock_statistics.sh

Rscript ${DOCK_TEMPLATE}/scripts/analysis/gather_pose_features.R --verbose
