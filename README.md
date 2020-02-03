# Dock Campaign Template
An opinionated template for a Dock based virtual screening campaign

Dock involves running a bunch of fortran wrapped in python wrapped in
shell scripts. This template setups a standard way to organize the
data and common workflows.

For each call to a script in `scripts/`, I recommand reading through it
to make sure you understand what it is doing.

All files/foldes with date codes indicate that once the analysis is
done they are immutable, and can be referenced externally. To keep
sortable I like to use the format YYYYMMDD.

# Getting started

1. Clone the template to begin a campaign

```shell
git clone git@github.com:momeara/dock_campaign_template.git <project_name>
cd project_name
```

2. Initialize the environment. Currently this is setup up for paths on the bkslab cluster, so modify for your environment.

```shell
source 0_setup_dock_environment.sh
```

3. Collect structures from the pdb (copy this into `structures/1_get_structures.sh) and then run from `structures/`:

```shell    
pushd structures
source ../scripts/fetch_pdb_chain.sh <pdb_code> <chain_id>
# writes  <pdb_code>_<chain_code>.pdb
# if there is a ligand, split it into a separate file e.g. <pdb_code>_<chain_code>_<lig_id>.pdb
popd
```

4. Prepare the ligand database. For example from a list of smiles

```shell
pushd databases
cp -r TEMPLATE_STANDARD <database_name>_<date_code>
cd <database_name>_<date_code>
# write `substances.sdi` with columns <smiles> <substance_id>
source 1_make_database.sh
popd
```

5. Prepare and run a dock. Note the blastermaster and submit scripts
   called from `1_run.sh` submit jobs to the cluster #they must finish
   before the next steps can be executed

```shell
pushd docking_runs
cp -r TEMPLATE_STANDARD <run_id>_<date_code>
cd <run_id>_<date_code>
# edit 1_run.sh setting STRUCTURE_FNAME, XTAL_LIG_FNAME, DATABASE_NAME
source 1_run.sh
```    

6. Either create a new run or copy and modify an existing
   run. Depending on what was changed, look in dock_clean to reset.

