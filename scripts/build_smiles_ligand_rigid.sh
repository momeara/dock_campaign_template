#!/bin/bash
#take mol2 split it into individual files for each molecule and call mol2db2.py on each
#
#  Usage:
#    $DOCKBASE/ligand/generate/build_smiles_ligand.sh <LIGAND>.smi
#    path/to/build_smiles_rigid.sh [--covalent] <LIGAND>/<PROTOMER_DIR> <LIGAND_RIGID>
#
#  output:
#    <LIGAND_RIGID>/        # fold containing .mol2 and .db2.gz files for each ligand
#    <LIGAND_RIGID>.db2.gz  # dock database with separate heirarchy for each conformer
#
set -e


if [ "${1}" == "--covalent" ]; then
  echo "Setting Covalent mode"
  COVALENT=${1}
  shift
else
  COVALENT=""
fi

PROTDIR=$1

MOL2_FNAMES=$PROTDIR/output.*.db2in.mol2
NAMEMOL2=$PROTDIR/name.txt
SOLV=$PROTDIR/output.solv

DB_RIGID_NAME=$2

mkdir -pv $DB_RIGID_NAME
for mol2_fname in $MOL2_FNAMES
do
  echo "splitting molecules in ${mol2_fname} into separate .mol2 files as ${DB_RIGID_NAME}/<row_start>.mol2"
  awk "/MOLECULE/{filename=\"${DB_RIGID_NAME}/\"NR\".mol2\"}; {print >filename}" ${mol2_fname}
done

echo "Generating a database for each molecule"
for onemol in `\ls $DB_RIGID_NAME/*.mol2`
do
    CONF=$(basename $onemol .mol2)
    NAME=$(cut $PROTDIR/name.txt -d' ' -f 3)
    REMAINDER=$(cut $PROTDIR/name.txt -d' ' -f 4-6)
    echo "name.txt 1 ${NAME}.$CONF $REMAINDER" > $DB_RIGID_NAME/name.txt

    $DOCKBASE/ligand/mol2db2/mol2db2.py \
       --verbose \
       ${COVALENT} \
       --mol2=$onemol \
       --namemol2=$DB_RIGID_NAME/name.txt \
       --solv=$SOLV \
       --db=$onemol.db2.gz 

done
zcat $DB_RIGID_NAME/*.db2.gz > $DB_RIGID_NAME-swap.db2
mv -v $DB_RIGID_NAME-swap.db2 $DB_RIGID_NAME.db2
gzip -9 $DB_RIGID_NAME.db2
