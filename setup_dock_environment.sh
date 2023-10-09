#!/bin/bash

# run this by
#
#    cd <dock_campaign>
#    source setup_dock_environment.sh
#


# supported cluster types:
# LOCAL, SGE, SLURM
export CLUSTER_TYPE=

# use these options for SLURM clusters
#export SLURM_ACCOUNT=
#export SLURM_MAIL_USER=
#export SLURM_MAIL_TYPE=BEGIN,END
#export SLURM_PARTITION=standard
#export SLURM_MEM=
#export SLURM_TIME=

export SCRATCH_DIR=
export DOCK_TEMPLATE=${HOME}/opt/dock_campaign_template

export DOCKBASE=${HOME}/turbo/opt/DOCK37
# the DOCKBASE folder should contain files and folders that look like this:
# analysis, bin, common, docking, install, ligand protein, files.py, util.py, __init__.py


export PATH="${PATH}:${DOCKBASE}/bin"
#export PATH="${PATH}:${DOCKBASE}/bin:${DOCK_TEMPLATE}/scripts"

export OMEGA_ENERGY_WINDOW=12
export OMEGA_MAX_CONFS=600

# activate conda env for docking 
conda activate docking

