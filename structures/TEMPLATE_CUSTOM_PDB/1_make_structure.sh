#!/bin/sh

PDB_CODE=  # put pdb code like '3HHA' here
PDB_CHAIN= # put PDB chain id like 'A' or multiple chains like '[AB]' here.

wget https://files.rcsb.org/download/${PDB_CODE}.pdb
mv ${PDB_CODE} raw.pdb
grep '^ATOM.................${PDB_CHAIN}' raw.pdb > structure.pdb

