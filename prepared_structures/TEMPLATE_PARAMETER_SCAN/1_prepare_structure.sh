#!/bin/bash

#prepared structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=

source ../../scripts/dock_clean.sh

python \
  ~rstein/zzz.scripts/DOCK_prep_scripts/new_0001_generate_ES_LD_generation.py \
  -p ../${PREPARED_STRUCTURE}


echo 'Preparing receptor and xtal-lig ...'
cp ../../structures/${STRUCTURE}/rec.pdb rec.pdb
cp ../../structures/${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ../../scripts/dock_blastermaster_standard.sh
