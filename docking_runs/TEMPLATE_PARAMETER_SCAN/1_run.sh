#structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../../prepared_structures/<structure_id>)

#database folder 'databases/<database_id>'
DATABASE=$(readlink -f ../../databases/<database_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp -r ${PREPARED_STRUCTURE}/* .

source ${DOCK_TEMPLATE}/scripts/dock_setup_library.sh ${DATABASE}

echo "Running dock ..."
$DOCKBASE/docking/submit/submit.csh

echo "Collecint dock results ..."
time $DOCKBASE/analysis/extract_all.py --done
source ${DOCK_TEMPALTE}/scripts/dock_get_poses.sh
