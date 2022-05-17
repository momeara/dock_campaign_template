
#SEARCH MODE
sed -i "s/check_clashes                 yes/check_clashes                 no/" dockfiles/INDOCK

#MATCHING
sed -i "s/bump_maximum                  10.0/bump_maximum                  100.0/" dockfiles/INDOCK
sed -i "s/bump_rigid                    10.0/bump_rigid                    100.0/" dockfiles/INDOCK

#DOCKOVALENT
sed -i "s/dockovalent                   no/dockovalent                   yes/" dockfiles/INDOCK

#MINIMIZATION
sed -i "s/minimize                      yes/minimize                      no/" dockfiles/INDOCK
