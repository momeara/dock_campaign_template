# Dock Campaign Template
An opinionated template for a Dock based virtual screening campaign

* Dock involves running a bunch of fortran wrapped in python wrapped
  in shell scripts. This template setups a standard way to organize
  the data and common workflows.

* For each call to a script in `scripts/`, I recommand reading through
  it to make sure you understand what it is doing.

* All files/folders with date codes indicate that once the analysis is
  done they are immutable, and can be referenced externally. To keep
  sortable I like to use the format YYYYMMDD.

* For scripts that must be run sequentially number them with leading 0s
  so they are sortable

# Getting started

0. Install DOCK (http://dock.compbio.ucsf.edu/)

1. Clone the template repo to somewhere you can reference. I like to put it in ~/opt/dock_campaign_template.git

```shell
cd ~/opt
git clone git@github.com:momeara/dock_campaign_template.git
```

2. Create a base directory for the project, e.g. for example for docking to KCNQ channels on the UMich Great Lakes cluster we may use ~/turbo/KCNQ/docking

```shell
cd ~/turbo/KCNQ
mkdir docking
cd docking


2. Initialize the environment. Currently this is setup up for paths on the bkslab cluster, so modify for your environment. This creates several directories.
```shell
source ~/opt/dock_campaign_template/scripts/initialize_dock_campaign.sh
```

3. Edit setup_dock_environment.sh for your environment. For example if you can submit jobs to a HPC cluster, fill in the cluster type and parameters

# Using the dock_campaign_tempalte

0. Setup the the dock environment
```shell
source setup_dock_environment.sh
```

1. Define some variables to make life easier. For a given docking run
you can mix-and-match (prepared) structures, databases and docking flags.

```shell
DATE_CODE=<YYYYMMDD>
STRUCTURE_ID=<pdb_id>_${DATE_CODE}
DATABASE_ID=project_ligands_${DATE_CODE}
DOCKING_FLAGS=''

STRUCTURE=$(readlink -f structures/${STRUCTURE_ID}_${DATE_CODE})
PREPARED_STRUCTURE=$(readlink -f structures/${STRUCTURE_ID}_${DATE_CODE})
DATABASE=$(readlink -f databases/${DATABASE_ID}_${DATE_CODE})
DOCKING_RUN=$(readlink -f docking_run/${STRUCTURE_ID}_${DATE_CODE},${DATABASE_ID}_${DATE_CODE},${DOCKING_FLAGS},${DATE_CODE})
```

2. Collect a structure and prepare it into a receptor (rec.pdb) and if available a reference ligand (xtal-lig.pdb)
```shell
cp -r ${DOCK_TEMPLATE}/structures/TEMPLATE_<type> ${STRUCTURE}
pushd ${STRUCTURE}
# edit and source 1_make_structure.sh
popd
```

2. Prepare the structure for docking e.g. by running some form of blastermaster.

```
cp -r ${DOCK_TEMPLATE}/prepared_structures/TEMPLATE_<type> ${PREPARED_STRUCTURE}
pushd ${PREPARED_STRUCTURE}
# edit and source 1_prepare_structure.sh
popd


3. Prepare the ligand database
```shell
cp -r ${DOCK_TEMPALTE}/databases/TEMPLATE_<type> ${DATABASE}
pushd ${DATABASE}
# edit and source 1_make_database.sh
popd
```

6. Either create a new run or copy and modify an existing
   run. Depending on what was changed, look in dock_clean to reset.
```shell
cp -r ${DOCK_TEMPLATE}/docking_runs/TEMPLATE_<type> ${DOCKING_RUN}
pushd ${DOCKING_RUN}
# edit and source 1_run.sh
popd
```    

