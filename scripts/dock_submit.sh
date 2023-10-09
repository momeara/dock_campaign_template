#!/bin/bash

# this is just $DOCKBASE/docking/submit/submit.csh
# but saves the SGE job id to submit.pid


#$DOCKBASE/docking/submit/subdock.csh $DOCKBASE/docking/DOCK/bin/dock.csh

#if [ ! -f "dirlist" ]; then
#    echo "Error: Cannot find dirlist, the list of subdirectories!"
#    echo "Exiting!"
#    exit 1
#fi

if [[ ${CLUSTER_TYPE} = "SGE" ]]; then
    DIRNUM=$(wc -l dirlist)
    SUBMIT_JOB_ID=$(qsub \
      -terse \
      -t 1-$DIRNUM \
      $DOCKBASE/docking/submit/rundock.csh \
      $DOCKBASE/docking/DOCK/bin/dock.csh)
    echo "Your job-array ${SUBMIT_JOB_ID}.1-${DIRNUM}:1 (\"rundock.csh\") has been submitted"
    echo "Saving SGE job id to submit.pid"
    echo $SUBMIT_JOB_ID > submit.pid
elif [[ ${CLUSTER_TYPE} -eq "SLURM" ]]; then
    # check if variables are defined
    # if the ${DOCKFILES} directory is writable, then create .shasum in in it
    # for each file in database.sdi
    #    if OUTDOCK.0 or test.mol2.gz.0 doesn't exist, add it to the joblist
    # call sbatch on rundock.bash

    export INPUT_SOURCE=$(readlink -f $1)
    export DOCKFILES=$(readlink -f $2)
    export EXPORT_DEST=$(readlink -f $3 )
    export DOCKEXEC=${DOCKBASE}/docking/DOCK/bin/dock64
    export SHRTCACHE=${SCRATCH_DIR}
    export LONGCACHE=${SCRATCH_DIR}
    export SBATCH_ARGS="--account=${SLURM_ACCOUNT} --mail-user=${SLURM_MAIL_USER} --mail-type=${SLURM_MAIL_TYPE} --partition=${SLURM_PARTITION}"

    DOCKFILES_COMMON=${SCRATCH_DIR}/DOCK_common/dockfiles.$(cat ${DOCKFILES}/* | sha1sum | awk '{print $1}')
    echo "Copying dockfiles to '${DOCKFILES_COMMON}'"
    cp -r ${DOCKFILES} ${DOCKFILES_COMMON}
    #    njobs=$(wc -l dirlist)

    #    sbatch ${SBATCH_ARGS} --signal=B:USR1@120 --array=1-${njobs} ${DOCKBASE}/docking/submit/slurm/rundock.bash   
    bash ${DOCKBASE}/docking/submit/subdock.bash
    echo "Check status with: squeue | grep -e \"$(whoami)\" -e \"rundock\""
else
    echo "Unrecognized cluster type '${CLUSTER_TYPE}'"
fi
