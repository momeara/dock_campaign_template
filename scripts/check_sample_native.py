
import os
import rdkit
from rdkit.Chem.rdmolfiles import MolFromPDBFile
from rdkit.Chem.rdmolfiles import MolFromMol2Block
from rdkit.Chem.AllChem import GetBestRMS

# have we sampled the native conformation?


# adapted from: https://chem-workflows.com/articles/2019/07/18/building-a-multi-molecule-mol2-reader-for-rdkit/
def Mol2MolSupplier(file,sanitize=True):
    m = None
    line_index=0
    start_line=None
    with open(file, 'r') as f:
        line =f.readline()
        line_index += 1
        # skip down to the beginning of the first molecule
        while not line.startswith("@<TRIPOS>MOLECULE") and not f.tell() == os.fstat(f.fileno()).st_size:
            line = f.readline()
            line_index += 1
        while not f.tell() == os.fstat(f.fileno()).st_size:
            if line.startswith("@<TRIPOS>MOLECULE"):
                mol = []
                mol.append(line)
                start_line = line_index
                line = f.readline()
                line_index += 1
                while not line.startswith("@<TRIPOS>MOLECULE"):
                    mol.append(line)
                    line = f.readline()
                    line_index += 1
                    if f.tell() == os.fstat(f.fileno()).st_size:
                        mol.append(line)
                        break
                mol[-1] = mol[-1].rstrip() # removes blank line at file end
                block = ",".join(mol).replace(',','') + "\n"
                m=MolFromMol2Block(block,sanitize=sanitize)
            yield (start_line, m)


def check_sample_native(xtal_lig_pdb, sample_confs_mol2):
    xtal_lig = MolFromPDBFile(xtal_lig_pdb)
    xtal_lig.SetProp("_Name", 'xtal')
    rms_scores = []
    for start_line, sample_conf in Mol2MolSupplier(sample_confs_mol2, sanitize=False):
        rms_score = GetBestRMS(xtal_lig, sample_conf)
        print("start_line: {} rms: {}".format(start_line, rms_score))
        rms_scores.append((start_line, rms_score))
    return rms_score


