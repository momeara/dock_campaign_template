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
