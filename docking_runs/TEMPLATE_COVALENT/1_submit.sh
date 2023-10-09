#!/bin/bash


if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi



# structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../../prepared_structures/<structure_id>)


#database folder 'databases/<database_id>'
DATABASE=$(readlink -f ../../databases/<database_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo "Running dock ..."
#bash ${DOCK_TEMPLATE}/scripts/dock_submit.sh \
 #    ${DATABASE}/database.sdi \
  #   ${PREPARED_STRUCTURE}/dockfiles \
   #  results

export INPUT_SOURCE=$(readlink -f ${DATABASE}/database.sdi)
export DOCKFILES=$(readlink -f ${PREPARED_STRUCTURE}/dockfiles)
export EXPORT_DEST=$(readlink -f results)
export DOCKEXEC=${DOCKBASE}/docking/DOCK/bin/dock64
export SHRTCACHE=${SCRATCH_DIR}
export LONGCACHE=${SCRATCH_DIR}
export SBATCH_ARGS="--mem-per-cpu=${SLURM_MEM} --time=${SLURM_TIME} --account=${SLURM_ACCOUNT} --mail-user=${SLURM_MAIL_USER} --mail-type=${SLURM_MAIL_TYPE} --partition=${SLURM_PARTITION}"

DOCKFILES_COMMON=${SCRATCH_DIR}/DOCK_common/dockfiles.$(cat ${DOCKFILES}/* | sha1sum | awk '{print $1}')
echo "Copying dockfiles to '${DOCKFILES_COMMON}'"
cp -r ${DOCKFILES} ${DOCKFILES_COMMON}
bash ${DOCKBASE}/docking/submit/slurm/subdock.bash
echo "Check status with: squeue | grep -e \"$(whoami)\" -e \"rundock\""
