function scicos_icons(typ,sz,orig)
// ----------------------------------------------------------------------
// DRAW ICONS USED IN SCICOS
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

// typ=0 -> MF NONE
if (typ==0) then
	xx=[1.0 2.0 4.0]/5;
	yy=[0.5 2.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='MFS';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=1 -> trimf
elseif (typ==1) then
	xx=[1.0 2.0 4.0]/5;
	yy=[0.5 2.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='trimf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=2 -> trapmf
elseif (typ==2) then
	xx=[1.0 2.0 3.0 4.0]/5;
	yy=[0.5 2.5 2.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='trapmf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=3 -> gaussmf
elseif (typ==3) then	
	xx=(1:0.1:4);
	yy=exp(-(xx-2.5)^2/0.5)*2+0.5;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='gaussmf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=4 -> gauss2mf
elseif (typ==4) then
	xx=(1:0.1:4);
	yy=exp(-(xx-2.5)^2/0.5)*2+0.5;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='gauss2mf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=5 -> sigmf
elseif (typ==5) then
	xx=(1:0.1:4);
	yy=(1 ./ (1 + exp(-5*(xx-2.5)) ))*2+0.6 ;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='sigmf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=6 -> dsigmf
elseif (typ==6) then
	xx=(1:0.1:4);
	yy=(1 ./ (1 + exp(-5*(xx-2.5)) ))*2+0.6 ;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='dsigmf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=7 -> psigmf
elseif (typ==7) then
	xx=(1:0.1:4);
	yy=(1 ./ (1 + exp(-5*(xx-2.5)) ))*2+0.6 ;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='psigmf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=8 -> gbellmf
elseif (typ==8) then
	xx=(1:0.1:4);
	yy=( 1 ./ ((1+abs((xx-2.5)/1)).^(2*1)) )*2+0.5;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='gbellmf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=9 -> pimf
elseif (typ==9) then
	xx=(1:0.1:4);
	yy=(1 ./ (1 + exp(-5*(xx-2.5)) ))*2+0.6 ;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='pimf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=10 -> smf
elseif (typ==10) then
	xx=(1:0.1:4);
	yy=(1 ./ (1 + exp(-5*(xx-2.5)) ))*2+0.6 ;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='smf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=11 -> zmf
elseif (typ==11) then
	xx=(1:0.1:4);
	yy=(1 ./ (1 + exp(-5*(xx-2.5)) ))*2+0.6 ;
	xx=xx/5; yy=yy/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='zmf';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=100 -> complement
elseif (typ==100) then
	xx=[2 3 4 4 3 2 1 1 2]/5;
	yy=[1 1 2 3 4 4 3 2 1]/5-0.5/5;
	thick=xget('thickness');xset('thickness',2);
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xx=[3 2 2 3]/5;
	yy=[3 3 2 2]/5-0.5/5;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='complement';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=101 -> snorm
elseif (typ==101) then
	xx=[2 3 4 4 3 2 1 1 2]/5;
	yy=[1 1 2 3 4 4 3 2 1]/5-0.5/5;
	thick=xget('thickness');xset('thickness',2);
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xx=[2 2.5 3]/5;
	yy=[3 2.3 3]/5-0.5/5;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='S-Norm';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=102 -> tnorm
elseif (typ==102) then
	xx=[2 3 4 4 3 2 1 1 2]/5;
	yy=[1 1 2 3 4 4 3 2 1]/5-0.5/5;
	thick=xget('thickness');xset('thickness',2);
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xx=[2 2.5 3]/5;
	yy=[2 3.0 2]/5-0.5/5;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='T-Norm';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// typ=200 -> fls
elseif (typ==200) then
	xx=[1.0 2.0 3.0]/5;
	yy=[0.5 2.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xx=[2.0 3.0 4.0]/5;
	yy=[0.5 2.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	thick=xget('thickness');xset('thickness',2);
	xx=[0.5 4.5]/5;
	yy=[0.5 0.5]/4;
	xpoly(orig(1)+xx*sz(1),orig(2)+yy*sz(2));
	xset('thickness',thick);
	fna='FLS';
	rect=xstringl(0,0,fna);
	xstring(orig(1)+(sz(1)-rect(3))/2,orig(2)+sz(2)-rect(4)*1.1,fna);

// UNKNOW
else
	error("Unknow icon type!");
end

endfunction

