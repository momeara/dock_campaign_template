#!/bin/bash



time python $DOCKBASE/analysis/getposes_blazing_fast.py '' extract_all.sort.uniq.txt 500 poses.mol2

#time python $DOCKBASE/analysis/getposes_blazing_faster.py '' extract_all.sort.txt 5000 poses.mol2 test.mol2.gz
