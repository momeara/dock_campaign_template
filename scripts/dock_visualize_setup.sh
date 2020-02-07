#!/bin/bash



pushd dockfiles
python ../../../scripts/create_VDW_DX.py
python ../../../scripts/phi_to_dx.py trim.electrostatics.phi trim.electrostatics.dx
python ../../../scripts/create_LigDeSolv_DX.py
popd

echo "generated the following grids:" 
echo "  dockfiles/ligdesolv.dx"
echo "  dockfiles/trim.electrostatics.dx"
echo "  dockfiles/vdw.dx"
echo "  dockfiles/vdw_energies_attractive.dx"
echo "  dockfiles/vdw_energies_repulsive.dx"
echo ""
echo "Visualize by opening them in e.g. pymol"
echo "For more info see: /mnt/nfs/home/jklyu/zzz.script/pymol_movie"



