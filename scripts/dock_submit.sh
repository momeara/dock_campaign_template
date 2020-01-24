#!/bin/bash

# this is just $DOCKBASE/docking/submit/submit.csh
# but saves the SGE job id to submit.pid

DIRNUM=$(wc -l dirlist)
SUBMIT_JOB_ID=$(qsub \
  -terse \
  -t 1-$DIRNUM \
  $DOCKBASE/docking/submit/rundock.csh \
  $DOCKBASE/docking/DOCK/bin/dock.csh)
echo "Your job-array ${SUBMIT_JOB_ID}.1-${DIRNUM}:1 (\"rundock.csh\") has been submitted"
echo "Saving SGE job id to submit.pid"
echo $SUBMIT_JOB_ID > submit.pid

