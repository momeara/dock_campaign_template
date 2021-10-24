#!/bin/bash

cp $(dirname ${BASH_SOURCE})/../setup_dock_environment.sh .

mkdir structures
mkdir prepared_structures
mkdir databases
mkdir docking_runs
mkdir product

echo "Next steps:"
echo ""
echo "  Edit setup_dock_environment.sh"
echo ""
echo "Then to setup and run the dock campaign"
echo ""
echo "  source setup_dock_environment.sh"
echo "  \${DOCK_TEMPLATE}/scripts/run.sh"
echo ""

