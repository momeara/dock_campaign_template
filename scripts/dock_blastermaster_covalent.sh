#!/bin/bash

COVALENT_RESIDUE_NUMBER=$1
COVALENT_RESIDUE_NAME=$2
COVALENT_RESIDUE_ATOMS=$3

if [ ! -f rec.pdb ]; then
  echo "ERROR: Unable to run blastermaster because rec.pdb does not exist"
  echo "ERROR: copy from a prepared structure e.g. from ../../structures/<structure_id>/rec.pdb"
fi

ATTACHMENT_POINT=$(
  grep "${COVALENT_RESIDUE_ATOMS} \{0,3\}${COVALENT_RESIDUE_NAME}...${COVALENT_RESIDUE_NUMBER}" rec.pdb)

if [ -z "${ATTACHMENT_POINT}" ]; then
  echo "WARNING: The attachement point is not found in the receptor:"
  echo "WARNING:    residue number: ${COVALENT_RESIDUE_NUMBER}"
  echo "WARNING:    residue name:   ${COVALENT_RESIDUE_NAME}"
  echo "WARNING:    residue atoms:  ${COVALENT_RESIDUE_ATOMS}"
fi


[ -d "working" ] || mkdir working

echo "Running blastermaster covalent..."

if [ ${CLUSTER_TYPE} = "LOCAL" ]; then
    echo "Using cluster type LOCAL"

$DOCKBASE/proteins/blastermaster/blastermaster.py \
  --useThinSphEleflag \
  --useThinSphLdsflag \
  --covalentResNum ${COVALENT_RESIDUE_NUMBER} \
  --covalentResName ${COVALENT_RESIDUE_NAME} \
  --covalentResAtoms ${COVALENT_RESIDUE_ATOMS} \
  -v

elif [ ${CLUSTER_TYPE} = "SGE" ]; then
    echo "Using cluster type SGE"
qsub <<EOF
#$ -S /bin/csh
#$ -cwd
#$ -q all.q
#$ -o working/blastermaster_covalent.out
#$ -e working/blastermaster_covalent.err

setenv DOCKBASE ${DOCKBASE}
setenv PATH "${DOCKBASE}/bin:${PATH}"

$DOCKBASE/proteins/blastermaster/blastermaster.py \
  --useThinSphEleflag \
  --useThinSphLdsflag \
  --covalentResNum ${COVALENT_RESIDUE_NUMBER} \
  --covalentResName ${COVALENT_RESIDUE_NAME} \
  --covalentResAtoms ${COVALENT_RESIDUE_ATOMS} \
  -v
EOF

echo "Submitting to the SGE cluster, this should take ~30 minutes"
echo "Check with 'qstat'"

elif [ ${CLUSTER_TYPE} = "SLURM" ]; then
    echo "Using cluster type SLURM"
    read -r -d '' SBATCH_SCRIPT <<-EOF
	#!/bin/sh
	#SBATCH --job-name=blastermaster_covalent
	#SBATCH --mail-user=${SLURM_MAIL_USER}
	#SBATCH --mail-type=${SLURM_MAIL_TYPE}
	#SBATCH --account=${SLURM_ACCOUNT}
	#SBATCH --partition=${SLURM_PARTITION}
	#SBATCH --cpus-per-task=1
	#SBATCH --nodes=1
	#SBATCH --ntasks-per-node=1
	#SBATCH --mem-per-cpu=1000m
	#SBATCH --time=50:00
	#SBATCH --output=working/blastermaster_covalent.out
	#SBATCH --error=working/blastermaster_covalent.err

	export DOCKBASE=${DOCKBASE}
	export PATH="${DOCKBASE}/bin:${PATH}"

	${DOCKBASE}/proteins/blastermaster/blastermaster.py \
	  --useThinSphEleflag \
	  --useThinSphLdsflag \
	  --covalentResNum ${COVALENT_RESIDUE_NUMBER} \
	  --covalentResName ${COVALENT_RESIDUE_NAME} \
	  --covalentResAtoms ${COVALENT_RESIDUE_ATOMS} \
	  -v
	EOF

    SLURM_JOB_ID=$(sbatch --parsable <("${SBATCH_SCRIPT}") )

    echo "Submitting job ${SLURM_JOB_ID} to the SLURM cluster, this should take ~30 minutes"
    echo "Check with 'squeue | grep ${SLURM_JOB_ID}'"


else
    echo "Unrecognized CLUSTER_TYPE '${CLUSTER_TYPE}'"
    exit 1
fi
