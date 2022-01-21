#!/bin/bash

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "ERROR: The \${DOCK_TEMPLATE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi



#structure folder 'structures/<structure_id>'
STRUCTURE=$(readlink -f ../../structure/<structure_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ${STRUCTURE}/rec.pdb rec.pdb
cp ${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_standard.sh

pushd custom
cp ../working/rec.ms .
$DOCKBASE/proteins/sphgen/bin/sphgen -i INSPH -o OUTSPH
# edit custom/all_spheres.sph.pdb --> custom/binding_site.sph.pdb
$DOCKBASE/proteins/showsphere/doshowsph.csh all_spheres.sph 0 all_spheres.sph.pdb 
# look up original spheres in all_spheres.sph to get radii correct
$DOCKBASE/proteins/pdbtosph/bin/pdbtosph binding_site.sph.pdb binding_site.sph
python ${DOCK_TEMPLATE}/scripts/sph_to_pdb.py \
       --input binding_site2.sph \
       --output binding_site2.sph.pdb
python ${DOCK_TEMPLATE}/scripts/copy_sphere_radii.py \
       --input binding_site.sph \
       --lookup all_spheres.sph \
       --output binding_site2.sph
popd


cp custom/binding_site2.sph working/matching_spheres.sph
cp custom/binding_site2.sph working/all_spheres.sph
cp custom/binding_site2.sph working/lowdielectric.sph
cp custom/binding_site.sph.pdb xtal-lig.pdb
cp custom/binding_site2.sph working/xtal-lig.match.sph



source ${DOCK_TEMPLATE}/scripts/dock_visualize_setup.sh
