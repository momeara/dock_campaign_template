
import sys
import optparse
import numpy as np
import pandas as pd
from scipy import sparse
import oddt
from oddt import fingerprints


VERSION = "0.0.1"
DESCRIPTION = "Compute receptor-ligand interaction fingerprints using the ODDT toolkit"
USAGE = """

   python compute_interaction_fingerprints.py --receptor receptor.pdb  --ligands ligands.mol2 --output interaction_fingerprints.tsv

"""



def pdb_to_oddt_receptor(pdb_fname, verbose=False):
    if verbose:
        print("Loading protein from '{}' in pdb format ... ".format(pdb_fname), end='')
    protein = next(oddt.toolkit.readfile('pdb', pdb_fname))
    protein.protein = True
    if verbose:
        print("{} residues".format(len(np.unique(protein.atom_dict['resid']))))
    return protein


def mol2_to_oddt_ligands(mol2_fname, verbose=False):
    if verbose:
        print("Loading ligands from '{}' in mol2 format ... ".format(mol2_fname), end='')

    ligands = [l for l in oddt.toolkit.readfile('mol2', mol2_fname)]

    if verbose:
        print("{} ligands".format(len(ligands)))
    return ligands

def compute_interaction_fingerprints(receptor, ligands, verbose=True):
    """ return unit8 matrix of interaction counts with dimensions (ligand, res_id, res_num, res_type, interaction_type, count)    
    residue indicies are over
       np.unique(receptor.atom_dict['resid'])
    Interaction types are:
    - (Column 0) hydrophobic contacts
    - (Column 1) aromatic face to face
    - (Column 2) aromatic edge to face
    - (Column 3) hydrogen bond (receptor as hydrogen bond donor)
    - (Column 4) hydrogen bond (receptor as hydrogen bond acceptor)
    - (Column 5) salt bridges (receptor positively charged)
    - (Column 6) salt bridges (receptor negatively charged)
    - (Column 7) salt bridges (ionic bond with metal ion)
    See https://oddt.readthedocs.io/en/latest/_modules/oddt/fingerprints.html?highlight=InteractionFingerprint
    for details
    """
    resids = np.unique(receptor.atom_dict['resid'])
    if verbose:
        print("Computing interaction fingerprints against {} residues".format(len(resids)))

    ifps = []
    for i, ligand in enumerate(ligands):
        ligand_id = ligand.title.split()[0]  # assume in a format like ' ZINC000082138702      none'
        ifp = oddt.fingerprints.InteractionFingerprint(ligand, receptor, strict=True).reshape(len(resids), 8)
        z = sparse.coo_matrix(ifp)
        ifps.append(pd.DataFrame(dict(
            ligand_id=[ligand_id]*z.data.shape[0],
            res_id=z.row,
            res_num=[receptor.res_dict[res_id][1] for res_id in z.row],
            res_type=[receptor.res_dict[res_id][2] for res_id in z.row],
            interaction_type=z.col,
            count=z.data)))
    ifps = pd.concat(ifps)
    return ifps


def main(argv):
    parser = optparse.OptionParser(version=VERSION, description=DESCRIPTION, usage=USAGE)
    parser.add_option(
        "--receptor", type="string", action="store", dest="receptor_pdb_fname", default="receptor.pdb",
        help="Receptor structure in PDB file format")
    parser.add_option(
        "--ligands", type="string", action="store", dest="ligands_mol2_fname", default="poses.mol2",
        help="Input .sph file, generated e.g. by sphgen")
    parser.add_option(
        "-o", "--output", type="string", action="store", dest="output_tsv_fname", default="interaction_fingerprints.tsv",
        help="Output .tsv file with ligand_id, residue, interaction_type, and count from oddt.InteractionFingerprint")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False, help="Verbose logging info")
    options, args = parser.parse_args()

    receptor = pdb_to_oddt_receptor(options.receptor_pdb_fname, verbose=options.verbose)
    ligands = mol2_to_oddt_ligands(options.ligands_mol2_fname, verbose=options.verbose)
    interaction_fingerprints = compute_interaction_fingerprints(receptor, ligands, verbose=True)

    if options.verbose:
        print("Writing interaction fingerprints to '{}'".format(options.output_tsv_fname))
    interaction_fingerprints.to_csv(options.output_tsv_fname, sep='\t', index=False)


if __name__ == '__main__':
    main(sys.argv)
