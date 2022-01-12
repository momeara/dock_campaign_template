#structure folder 'prepared_structures/<structure_id>'
PREPARED_STRUCTURE=$(readlink -f ../../prepared_structures/<structure_id>)

#database folder 'databases/<database_id>'
DATABASE=$(readlink -f ../../databases/<database_id>)

source ${DOCK_TEMPLATE}/scripts/dock_clean.sh

echo "Running dock ..."
echo "Running dock ..."
for params in ${PREPARED_STRUCTURE}/combo_directories/*/ ; do
    echo "Submitting job for param set: ${param}"

    mkdir -p results/$(basename ${params})
    pushd results/$(basename ${params})
    bash ${DOCK_TEMPLATE}/scripts/dock_submit.sh \
         ${DATABASE}/database.sdi \
         ${params}/dockfiles \
         .
    popd
done


echo "Collecint dock results ..."
find results -maxdepth 2 -mindepth 2 -type d > dirlist
python ${DOCKBASE}/analysis/extract_all_blazing_fast.py dirlist extract_all.txt 10
python ${DOCKBASE}/analysis/getposes_blazing_fast.py '' extract_all.sort.uniq.txt 500 poses.mol2

source ${DOCK_TEMPLATE}/scripts/dock_statistics.sh
