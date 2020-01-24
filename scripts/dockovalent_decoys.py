#!/bin/python

VERSION = "0.1.0"
DESCRIPTION = """
Generate DUD-E like decoys for DOCKcovalent ligands
Search zinc for property matched decoys that contain the appropriate warhead
"""
USAGE = """

Usage:
    python dockovalent_decoys.py --ligands <substances.smi> --warhead <warhead_smarts> [--spec decoy_generation.in]

Output:
    <ligand_id>_property_matched_decoys.smi for each <ligand_id> in <substances.smi> file

Details:

    This is the format for the decoy_generation.in file

      CHARGE 0 2
      HBD 0 3
      HBA 0 4
      RB 1 5
      MWT 20 125
      LOGP 0.4 3.6
      Tanimoto YES 
      MINIMUM DECOYS PER LIGAND 20 
      DECOYS PER LIGAND 50
      MAXIMUM TC BETWEEN DECOYS 0.8

"""

def parse_spec_file(spec_fname):
    """
    # adapted from
    rstein/zzz.scripts/new_DUDE_SCRIPTS/generate_decoys.py

    This is the format of the input specification file
        
        CHARGE 0 2
        HBD 0 3
        HBA 0 4
        RB 1 5
        MWT 20 125
        LOGP 0.4 3.6
        Tanimoto YES 
        MINIMUM DECOYS PER LIGAND 20 
        DECOYS PER LIGAND 50
        MAXIMUM TC BETWEEN DECOYS 0.8
    """

    if not os.path.isfile(spec_fname):
        print("Decoy spec file {} does not exist".format(spec_fname))
        sys.exit()
    
    open_in = open(spec_fname, 'r')
    read_in = open_in.readlines()
    open_in.close()

    ### DEFAULTS FROM MYSINGER - these are used if property not specified
    range_dict = {"CHG_RANGES": [  0,   0,   0,   0,   0,   1,   2],
    "HBD_RANGES": [  0,   0,   1,   1,   2,   2,   3],
    "HBA_RANGES": [  0,   1,   2,   2,   3,   3,   4],
    "RB_RANGES": [  1,   2,   2,   3,   3,   4,   5],
    "MWT_RANGES": [ 20,  35,  50,  65,  80, 100, 125],
    "LOGP_RANGES": [0.4, 0.8, 1.2, 1.8, 2.4, 3.0, 3.6]}

    for line in read_in:
        splitline = line.strip().split()
        if len(splitline) == 3:
            prop_type = splitline[0]
            if prop_type.lower()[0] == "c":
                chg_low = int(splitline[1])
                chg_high = int(splitline[2])

                chg_range = make_seven(chg_low, chg_high, "CHG")
                range_dict["CHG_RANGES"] = chg_range

            elif prop_type.lower() == "hbd":
                hbd_low = int(splitline[1])
                hbd_high = int(splitline[2])

                hbd_range = make_seven(hbd_low, hbd_high, "HBD")
                range_dict["HBD_RANGES"] = hbd_range

            elif prop_type.lower() == "hba":
                hba_low = int(splitline[1])
                hba_high = int(splitline[2])

                hba_range = make_seven(hba_low, hba_high, "HBA")
                range_dict["HBA_RANGES"] = hba_range

            elif prop_type.lower() == "rb":
                rb_low = int(splitline[1])
                rb_high = int(splitline[2])

                rb_range = make_seven(rb_low, rb_high, "RB")
                range_dict["RB_RANGES"] = rb_range

            elif prop_type.lower()[0] == "m":
                mwt_low = float(splitline[1])
                mwt_high = float(splitline[2])

                mwt_range = make_seven(mwt_low, mwt_high, "MWT")
                range_dict["MWT_RANGES"] = mwt_range

            elif prop_type.lower()[0] == "l":
                logp_low = float(splitline[1])
                logp_high = float(splitline[2])

                logp_range = make_seven(logp_low, logp_high, "LOGP")
                range_dict["LOGP_RANGES"] = logp_range
            else:
                print("WARNING: Unrecognized line in {}: {}".format(spec_fname, line.strip()))

    print(range_dict)
    return(range_dict)

def parse_ligands(ligands_fname):
    if not os.path.isfile(ligands_fname):
        print("Ligands file {} does not exist".format(ligands_fname))
        sys.exit()

    lig_dict = {}
    with open(ligands_fname) as ligands_file:
        for line_number, line in enumerate(ligands_file):
            if len(line.strip().split()) == 2:
                ligand_id = line.strip().split()[1]
                smiles = line.strip().split()[0]
                lig_dict[ligand_id] = smiles
            else:
                print("WARNING: Unable to parse line {} in ligand file: '{}' should be of the form '<smiles> <ligand_id>'".format(line_number, line.strip()))
    return(lig_dict)

def calculate_ligand_properties(smiles, ligand_id):
    mol = C.MolFromSmiles(smiles)
    if len(str(mol)) == 0:
        print("WARNING: Unable to parse smiles {} for ligand {}".format(smiles, ligand_id))
        return(0, 0, 0, 0, 0, 0)
    else:
        mw = CD.CalcExactMolWt(mol)
        logp = C.Crippen.MolLogP(mol)
        rotB = D.NumRotatableBonds(mol)
        HBA = CD.CalcNumHBA(mol)
        HBD = CD.CalcNumHBD(mol)
        q = C.GetFormalCharge(mol)
        return(mw, logp, rotB, HBD, HBA, q)

def gather_candidate_decoys_zinc():

    command3 = 'curl "http://zinc15/protomers/subsets/usual.txt:smiles+zinc_id+mwt+logp+rb+hbd+hba+net_charge+prot_id+model_type_name" -F "mwt-between=%d %d" -F "logp-between=%f %f" -F "sort=no" -F "net_charge-between=%d %d" -F "count=%d"' % (mwt_low, mwt_high, logp_low, logp_high, int(chg_low), int(chg_high), query_num)

    g = os.popen(command3)

    for line in g:
        splitline = line.strip().split()
        if len(splitline) <= 6: continue

        dec_model_name = splitline[-1]
        if dec_model_name not in ['ref', 'mid']: continue

        dec_smiles = splitline[0]
        dec_zinc_id = splitline[1]
        dec_mwt = float(splitline[2])
        dec_logp = float(splitline[3])
        dec_rotB = int(splitline[4])
        dec_hbd = int(splitline[5])
        dec_hba = int(splitline[6])
        dec_q = float(splitline[7])
        dec_prot_id = int(splitline[8])

        boolliee = compare(mwt, logp, rotB, hbd, hba, q, dec_mwt, dec_logp, dec_rotB, dec_hbd, dec_hba, dec_q, i, prop_range_dict)
        if not boolliee: continue
        if dec_zinc_id in decoy_dict: continue

        decoy_count += 1
        decoy_dict[dec_zinc_id] = [dec_smiles, dec_mwt, dec_logp, dec_rotB, dec_hbd, dec_hba, dec_q, dec_prot_id]
        smiles_list.append(dec_smiles)
        compound_list.append(dec_zinc_id)
        print("DECOYS FOUND: ",decoy_count)



def generate_decoys_one_ligand(ligand_id, smiles, spec, ligands_fname):
    MWT_RANGES = prop_range_dict["MWT_RANGES"]
    LOGP_RANGES = prop_range_dict["LOGP_RANGES"]
    CHG_RANGES = prop_range_dict["CHG_RANGES"]

    mwt, logp, rotB, hbd, hba, q = calculate_ligand_properties(smiles)
    lig_list = [smiles, ligand_id, mwt, logp, rotB, hbd, hba, q]

    query_num = 1000
    decoy_count = 0
    decoy_dict = {}
    smiles_list = [] ### don't need to include ligand SMILES anymore because the Tanimoto calculation reads in separate files now (8/14/2019)
    compound_list = []
    filtered_decoy_list = []
    
def generate_decoys(ligands_fname, warhead, spec_fname):
    spec = parse_spec_file(spec_fname)
    ligands = parse_ligands_file(ligands_fname)

    for ligand_id in ligands:
        smiles = lig_dict[ligand_id]
        
        query_zinc(ligand_id, smiles, spec, ligands_fname)

    


def main(argv):
    parser = optparse.OptionParser(version=VERSION, description=DESCRIPTION, usage=USAGE)
    parser.add_option(
        "--ligands", type="string", action="store", dest="ligands_fname", default=substances.smi,
        help="""A smiles file of query ligands for which to generate property matche decoys""")
    parser.add_option(
        "--warhead", type="string", action="store", dest="warhead", default="C#N",
        help="""A smarts pattern for the DOCKovalent warhead""")
    parser.add_option(
        "--spec", type="string", action="store", dest="spec_fname", default="ligand_generation.in",
        help="""Specification file for how to generate ligands""")
    parser.add_option(
        "--verbose", type="bool", action="store", dest="verbose", default=False,
        help="""Verbose output""")

    options, args = parser.parse_args()

    generate_decoys(
        ligands_fname=options.ligands_fname,
        warhead=options.warhead,
        spec_fname=options.spec_fname)

if __name__ == "__main__":
    main(sys.argv)
