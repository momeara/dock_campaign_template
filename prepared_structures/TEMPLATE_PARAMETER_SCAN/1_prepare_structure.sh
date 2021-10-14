#!/bin/bash

#prepared structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../<structure_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

python \
  ~rstein/zzz.scripts/DOCK_prep_scripts/new_0001_generate_ES_LD_generation.py \
  -p ${PREPARED_STRUCTURE}


echo 'Preparing receptor and xtal-lig ...'
cp ${PREPARED_STRUCTURE}/rec.pdb rec.pdb
cp ${PREPARED_STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ${DOCK_TEMPALTE}/scripts/dock_blastermaster_standard.sh
