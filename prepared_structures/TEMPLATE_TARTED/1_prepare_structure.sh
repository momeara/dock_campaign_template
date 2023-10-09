#!/bin/bash

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi

#structure folder 'structures/<structure_id>'
STRUCTURE=$(readlink -f ../../structures/<structure_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ${STRUCTURE}/rec.pdb rec.pdb
cp ${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_standard.sh

# save the standard blastermaster setup and create a new working for the tarted setup
mv working working_standard
mkdir working
cp working_standard/rec.crg.pdb working/


# instructions for taring residues
#  http://wiki.docking.org/index.php/Preparing_the_protein#Tarting_the_protein
#  http://wiki.docking.org/index.php/DOCK_3.7_tart
#    last updated June 2018 by Reed

cp $DOCKBASE/proteins/defaults/prot.table.ambcrg.ambH .
cp $DOCKBASE/proteins/defaults/amb.crg.oxt .

echo "Tarting the carbonyl oxygen of F305 to be more polar"

# Re-name residues to be tarted
sed -i "s/PHE A 305/PHX A 305/g" working/rec.crg.pdb

# create new residue params for the tarted residues
grep "PHE" prot.table.ambcrg.ambH | sed "s/PHE/PHX/g" >> prot.table.ambcrg.ambH
sed -i "s/ O     PHX       -0.500 11/ O     PHX       -0.900 11/g" prot.table.ambcrg.ambH
sed -i "s/ H     PHX        0.248  6/ H     PHX        0.648  6/g" prot.table.ambcrg.ambH

grep "phe" amb.crg.oxt | sed "s/phe/phx/g" >> amb.crg.oxt
sed -i "s/O     phx       -0.500/O     phx       -0.900/g" amb.crg.oxt
sed -i "s/H     phx        0.248/H     phx        0.648/g" amb.crg.oxt


source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_tarted.sh

