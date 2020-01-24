
#SEARCH MODE
sed -i "s/check_clashes                 yes/check_clashes                 no/" INDOCK
sed -i "s/number_save                   1/number_save                   10/" INDOCK
sed -i "s/number_write                  1/number_write                  10/" INDOCK


#MATCHING
sed -i "s/bump_maximum                  10.0/bump_maximum                  100.0/" INDOCK
sed -i "s/bump_rigid                    10.0/bump_rigid                    100.0/" INDOCK

#DOCKOVALENT
sed -i "s/dockovalent                   no/dockovalent                   yes/" INDOCK
sed -i "s/bond_len                      1.8/bond_len                      1.8/" INDOCK
sed -i "s/bond_ang1                     109.5/bond_ang1                     102/" INDOCK
sed -i "s/bond_ang2                     109.5/bond_ang2                     115/" INDOCK
sed -i "s/len_range                     0.0/len_range                     0.06/" INDOCK
sed -i "s/len_step                      0.1/len_step                      0.01/" INDOCK
sed -i "s/ang1_range                    10.0/ang1_range                    3.0/" INDOCK
sed -i "s/ang2_range                    10.0/ang2_range                    3.0/" INDOCK
sed -i "s/ang1_step                     2.5/ang1_step                     .25/" INDOCK
sed -i "s/ang2_step                     2.5/ang2_step                     .25/" INDOCK

#MINIMIZATION
sed -i "s/minimize                      yes/minimize                      no/" INDOCK
