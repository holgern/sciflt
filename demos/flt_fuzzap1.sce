mode(-1);
// ----------------------------------------------------------------------
// Fuzzy Approximation
// The function have 1 input and 1 output
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

// PREAMBLE
tohome();
write(%io(2),"");
write(%io(2),"-----------------------------------------------------");
write(%io(2),"The function to approximate is:");
write(%io(2),"f(x)=sin(x).*cos(3*x)");
write(%io(2),"The input domain is [-%pi %pi], the output domain is [-1 1]");
mprintf("Press ENTER to start.");
mscanf('%c');

// The function
deff("y=F(x)","y=sin(x).*cos(3*x)");
// The Jacobian
deff("y=dF(x)","y=-3*sin(x).*sin(3*x)+cos(x).*cos(3*x)");
// Some initial values
X=linspace(-%pi,%pi,100)';
Y=F(X);
for npart=[7 10 15],
	q2=" partitions ="+string(npart);
	// Now the first and second order approximation with npart partitions
	fls1=fuzzapp(1,[-%pi %pi],[-1 1],npart,F);
	fls2=fuzzapp(2,[-%pi %pi],[-1 1],npart,F,dF);
	// Calculate Values
	Y1=evalfls(X,fls1);
	Y2=evalfls(X,fls2);
	// Contrast the results (function plot)
	scf();clf();
	subplot(2,2,1);
	plot2d(X,[Y Y1],leg="function@approximation",rect=[-%pi -1.5 %pi 1.5]);
	xtitle("Fuzzy approximation (first order)"+q2,"x","y");
	subplot(2,2,2);
	plot2d(X,[Y Y2],leg="function@approximation",rect=[-%pi -1.5 %pi 1.5]);
	xtitle("Fuzzy approximation (second order)"+q2,"x","y");
	E1=abs(Y-Y1);
	E2=abs(Y-Y2);
	m1=1.15*max(max(E1),max(E2));
	subplot(2,2,3);
	plot2d(X,E1,rect=[-%pi 0 %pi m1]);
	xtitle("","x","approx error");
	subplot(2,2,4);
	plot2d(X,E2,rect=[-%pi 0 %pi m1])
	xtitle("","x","approx error");
	// wait 2 seconds
	sleep(2000);
end
write(%io(2),"The end");
write(%io(2),"");

