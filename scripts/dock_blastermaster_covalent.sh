#!/bin/bash

COVALENT_RESIDUE_NUMBER=$1
COVALENT_RESIDUE_NAME=$2
COVALENT_RESIDUE_ATOMS=$3


if [ ! -f rec.pdb ]
then
  echo "ERROR: Unable to run blastermaster because rec.pdb does not exist"
  echo "ERROR: copy from a prepared structure e.g. from ../../structures/<structure_id>/rec.pdb"
fi

ATTACHMENT_POINT=$(
  grep "${COVALENT_RESIDUE_ATOMS} \{0,3\}${COVALENT_RESIDUE_NAME}...${COVALENT_RESIDUE_NUMBER}" rec.pdb)

if [ -z "${ATTACHMENT_POINT}" ]
then
  echo "WARNING: The attachement point is not found in the receptor:"
  echo "WARNING:    residue number: ${COVALENT_RESIDUE_NUMBER}"
  echo "WARNING:    residue name:   ${COVALENT_RESIDUE_NAME}"
  echo "WARNING:    residue atoms:  ${COVALENT_RESIDUE_ATOMS}"
fi


echo "Running blastermaster covalent..."
echo "Submitting to the cluster, this should take ~30 minutes"
echo "Check with 'qstat'"

[ -d "working" ] || mkdir working

qsub <<EOF 
#$ -S /bin/csh
#$ -cwd
#$ -q all.q
#$ -o working/blastermaster.out
#$ -e working/blastermaster.err

source /nfs/soft/dock/versions/dock37/DOCK-3.7-trunk/env.csh
setenv DOCKBASE /nfs/home/rstein/zzz.github/DOCK
setenv PATH "${DOCKBASE}/bin:${PATH}"

$DOCKBASE/proteins/blastermaster/blastermaster.py \
  --useThinSphEleflag \
  --useThinSphLdsflag \
  --covalentResNum ${COVALENT_RESIDUE_NUMBER} \
  --covalentResName ${COVALENT_RESIDUE_NAME} \
  --covalentResAtoms ${COVALENT_RESIDUE_ATOMS} \
  -v
EOF
