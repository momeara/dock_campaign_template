#!/bin/bash


# http://wiki.docking.org/index.php/Visualize_docking_grids
# generates volumn files for the following energy eterms
#   ligdesolv.dx
#   trim.electrostatics.dx
#   vdw.dx
#   vdw_energies_attractive.dx
#   vdw_energies_repulsive.dx


pushd dockfiles
python ../../../scripts/create_VDW_DX.py
python ../../../scripts/phi_to_dx.py trim.electrostatics.phi trim.electrostatics.dx
python ../../../scripts/create_LigDeSolv_DX.py
popd


