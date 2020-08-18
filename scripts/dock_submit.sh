#!/bin/bash

# this is just $DOCKBASE/docking/submit/submit.csh
# but saves the SGE job id to submit.pid


#$DOCKBASE/docking/submit/subdock.csh $DOCKBASE/docking/DOCK/bin/dock.csh

if [ ! -f "dirlist" ]; then
    echo "Error: Cannot find dirlist, the list of subdirectories!"
    echo "Exiting!"
    exit 1
fi


DIRNUM=$(wc -l dirlist)
SUBMIT_JOB_ID=$(qsub \
  -terse \
  -t 1-$DIRNUM \
  $DOCKBASE/docking/submit/rundock.csh \
  $DOCKBASE/docking/DOCK/bin/dock.csh)
echo "Your job-array ${SUBMIT_JOB_ID}.1-${DIRNUM}:1 (\"rundock.csh\") has been submitted"
echo "Saving SGE job id to submit.pid"
echo $SUBMIT_JOB_ID > submit.pid

