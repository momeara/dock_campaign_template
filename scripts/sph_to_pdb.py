#!/usr/bin/env python

VERSION = "0.0.4"
DESCRIPTION = "Convert docking spheres (.sph files) to protein databank files (.pdb)"
USAGE = """

    sph_to_pdb.py -i <input.sph> --cluster <cluster_id>  -o <output.pdb>

    Take in the input.sph file, optionally select a cluster by cluster id or all by defalut
    Output spheres in pdb format, where each sphere is represented as a chain with a single atom

    Sphere in input.sph
      
          78  16.85155  99.17048  68.98616   1.466   83 0  0
        ^^^^ \                           /  ^^^^^^ ^^^^ 
        id       coordinates of center      radius resid?
       
       ATOM     78  C   SPH    78      16.852  99.170  68.986  1.46  83.0 0 0
       TER
                ^   ^                  \                    / ^^^^^  ^^^^ 
        sphere id   cluster id          coordinates of center radius resid?

    Note that the coordinates in the .sph file are have more digits than are allowed in the PDB format, so some precision is lost
    The radius is saved in the occupancy column the the resid is stored in the tempFactor
"""

import sys
import optparse
import sph_lib

def sph_to_pdb(
    input_fname,
    cluster,
    color,
    output_fname,
    verbose):

    spheres = sph_lib.read_sph(input_fname, cluster, color)
    with open(output_fname, 'w') as pdb_file:
        for sphere in spheres:
            pdb_file.write("".join([
                "ATOM  ",                                #1-6   record type
                "{:5d}".format(int(sphere.index)),       #7-11  atom serial number
                " ",
                " C  ",                                  #13-16 atom name
                " ",                                     #17    insertion code
                "SPH",                                   #18-20 residue name
                " ",
                "{:1d}".format(int(sphere.critical_cluster)), #22    chain id
                "{:4d}".format(int(sphere.index)),       #23-26 resSeq
                " ",                                     #27    icode
                "   ",
                "{:8.3f}".format(sphere.X),              #31-38 X coordinate
                "{:8.3f}".format(sphere.Y),              #39-46 Y coordinate
                "{:8.3f}".format(sphere.Z),              #47-54 Z coordinate
                "{:6d}".format(sphere.atomnum),          #55-60 occupancy
                "{:6.2f}".format(sphere.radius),         #61-66 temperature factor
                "          ",
                "{:2d}".format(sphere.critical_cluster), #77-78 element symbol
                "{:2d}".format(sphere.sphere_color),     #79-80 charge
                "\n"]))   

def main(argv):
    parser = optparse.OptionParser(version=VERSION, description=DESCRIPTION, usage=USAGE)
    parser.add_option(
        "-i", "--input", type="string", action="store", dest="input_fname", default="spheres.sph",
        help="Input .sph file, generated e.g. by sphgen")
    parser.add_option(
        "--cluster", type='int', action="store", dest="cluster", default=0,
        help="Select specific cluster, if 0 then all (default: 0)")
    parser.add_option(
        "--color", type="int", action="store", dest="color", default=0,
        help="Select specific cluster, if 0 then all (default: 0)")
    parser.add_option(
        "-o", "--output", type="string", action="store", dest="output_fname", default="spheres.pdb",
        help="Output .pdb file to be created from input .sph file")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False, help="Verbose logging info")
    options, args = parser.parse_args()

    # sphpdb uses 0 as default but sph_lib uses 'A' for default
    if options.cluster == 0:
        cluster = 'A'
    else:
        cluster = options.cluster

    # sphpdb uses 0 as default but sph_lib uses 'A' for default
    if options.color == 0:
        color = 'A'
    else:
        color = options.color


    sph_to_pdb(
        input_fname = options.input_fname,
        cluster = cluster,
        color=color,
        output_fname = options.output_fname,
        verbose = options.verbose)

if __name__ == '__main__':
    main(sys.argv)
