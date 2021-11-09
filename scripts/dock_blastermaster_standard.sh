#!/bin/bash




echo "Running blastermaster standard..."

[ -d "working" ] || mkdir working


if [ ${CLUSTER_TYPE} = "LOCAL" ]; then
    echo "Using cluster type LOCAL"
    $DOCKBASE/proteins/blastermaster/blastermaster.py \
      --useThinSphEleflag \
      --useThinSphLdsflag \
      -v
    
elif [ ${CLUSTER_TYPE} = "SGE" ]; then
    echo "Using clsuter type SGE"
qsub <<EOF 
#$ -S /bin/csh
#$ -cwd
#$ -q all.q
#$ -o working/blastermaster.out
#$ -e working/blastermaster.err

setenv DOCKBASE ${DOCKBASE}
setenv PATH "${DOCKBASE}/bin:${PATH}"

$DOCKBASE/proteins/blastermaster/blastermaster.py \
  --useThinSphEleflag \
  --useThinSphLdsflag \
  -v
EOF
echo "Submitting to the SGE cluster, this should take ~30 minutes"
echo "Check with 'qstat'"

elif [ ${CLUSTER_TYPE} = "SLURM" ]; then
    echo "Using cluster type SLURM"
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
  -v
EOF

echo "Submitting to the SLURM cluster, this should take ~30 minutes"
echo "Check with 'squeue | grep ${SLURM_ACCOUNT}'"

else
    echo "Unrecognized CLUSTER_TYPE ${CLUSTER_TYPE}"
    exit 1
fi
