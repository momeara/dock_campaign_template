#!/bin/csh

# Setup environment
source /mnt/nfs/soft/dock/versions/dock37/DOCK-3.7-trunk/env.csh
setenv AMSOLEXE /nfs/home/momeara/ex9/tools/amsol7.1-colinear-fix/amsol7.1
source /mnt/nfs/soft/corina/current/env.csh
source /mnt/nfs/soft/python/current/env.csh
source /nfs/soft/jchem/current/env.csh
setenv EMBED_PROTOMERS_3D_EXE $DOCKBASE/ligand/3D/embed3d_corina.sh
setenv PATH ${PATH}:/nfs/soft/openbabel/current/bin
setenv TMPDIR /scratch/momeara

# path to zinc database
setenv ZINC3D_PATH /nfs/ex3/published/3D
