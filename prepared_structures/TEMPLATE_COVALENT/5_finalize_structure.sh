#SEARCH MODE
sed -i "s/check_clashes                 yes/check_clashes                 no/" dockfiles/INDOCK
sed -i "s/number_save                   1/number_save                   10/" dockfiles/INDOCK
sed -i "s/number_write                  1/number_write                  10/" dockfiles/INDOCK

#MATCHING
sed -i "s/bump_maximum                  10.0/bump_maximum                  100.0/" dockfiles/INDOCK
sed -i "s/bump_rigid                    10.0/bump_rigid                    100.0/" dockfiles/INDOCK

#DOCKOVALENT
sed -i "s/dockovalent                   no/dockovalent                   yes/" dockfiles/INDOCK
sed -i "s/bond_len                      1.8/bond_len                      1.8/" dockfiles/INDOCK
sed -i "s/bond_ang1                     109.5/bond_ang1                     102/" dockfiles/INDOCK
sed -i "s/bond_ang2                     109.5/bond_ang2                     115/" dockfiles/INDOCK
sed -i "s/len_range                     0.0/len_range                     0.06/" dockfiles/INDOCK
sed -i "s/len_step                      0.1/len_step                      0.01/" dockfiles/INDOCK
sed -i "s/ang1_range                    10.0/ang1_range                    3.0/" dockfiles/INDOCK
sed -i "s/ang2_range                    10.0/ang2_range                    3.0/" dockfiles/INDOCK
sed -i "s/ang1_step                     2.5/ang1_step                     .25/" dockfiles/INDOCK
sed -i "s/ang2_step                     2.5/ang2_step                     .25/" dockfiles/INDOCK

#MINIMIZATION
sed -i "s/minimize                      yes/minimize                      no/" dockfiles/INDOCK

# the default max number of atoms is 25 which is tiny!
sed -i -e "s/bump_maximum                  10.0/bump_maximum                  100.0/g" dockfiles/INDOCK
sed -i -e "s/bump_rigid                    10.0/bump_rigid                    100.0/g" dockfiles/INDOCK
sed -i -e "s/mol2_score_maximum            -10.0/mol2_score_maximum            100.0/g" dockfiles/INDOCK
sed -i -e "s/atom_maximum                  25/atom_maximum                  500/g" dockfiles/INDOCK
