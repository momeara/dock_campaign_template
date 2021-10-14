#!/bin/bash

DATABASE=$1
DATABASE_SDI=$DATABASE/database.sdi

if [ ! -f INDOCK ]
then
  echo "ERROR: Unable to setup library becuase INDOCK doesn't exist"
  echo "ERROR: Run blastermaster first e.g. by"
  echo "   pushd ${DATABASE}"
  echo "   source ${DOCK_TEMPLATE}/scripts/dock_blastermaster_standard.sh"
  echo "   popd"
  exit 1
fi

if [ ! -f ${DATABASE_SDI} ]
then
  echo "ERROR: Unable to locate database sdi at ${DATABASE_SDI}"
  echo ""
  echo "Usage:"
  echo ""
  echo "  dock_setup_library.sh <database_id>"
  echo ""
  echo "where <database_id>/database.sdi is the docking library"
  exit 1
fi

echo "Preparing database from ${DATABASE_SDI} ..."


time $DOCKBASE/docking/setup/setup_db2_zinc15_file_number.py \
     ./ ligand ${DATABASE_SDI}  500 count

# make a backup copy of the dirlist incase failed ones need to be resubmitted
cp dirlist dirlist_orig
