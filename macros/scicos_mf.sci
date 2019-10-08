function [x,y,typ]=scicos_mf(job,arg1,arg2)
// ----------------------------------------------------------------------
// MEMBER FUNCTION SCICOS INTERFACE BLOCK
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

x=[];y=[];typ=[];

select job
case 'plot' then
	standard_draw(arg1);
case 'getinputs' then
	[x,y,typ]=standard_inputs(arg1);
case 'getoutputs' then
	[x,y,typ]=standard_outputs(arg1);
case 'getorigin' then
	[x,y]=standard_origin(arg1);
case 'set' then
	// SET VALUE
	x=arg1;
	model=arg1.model;graphics=arg1.graphics;
	exprs=graphics.exprs;
	while %t do
	    //[ok,par,typ]=scicos_sp(model.ipar(1),model.rpar);
	      [ok,mf,a,b,c,d,exprs]=..
      scicos_getvalue('Choose member function and parameters',..
      [//'Channels:';
       'trimf(1), trapmf(2), gaussmf(3), gauss2mf(4), sigmf(5), dsigmf(6), psigmf(7), gbellmf(8), pimf(9), smf(10), zmf(11) :';
	'a';'b';'c';'d';],..
      list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs)
	    if ~ok then break,end
	    evtin=[];
            evtout=[];
	    in=-1;
	    out=-1;
	    [model,graphics,ok]=check_io(model,graphics,in,out,evtin,evtout);
	    if ok then
	      graphics.exprs=exprs;
	      model.ipar=mf;//typ;
	      select mf
	      case 1 then 
		model.rpar=[a;b;c];
	      case 2 then 
		model.rpar=[a;b;c;d];
		case 3 then 
		model.rpar=[a;b];
		case 4 then 
		model.rpar=[a;b;c;d];
		case 5 then 
		model.rpar=[a;b];
		case 6 then 
		model.rpar=[a;b;c;d];
		case 7 then 
		model.rpar=[a;b;c;d];
		case 8 then 
		model.rpar=[a;b;c];
		case 9 then 
		model.rpar=[a;b;c;d];
		case 10 then 
		model.rpar=[a;b;];
		case 11 then 
		model.rpar=[a;b;];
		end
	      //model.rpar=par(:);	
	      x.graphics=graphics;x.model=model
	      break
	    end
	end	
case 'define' then
	// DEFINITION
	model=scicos_model();
	model.sim=list('smfeval',4); 
	model.in=-1;
	model.out=-1;
	// SET AS NONE
	model.ipar=0;
	model.rpar=[];
	model.blocktype='c';
	model.dep_ut=[%t %f];	
	exprs=["0";"";"";"";""]
	gr_i='scicos_icons(model.ipar(1),sz,orig);';
	x=standard_define([2 2],model,exprs,gr_i)
end
endfunction

