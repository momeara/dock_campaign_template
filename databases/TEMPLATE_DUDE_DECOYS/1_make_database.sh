#!/bin/bash

# TODO convert over to using the http://tldr.docking.org/ server

SUBSTANCES_FNAME=substances.smi


# http://wiki.docking.org/index.php/Generating_decoys_(Reed%27s_way)
python /mnt/nfs/home/rstein/zzz.scripts/new_DUDE_SCRIPTS/0000_protonate_setup_dirs.py ${SUBSTANCES_FNAME} decoys
python /mnt/nfs/home/rstein/zzz.scripts/new_DUDE_SCRIPTS/0001_qsub_generate_decoys.py decoys
python /mnt/nfs/home/rstein/zzz.scripts/new_DUDE_SCRIPTS/0002_qsub_filter_decoys.py decoys
python /mnt/nfs/home/rstein/zzz.scripts/new_DUDE_SCRIPTS/0003_copy_decoys_to_new_dir.py decoys decoys_final

find $(pwd)/decoys_final/decoys -name '*db2.gz' > database.sdi
