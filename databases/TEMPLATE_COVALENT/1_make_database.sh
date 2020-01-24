#!/bin/bash


SUBSTANCES_FNAME=substances.smi

####
# Edit compounds to add [SiH3] for attachment point
# substances.smi --> substances_covalent.smi
####

SUBSTANCES_COVALENT_FNAME=substances_covalent.smi


# get names of substances
SUBSTANCES=$(cut -d' ' -f2 $SUBSTANCES_FNAME)
SUBSTANCES_COVALENT=$(cut -d' ' -f2 $SUBSTANCES_COVALENT_FNAME)

# clean working directory
for substance in $SUBSTANCES; do rm -rf $substance; done
rm -rf $(basename $SUBSTANCES_FNAME .smi).db2.gz
rm -rf $(basename $SUBSTANCES_FNAME .smi)-swap.db2.gz

for substance in $SUBSTANCES_COVALENT; do rm -rf $substance; done
rm -rf $(basename $SUBSTANCES_COVALENT_FNAME .smi).db2.gz
rm -rf $(basename $SUBSTANCES_COVALENT_FNAME .smi)-swap.db2.gz

#generate vanilla ligand database
#time $DOCKBASE/ligand/generate/build_smiles_ligand.sh $SUBSTANCES_FNAME

#generate covalent ligand database
time $DOCKBASE/ligand/generate/build_smiles_ligand.sh $SUBSTANCES_COVALENT_FNAME --covalent

echo "$(pwd)/$(basename $SUBSTANCES_COVALENT_FNAME .smi).db2.gz" > "database.sdi"

