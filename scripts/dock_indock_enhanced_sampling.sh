
# MATCHING
sed -i "s/match_goal[ 0-9]+$/match_goal                   10000/" dockfiles/INDOCK
sed -i "s/bump_maximum[ 0-9.]+$/bump_maximum                  10000.0/" dockfiles/INDOCK

# SEARCH MODE
sed -i "s/number_save                   1/number_save                   10/" dockfiles/INDOCK
sed -i "s/check_clashes                 yes/check_clashes                 no/" dockfiles/INDOCK
