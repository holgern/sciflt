# sciFLT TOOLBOX
sciFLT is a Fuzzy Logic Toolbox for scilab

This is the Revision 0.4 of sciFLT toolbox.
By Jaime Urzua Grez
   Holger Nahrstaedt
mailto:jaime_urzua@yahoo.com
http://es.geocities.com/jaime_urzua/sciflt/sciflt.html

sciFLT is a Fuzzy Logic Toolbox for scilab.

# BUILD AND LOAD
The build is very simple, just type in scilab:

 exec("sciFLT_Path/builder.sce")

 To load just type in scilab:
 
 exec("sciFLT_path/loader.sce");

 NOTES:
 a) sciFLT_Path is where this file is.
 b) You need fortran and C compiler, also, scilab must be builded with tk/tcl option to use internal editor.
    In src folder, I implement a simple makefile to build this toolbox using mingw32, see readme_mingw32.txt in src folder

# EXAMPLES and DEMOS
 To see some examples type in scilab:

 sciFLTdemo();

# CHARACTERISTICS
Types of Fuzzy Logic systems: At this stage, sciFLT can deal with Takagi-Sugeno Fuzzy and Mamdani fuzzy systems.

SCICOS support (IN PROGRESS): Member functions, S-Norm, T-Norm, Complement and Fuzzy Logic System (fls) are supported. Also include a palette.

S-Norm Class supported: Dubois-Prade, Yager, Drastic sum, Einstein sum, Algebraic sum, Maximum.

T-Norm Class supported: Dubois-Prade, Yager, Drastic product, Einstein product, Algebraic product, Minimum.

Complement Class supported: One, Yager, Dubois.

Member Function: Triangular, Trapezoidal, Gaussian, Extended Gaussian, Sigmoidal, Product of two Sigmoidal, Difference of two sigmoidal, S-Shaped, Z-Shaped, Pi-Shaped.

Clustering: C-Means, Substractive clustering.

FLS Optimization: optfls01.

# REVISION NOTES
 (1) Add some clustering routines: fcmeans, subclus.
 (2) Minor code change using new TK/TCL calling sequence.
 (3) The tk/tcl editor is still in the develop stage, so you can find a lot of bugs.
 (4) Try to Vectorize code
 (5) Start to add optimization routines

Copyright (c) @YEARS@ Jaime Urzua Grez
		2011 Holger Nahrstaedt
 
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
