#!/bin/bash


# http://wiki.bkslab.org/index.php/How_to_process_results_from_a_large-scale_docking#Check_for_completion_and_resubmit_failed_jobs

cp dirlist dirlist_ori
chmod -w dirlist_ori

csh $DOCKBASE/docking/submit/get_not_finished.csh ./
# creates dirlist_new

mv dirlist dirlist_old1
mv dirlist_new dirlist_new1
cp dirlist_new1 dirlist

# clean incomplete
for dir in $(cat dirlist)
do
  echo $dir
  rm -rf $dir/OUTDOCK $dir/test.mol2.gz $dir/stderr
done

$DOCKBASE/docking/submit/submit.csh
