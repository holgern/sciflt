demo_path= get_absolute_file_path("cubic_approx_demo.sce");
clc; mode(1);lines(0);

// Demonstrate the use of the Scilab Fuzzy Logic Toolkit to approximate a
// non-linear function using a Sugeno-type FIS with linear output func

// Read the FIS structure from a file.
fis = importfis (demo_path'/cubic_approximator.fis');

// Plot the input membership functions and linear output functions.
scf();plotvar (fis, 'input', 1);
scf();plotvar (fis, 'output', 1,-150,150);

// Plot the FIS output y as a function of the input x.
scf();plotsurf (fis,1,1,0)