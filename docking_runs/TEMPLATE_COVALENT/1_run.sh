#!/bin/bash

# structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../../prepared_structures/<structure_id>)


#database folder 'databases/<database_id>'
DATABASE=$(readlink -f ../../databases/<database_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp -r ${PREPARED_STRUCTURE}/* .

source ${DOCK_TEMPLATE}/scripts/dock_setup_library.sh ${DATABASE}


echo "Running dock ..."
bash ${DOCK_TEMPLATE}/scripts/dock_submit.sh \
     ${DATABASE}/database.sdi \
     ${PREPARED_STRUCTURE}/working \
     results

echo "Collecint dock results ..."
source ${DOCK_TEMPLATE}/scripts/dock_extract_all.sh
source ${DOCK_TEMPLATE}/scripts/dock_get_poses.sh
source ${DOCK_TEMPLATE}/scripts/dock_statistics.sh
