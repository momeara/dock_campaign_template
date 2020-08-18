#!/bin/sh

# fill in 
PDB_CODE=
RECEPTOR_CHAIN=
LIGAND_CHAIN=
LIGAND_RESID=

wget https://files.rcsb.org/download/${PDB_CODE}.pdb
mv ${PDB_CODE} raw.pdb

grep "^ATOM.................${RECEPTOR_CHAIN}" raw.pdb > rec.pdb
grep "^HETATM...........${LIGAND_RESID} ${LIGAND_CHAIN}" raw.pdb > xtal-lig.pdb

