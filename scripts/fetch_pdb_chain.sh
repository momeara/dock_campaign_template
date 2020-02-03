#!/bin/sh


PDB_CODE=$1
CHAIN_CODE=$2

wget https://files.rcsb.org/download/${PDB_CODE}.pdb
grep "^ATOM.................${CHAIN_CODE}" ${PDB_CODE}.pdb > ${PDB_CODE}_${CHAIN_CODE}.pdb

grep "^HETAM................${CHAIN_CODE}" ${PDB_CODE}.pdb >> ${PDB_CODE}_${CHAIN_CODE}.pdb
