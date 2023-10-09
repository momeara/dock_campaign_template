

# the default max number of atoms is 25 which is tiny!
sed -i -e "s/atom_maximum                  25/atom_maximum                  500/g" dockfiles/INDOCK
