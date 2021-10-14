#!/bin/bash

# Generate spheres for a receptor if there is no x-ray ligand


# path to working direcotry genated by blastermaster
WORKING=$1

if [ ! -f ${WORKING} ]
then
  echo "ERROR: Unable to read given working directory ${WORKING}"
  echo "ERROR: To generate a working directory, run 'source ${DOCKING_TEMPLATE}/scripts/dock_blastermaster_*.sh' in the prepared_structure/<structure_id>_<date_code> directory" 
  exit 1
fi

if [ ! -f ${WORKING}/rec.ms ]
then
  echo "ERROR: Unable to read ${WORKING}/rec.ms"
  echo "ERROR: To generate a working directory, run 'source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_*.sh' in the prepared_structure/<structure_id>_<date_code> directory"
  exit 1
fi

if [ ! -f ${WORKING}/INSPH ]
then
  echo "ERROR: Unable to read ${WORKING}/INSPH"
  echo "ERROR: To generate a working directory, run 'source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_*.sh' in the prepared_structure/<structure_id>_<date_code> directory"
  exit 1
fi

$DOCKBASE/proteins/sphgen/bin/sphgen -i INSPH -o OUTSPH
$DOCKBASE/proteins/showsphere/doshowsph.csh all_spheres.sph 0 all_spheres.sph.pdb 

echo "Edit all_spheres.sph.pdb to have 40-60 spheres"
echo " ligand rigid fragments are aligned to clusters of spheres"
echo " so think of them as points where you at least want some ligand to be present"
echo ""
echo "Next run source ${DOCK_TEMPLATE}/scripts/dock_sphgen_custom.sh"
