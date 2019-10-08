function [x,y,typ]=scicos_snorm(job,arg1,arg2)
// ----------------------------------------------------------------------
// S-NORM SCICOS INTERFACE BLOCK
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
	  [ok,par,typ]=scicos_sp(101,[model.ipar(1) model.rpar(1)]);
	  if ~ok then break,end
	  evtin=[];
          evtout=[];
	  in=-1;
	  out=1;
	  [model,graphics,ok]=check_io(model,graphics,in,out,evtin,evtout);
	  if ok then
	      graphics.exprs=exprs;
	      model.ipar=par(1);
	      model.rpar=par(2);	
	      x.graphics=graphics;x.model=model
	      break
	   end
	end
case 'define' then
	// DEFINITION
	model=scicos_model();
	model.sim=list('ssnorm',4); 
	model.in=-1;
	model.out=1;
	model.ipar=0;
	model.rpar=0.5;
	model.blocktype='c';
	model.dep_ut=[%t %f];
	gr_i='scicos_icons(101,sz,orig);';
	x=standard_define([2 2],model,[],gr_i)
end
endfunction

