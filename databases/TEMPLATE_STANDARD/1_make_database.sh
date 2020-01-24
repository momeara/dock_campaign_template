#!/bin/sh

# This makes a database for a small set of compounds given as smiles


# populate substances.smi having columns <smiles> <substance_id>
SUBSTANCES_FNAME=substances.smi

time $DOCKBASE/ligand/generate/build_smiles_ligand.sh $SUBSTANCES_FNAME
echo "$(pwd)/$(basename $SUBSTANCES_FNAME .smi).db2.gz" > "database.sdi"
