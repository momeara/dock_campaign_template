#!/bin/bash

if [ -z ${ZINC3D_PATH+x} ]; then
    echo "ERROR: The \${ZINC3D_PATH} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
fi




# Prepare goldilocks Databases
#   Navigate to http://zinc15.docking.org/tranches/home
#   select 3D
#   select In-stock
#   select goldilocks
#   download dialog
#       select DB-index
#       set prefix ${ZINC3D_PATH}
#       download
#   save to database.sdi

# if you are running this with a copy of zinc handy
ls ${ZINC3D_PATH}/[CDE][DEF]/[A-E][ABC][RM]?/??[A-E][ABC][RM]?.???.db2.gz > database.sdi
