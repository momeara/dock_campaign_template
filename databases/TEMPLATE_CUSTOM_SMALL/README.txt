
Generate a small docking library from a list of smiles

Here is the generation process


  ChemAxon Marvin: SMILES -> protomer SMILES
  for each protomer
      JChem MolConvert: convert to mol2 format and add hydrogens
      AMSOL7.1: calculate solvation
      omega: generate conformations
      mol2db: combine conformations into .db2 library
      

# input

  * substances.smi
       - a space separated table with two columns [SMILES, substance_id]
       - the substance ids should be at most 16 characters. The dock results
         truncate the substance_ids in the output and it's hard to figure out what is what


# output

  * database.sdi
    - a list of paths to .db2.gz docking libraries ready be used in a docking run

  * Intermediate files
    - For each substance <substance_id> the following files are generated
             
      <substance_id>/
         <substance_id>-protonated.ism        # tsv w/columns [SMILES, substance_id, % weight]
         <PROT_INDEX>/                        # e.g. 0, 1, 2, etc. one for each protomer
            <substance_id>.<PROT_INDEX>.mol2  # mol2 with hydrogens    
            mol.solv                          # amsol solvated 
