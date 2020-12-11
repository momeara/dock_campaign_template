#structure folder 'structures/<structure_tag>'
PREPARED_STRUCTURE=KCNQ2_7CR2_retigabine_AB_20201028

#database folder 'databases/<database_tag>'
DATABASE=project_20201028

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp -r ../../prepared_structures/${PREPARED_STRUCTURE}/* .

source ../../scripts/dock_setup_library.sh ${DATABASE}

echo "Running dock ..."
$DOCKBASE/docking/submit/submit.csh

echo "Collecint dock results ..."
time $DOCKBASE/analysis/extract_all.py --done
source ../../scripts/dock_get_poses.sh




