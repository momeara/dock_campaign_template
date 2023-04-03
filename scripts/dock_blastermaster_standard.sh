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



echo "Running blastermaster standard..."

[ -d "working" ] || mkdir working

if [ -z ${CLUSTER_TYPE+x} ]; then
    echo "ERROR: The \${CLUSTER_TYPE} variable is not set"
    echo "ERROR: Please run 'source setup_dock_environment.sh' in the project root directory"
    
elif [ ${CLUSTER_TYPE} = "LOCAL" ]; then
    echo "Using cluster type LOCAL"
    $DOCKBASE/proteins/blastermaster/blastermaster.py \
      --useThinSphEleflag \
      --useThinSphLdsflag \
      -v
    mv INDOCK dockfiles/
    source ${DOCK_TEMPLATE}/scripts/dock_visualize_setup.sh

elif [ ${CLUSTER_TYPE} = "SGE" ]; then
    echo "Using clsuter type SGE"
    qsub <<- EOF
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

        mv INDOCK dockfiles/
        source ${DOCK_TEMPLATE}/scripts/dock_visualize_setup.sh
	EOF
echo "Submitting to the SGE cluster, this should take ~30 minutes"
echo "Check with 'qstat'"

elif [ ${CLUSTER_TYPE} = "SLURM" ]; then
    echo "Using cluster type SLURM"
    cat > blastermaster.sbatch <<-EOF
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

	mv INDOCK dockfiles/
        source ${DOCK_TEMPLATE}/scripts/dock_visualize_setup.sh
	EOF
    SLURM_JOB_ID=$(sbatch --parsable blastermaster.sbatch)

    echo "Submitting job ${SLURM_JOB_ID} the SLURM cluster, this should take ~30 minutes"
    echo "Check with 'squeue | grep ${SLURM_JOB_ID}'"

else
    echo "Unrecognized CLUSTER_TYPE ${CLUSTER_TYPE}"
fi
