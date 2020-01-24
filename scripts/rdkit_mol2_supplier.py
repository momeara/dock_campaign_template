
import os
import re
from rdkit.Chem.rdmolfiles import MolFromMol2Block

# Read in a mol2 file with meta property lines at the top
# as would be found in the poses.mol2 at the end of a docking run:
 
# ##########                 Name:     12878478.0.94645
# ##########          Protonation:                 none
# ##########               SMILES:   Cc2cccc(C[C@H](NC(=O)c1cc(C(C)(C)C)nn1C)C(=O)NCC(=N)[SiH3])c2

# These values are stored in the rdkit_mol GetProp/SetProp data struct as strings


# adapted from:
# https://chem-workflows.com/articles/2019/07/18/building-a-multi-molecule-mol2-reader-for-rdkit/
def Mol2MolSupplier(mol2_fname, sanitize=True):

    property_re = re.compile(r"##########\s+([^:]+):\s+(.+)\n")

    with open(mol2_fname, 'r') as mol2_file:
        meta_properties = []
        molecule_lines = []

        def finalize_molecule():
            molecule_block = "".join(molecule_lines)
            rdkit_molecule = MolFromMol2Block(molecule_block, sanitize=sanitize)
            for key, value in meta_properties:
                rdkit_molecule.SetProp(key, value)
            return rdkit_molecule

        while not mol2_file.tell() == os.fstat(mol2_file.fileno()).st_size:
            line = mol2_file.readline()
            property_match = property_re.search(line)
            if property_match:
                # each molecule is preceeded by lines of meta properties
                # finalize previous molecule and reset
                if molecule_lines != []:
                    yield finalize_molecule()
                    meta_properties = []
                    molecule_lines = []

                meta_properties.append( (property_match.group(1), property_match.group(2)) )
            else:
                if line != '\n':
                    molecule_lines.append(line)

        # finalize last molecule
        if molecule_lines != []:
            yield finalize_molecule()

    return
