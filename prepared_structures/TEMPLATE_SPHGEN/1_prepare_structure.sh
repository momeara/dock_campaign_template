#!/bin/bash

#structure folder 'structures/<structure_id>'
STRUCTURE=

source ../../scripts/dock_clean.sh

echo 'Preparing receptor and xtal-lig ...'
cp ../../structures/${STRUCTURE}/rec.pdb rec.pdb
cp ../../structures/${STRUCTURE}/xtal-lig.pdb xtal-lig.pdb

source ../../scripts/dock_blastermaster_standard.sh

pushd custom
cp ../working/rec.ms .
$DOCKBASE/proteins/sphgen/bin/sphgen -i INSPH -o OUTSPH
# edit custom/all_spheres.sph.pdb --> custom/binding_site.sph.pdb
$DOCKBASE/proteins/showsphere/doshowsph.csh all_spheres.sph 0 all_spheres.sph.pdb 
# look up original spheres in all_spheres.sph to get radii correct
$DOCKBASE/proteins/pdbtosph/bin/pdbtosph binding_site.sph.pdb binding_site.sph
python ../../scripts/sph_to_pdb.py --input binding_site2.sph --output binding_site2.sph.pdb
python ../../scripts/copy_sphere_radii.py --input binding_site.sph --lookup all_spheres.sph --output binding_site2.sph
popd


cp custom/binding_site2.sph working/matching_spheres.sph
cp custom/binding_site2.sph working/all_spheres.sph
cp custom/binding_site2.sph working/lowdielectric.sph
cp custom/binding_site.sph.pdb xtal-lig.pdb
cp custom/binding_site2.sph working/xtal-lig.match.sph



source ../../scripts/dock_visualize_setup.sh
