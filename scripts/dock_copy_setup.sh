#!/bin/bash

SOURCE=$1

echo "Copying Docking setup from ../${SOURCE}"

echo "   copying inputs ..."
cp ../${SOURCE}/rec.pdb .
cp ../${SOURCE}/xtal-lig.pdb .

echo "   copying blastermaster generated files ..."
cp -r ../${SOURCE}/working .
cp -r ../${SOURCE}/INDOCK .
cp -r ../${SOURCE}/dock64 .
cp -r ../${SOURCE}/dock.csh .
cp -r ../${SOURCE}/dockfiles .

