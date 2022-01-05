#!/bin/bash

#prepared structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../<structure_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

python \
  ~rstein/zzz.scripts/DOCK_prep_scripts/new_0001_generate_ES_LD_generation.py \
  -p ${PREPARED_STRUCTURE}

python \
  ~rstein/zzz.scripts/DOCK_prep_scripts/new_0002_combine_es_ld_grids_into_combos.py \
  -p ${PREPARED_STRUCTURE}

# copy the INDOCK file to the dockfiles directory
for params in *; do
    echo ${params}
    cp ${params}/INDOCK ${params}/dockfiles/
done

echo 'Preparing receptor and xtal-lig ...'
cp ${PREPARED_STRUCTURE}/rec.pdb rec.pdb
cp ${PREPARED_STRUCTURE}/xtal-lig.pdb xtal-lig.pdb
