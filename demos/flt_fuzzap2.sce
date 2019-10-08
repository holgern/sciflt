mode(-1);
// ----------------------------------------------------------------------
// Fuzzy Approximation
// The function have 2 inputs and 1 output
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
write(%io(2),"f(x)=sin(x(:,1).*cos(3*x(:,1)");
write(%io(2),"The input domain is [-%pi %pi]x[-%pi %pi], the output domain is [-1 1]");
mprintf("Press ENTER to start.");
mscanf('%c');

// The function
deff("y=F(x)","y=sin(x(:,1)).*cos(3*x(:,2))");
// The Jacobian
deff("y=dF(x)","y=[cos(x(:,1)).*cos(3*x(:,2)) -3*sin(x(:,1)).*sin(3*x(:,2)).*cos(3*x(:,2))]");
// Some initial values
nx1=20;
nx2=20;
x1=linspace(-%pi,%pi,nx1)';
x2=linspace(-%pi,%pi,nx2)';
X=genspace(x1,x2);
Y=F(X);
Y=matrix(Y,nx2,nx1)';
cmap=hotcolormap(128);

for npart=[3 5 10 15 20],
	q2=" partitions ="+string(npart);
	// Now the first and second order approximation with npart partitions
	fls1=fuzzapp(1,[-%pi %pi;-%pi %pi],[-1 1],[npart;npart],F);
	fls2=fuzzapp(2,[-%pi %pi;-%pi %pi],[-1 1],[npart;npart],F,dF);
	// Calculate Values
	Y1=evalfls(X,fls1);
	Y1=matrix(Y1,nx2,nx1)';
	Y2=evalfls(X,fls2);
	Y2=matrix(Y2,nx2,nx1)';
	// Contrast the results (function plot)
	scf();clf();
	h=gcf();
	h.visible="off";
	subplot(2,2,1);
	xtitle("Fuzzy approximation (first order)"+q2);
	plot3d(x1,x2,Y1,30,70,"x1@x2@y",[3 1 4],[-%pi %pi -%pi %pi -1 1]);
	plot3d(x1,x2,Y,30,70,"x1@x2@y",[5 1 4],[-%pi %pi -%pi %pi -1 1]);
	subplot(2,2,2);
	xtitle("Fuzzy approximation (second order)"+q2);
	plot3d(x1,x2,Y2,30,70,"x1@x2@y",[3 1 4],[-%pi %pi -%pi %pi -1 1]);
	plot3d(x1,x2,Y,30,70,"x1@x2@y",[5 1 4],[-%pi %pi -%pi %pi -1 1]);
	E1=abs(Y-Y1);
	E2=abs(Y-Y2);
	m1=1.15*max(max(E1),max(E2));
	subplot(2,2,3);
	plot3d(x1,x2,E1,30,70,"x1@x2@error",[5 1 4],[-%pi %pi -%pi %pi 0 m1]);
	subplot(2,2,4);
	plot3d(x1,x2,E2,30,70,"x1@x2@y",[5 1 4],[-%pi %pi -%pi %pi 0 m1]);
	h.visible="on";
	// wait 2 seconds
	sleep(2000);
end
write(%io(2),"The end");
write(%io(2),"");

