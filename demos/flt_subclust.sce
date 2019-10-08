mode(-1);
// ----------------------------------------------------------------------
// Subtractive clustering example
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

// Generate center coordinates
ncenters=10;
nnoise=15;
centers=10*rand(ncenters,3);
dta2=[];
scf();clf();
subplot(1,2,1);
for i=1:size(centers,1),
	dta=repvec(nnoise,centers(i,:))+(0.5-rand(nnoise,3));
	param3d(dta(:,1),dta(:,2),dta(:,3));
	dta2=[dta2;dta];
end

// Find clusters
centers2=subclust(dta2',0.35);

// Plot Data
a=gca();
for i=1:size(centers,1),
	a.children(i).line_mode='off';
	a.children(i).mark_mode='on';
	a.children(i).mark_style=i;
	a.children(i).mark_foreground=i;
end

subplot(1,2,2);
xstring(0,1.0,"Subtractive Clustering Example");
xstring(0,0.9,"Centers at:");
for i=1:size(centers2,1),
	msg=strcat(['C_' string(i) '=[' string(centers2(i,1)) ',' string(centers2(i,2)) ',' string(centers2(i,3)) ']' ]);
	xstring(0,0.9-0.06*i,msg);
end

