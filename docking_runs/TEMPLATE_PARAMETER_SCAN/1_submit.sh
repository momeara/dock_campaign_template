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
for params in ${PREPARED_STRUCTURE}/combo_directories/*/ ; do
    echo "Submitting job for param set: ${param}"

    mkdir -p results/$(basename ${params})
    pushd results/$(basename ${params})
    bash ${DOCK_TEMPLATE}/scripts/dock_submit.sh \
         ${DATABASE}/database.sdi \
         ${params}/dockfiles \
         .
    popd
done
