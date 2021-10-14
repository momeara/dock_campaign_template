#!/bin/bash




echo "Running blastermaster standard..."

[ -d "working" ] || mkdir working


if [ ${CLUSTER_TYPE} = "LOCAL" ]; then

$DOCKBASE/proteins/blastermaster/blastermaster.py \
  --useThinSphEleflag \
  --useThinSphLdsflag \
  -v
    
elif [ ${CLUSTER_TYPE} = "SGE" ]; then
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
  -v
EOF
echo "Submitting to the SGE cluster, this should take ~30 minutes"
echo "Check with 'qstat'"

elif [ ${CLUSTER_TYPE} = "SLURM" ]; then

sbatch <<EOF
#!/bin/sh
#SBATCH --job-name=blastermaster_standard
#SBATCH --mail-user=${SLURM_MAIL_USER}
#SBATCH --mail-type=${SLURM_MAIL_TYPE}
#SBATCH --account=${SLURM_ACCOUNT}
#SBATCH --partition=${SLURM_PARTITION}
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1000m 
#SBATCH --time=50:00
#SBATCH --output=working/blastermaster.out
#SBATCH --error=working/blastermaster.err

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
echo "Submitting to the SLURM cluster, this should take ~30 minutes"
echo "Check with 'squeue | grep ${SLURM_ACCOUNT'"

else
    echo "Unrecognized CLUSTER_TYPE ${CLUSTER_TYPE}"
    exit 1
fi
