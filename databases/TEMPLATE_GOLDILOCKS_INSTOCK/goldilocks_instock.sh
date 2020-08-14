#!/bin/bash


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
