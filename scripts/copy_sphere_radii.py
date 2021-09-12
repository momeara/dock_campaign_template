import sys
import optparse
import sph_lib

VERSION = "0.0.1"
DESCRIPTION = "converting .sph -> .pdb -> .sph currently strips sphere radii, this little script looks spheres in input.sph in lookup.sph and copies the radii and writes them out again"
USAGE = """

   python copy_sphere_radii.py --input input.sph --lookup lookup.sph --output output.sph

"""

def copy_sphere_radii(input_fname, lookup_fname, output_fname, verbose):
    tol = .001
    lookup_spheres = sph_lib.read_sph(lookup_fname, 'A', 'A')
    input_spheres = sph_lib.read_sph(input_fname, 'A', 'A')
    output_spheres=[]
    for input_sphere in input_spheres:
        found_sphere = False
        for lookup_sphere in lookup_spheres:
            if (
                abs(lookup_sphere.X - input_sphere.X) < tol and
                abs(lookup_sphere.Y - input_sphere.Y) < tol and
                abs(lookup_sphere.Z - input_sphere.Z) < tol):
                output_sphere = lookup_sphere
                found_sphere = True
                break
        if not found_sphere:
            print("WARNING: input_sphere (cluster={}, color={}, index={}, X={}, Y={}, Z={}) not found in lookup spheres".format(
                input_sphere.critical_cluster,
                input_sphere.sphere_color,
                input_sphere.index,
                input_sphere.X,
                input_sphere.Y,
                input_sphere.Z))
            output_sphere = input_sphere
        output_spheres.append(output_sphere)
    sph_lib.write_sph(output_fname, output_spheres)




def main(argv):
    parser = optparse.OptionParser(version=VERSION, description=DESCRIPTION, usage=USAGE)
    parser.add_option(
        "-i", "--input", type="string", action="store", dest="input_fname", default="input.sph",
        help="Input .sph file, generated e.g. by sphgen")
    parser.add_option(
        "-l", "--lookup", type="string", action="store", dest="lookup_fname", default="lookup.sph",
        help="Lookup radii in this .sph file.")                  
    parser.add_option(
        "-o", "--output", type="string", action="store", dest="output_fname", default="output.pdb",
        help="Output .pdb file to be created from input .sph file")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False, help="Verbose logging info")
    options, args = parser.parse_args()

    copy_sphere_radii(
        input_fname = options.input_fname,
        lookup_fname = options.lookup_fname,
        output_fname = options.output_fname,
        verbose = options.verbose)

if __name__ == '__main__':
    main(sys.argv)
