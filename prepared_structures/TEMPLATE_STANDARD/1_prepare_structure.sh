#!/bin/bash

#structure folder 'structures/<structure_id>'
STRUCTURE=

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ../../structures/${STRUCTURE}/rec.pdb rec.pdb
cp ../../structures/${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ../../scripts/dock_blastermaster_standard.sh
