#!/bin/bash

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "Please set the \${DOCK_TEMPLATE} environment variable."
    echo "Usually you would do this by"
    echo ""
    echo "  cd <campaign_root>"
    echo "  source setup_dock_environment.sh"
    echo ""
    exit 1
fi


if [ ! -d dockfiles ]
then
    echo "ERROR: the directory 'dockfiles' doesn't exist"
    echo "ERROR: Usually this means that you need to run blastermaster like"
    echo "ERROR:"
    echo "ERROR: cd prepared_structures/<structure_id>"
    echo "ERROR: bash 1_prepare_structure.py"
    exit 1
fi


pushd dockfiles
python ${DOCK_TEMPLATE}/scripts/create_VDW_DX.py
python ${DOCK_TEMPLATE}/scripts/phi_to_dx.py trim.electrostatics.phi trim.electrostatics.dx
python ${DOCK_TEMPLATE}/scripts/create_LigDeSolv_DX.py
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



