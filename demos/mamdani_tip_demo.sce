mode(-1);
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
// Copyright (C) @YEARS@ Jaime Urzua Grez
// mailto:jaime_urzua@yahoo.com
// 
// 2011 Holger Nahrstaedt
// ----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ----------------------------------------------------------------------

// Copyright (C) 2011 L. Markowsky <lmarkov@users.sourceforge.net>
//

// Author:        L. Markowsky
// Note:          This example is based on an assignment written by
//               Dr. Bruce Segee (University of Maine Dept. of ECE).


demo_path= get_absolute_file_path("mamdani_tip_demo.sce");
clc; mode(1);lines(0);

// Demonstrate the use of the Octave Fuzzy Logic Toolkit to read and evaluate a
//  Mamdani-type FIS stored in a file.


// Read the FIS structure from a file.
fis=importfis (demo_path+'/mamdani_tip_calculator');

// Plot the input and output membership functions.
scf();plotvar (fis, 'input', [1 2]);
scf();plotvar (fis, 'output', [1, 2]);

// Plot the Tip and Check + Tip as functions of Food-Quality and Service.
scf();plotsurf (fis, [1 2], 1, [0 0]);
scf();plotsurf (fis, [1 2], 2, [0 0]);

// Calculate the Tip and Check + Tip using (Food-Quality, Service) = (4, 6).
[output, rule_input, fuzzy_output] = evalfls ([4 6], fis, 1001);


// Plot the first aggregated fuzzy output and the first crisp output (Tip)
// on one set of axes.
x_axis = linspace (fis.output(1).range(1), fis.output(1).range(2), 1001);
figure('figure_name', 'Aggregation and Defuzzification for Input = (4, 6)');
plot (x_axis, fuzzy_output(:, 1), "b", 'LineWidth', 2);

crisp_output = mfeval(x_axis, 'constant', output(1));

plot ([crisp_output,crisp_output], [0 1], "r", 'LineWidth', 2);
legend([";Aggregated Fuzzy Output;","Crisp Output = " string(output(1)) "%;"]);
//ylim ([-0.1, 1.1]);
xlabel ('Tip', 'FontWeight', 'bold');
xgrid();


// Show the rules in symbolic format.
printf ("\nMamdani Tip Calculator Rules:\n\n");
printrule (fis, 'symbolic');
