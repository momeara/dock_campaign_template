
from openeye.oechem import *
import os, string, sys


def transform(smirks, mol):
    
    
def main(argv):

    qmol = oechem.OEQMol()
    if not oechem.OEParseSmirks(qmol, options.smirks):
        oechem.OEThrow.Fatal("Unable to parse SMIRKS: %s" % options.smirks)
    
    umr = oechem.OEUniMolecularRxn()
    if not umr.Init(qmol):
        oechem.OEThrow.Fatal("Failed to initialize reaction with %s SMIRKS" % options.smirks)
    umr.SetClearCoordinates(True)

    
    

covalent_mol = OEGraphMol()
OEParseSmiles(covalent_mol)


OEUniMolecularRxn(
