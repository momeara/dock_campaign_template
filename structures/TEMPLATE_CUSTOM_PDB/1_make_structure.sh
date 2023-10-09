#!/bin/sh

# This template downloads a structure file from the protein databank
# and splits it into the receptor (rec.pdb) and the reference ligand (xtal-lig.pdb)
#
# The reference ligand is used for sampling. The atoms of a candidate ligand
# are matched to the atoms of the reference ligand. Alternatively, the binding-site
# can be flooded with generated spehres e.g. "sph-gen".

# fill in 
PDB_CODE=
RECEPTOR_CHAIN=
LIGAND_CHAIN=
LIGAND_RESID=

wget https://files.rcsb.org/download/${PDB_CODE}.pdb
mv ${PDB_CODE}.pdb raw.pdb

grep "^ATOM.................${RECEPTOR_CHAIN}" raw.pdb > rec.pdb
grep "^HETATM...........${LIGAND_RESID} ${LIGAND_CHAIN}" raw.pdb > xtal-lig.pdb


echo "N atoms in rec.pdb: $(wc -l < rec.pdb)"
echo "N atoms in xtal-lig.pdb: $(wc -l < xtal-lig.pdb)"
