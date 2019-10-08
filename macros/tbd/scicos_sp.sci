function [ok,par,typ]=scicos_sp(typ,typpar)
// ----------------------------------------------------------------------
// SET PARAMETERS
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
// CHANGES:
// 2005-05-28 Change TCL/TK calling.
// ----------------------------------------------------------------------

// PUT VALUES IN TK-TCL SPACE
TCL_SetVar("sciFLTSPTable(ok)","0");
if (typ~=200) then
	// THIS IS THE GENERAL CASE
	ok=0;par=typpar(:);
	cmd=string(typ)+" ";
	for j=1:size(typpar,"*"),
		cmd=cmd+string(typpar(j))+" ";
	end	
	TCL_EvalStr("sciFLTScicosPar "+string(cmd));
	realtimeinit(0.1);
	while %t;
		realtime(0);realtime(0.1);
		TCL_EvalStr("set isScicosPar [winfo exist .sciFLTScicosParam]");
		if TCL_GetVar("isScicosPar")=="0" then break; end
	end
	typ=evstr(TCL_GetVar('sciFLTSPTable(typ)'));
	ok=evstr(TCL_GetVar('sciFLTSPTable(ok)'));
	if (ok==1) then
		npar=evstr(TCL_GetVar('sciFLTSPTable(npar)'));
		par=zeros(npar,1);
		for j=1:npar,
			par(j)=evstr(TCL_GetVar('sciFLTSPTable('+asciimat(96+j)+')')+"+0");
		end
	end

else
	// THIS IS A SPECIAL CASE -> FLS FROM SCILAB WORKSPACE
	par=list([],[],[]);
	typ=200;
	ok=0;
	if typpar==[] then
		TCL_EvalStr("sciFLTScicosPar 200");
	else
		cmd=string(typ)+" ";
		for j=1:size(typpar,"*"),
			cmd=cmd+"{"+string(typpar(j))+"} ";
		end
		TCL_EvalStr("sciFLTScicosPar "+string(cmd));	
	end
	realtimeinit(0.1);
	pv=0;
	while %t,
		realtime(0);realtime(0.1);
		ok=evstr(TCL_GetVar('sciFLTSPTable(ok)'));
		if ( ok==-1 ) then
			TCL_SetVar('sciFLTSPTable(ok)','0');
			//flsname=tk_getfile("*.fls","./","Choose a fls structure");
			flsname=uigetfile("*.fls","./","Choose a fls structure");
			ok=0;		
			if (flsname~="") then
				if execstr('fls=loadfls(flsname)','errcatch')==0 then
					ninputs=length(fls.input);
					noutputs=length(fls.output);
					nrules=size(fls.rule,1);
					if (ninputs*noutputs*nrules~=0) then
						if execstr('[mid1,mid2,mew,mrule,mdomo,mpari,mparo]=flsencode(fls);','errcatch')==0 then
							rpar=[mrule(:);mdomo(:);mpari(:);mparo(:);mew(:);mid2(:)];		
							ipar=[1;ninputs;noutputs;nrules;mid1(:)];
							m1=[string(fls.name) string(fls.type) string(ninputs) string(noutputs) string(nrules) "1"];
							par=list(ipar,rpar,m1);
							ok=0;
							pv=1;
							TCL_SetVar('sciFLTSPTable(a)',string(fls.name));
							TCL_SetVar('sciFLTSPTable(b)',string(fls.type));
							TCL_SetVar('sciFLTSPTable(c)',string(ninputs));
							TCL_SetVar('sciFLTSPTable(d)',string(noutputs));
							TCL_SetVar('sciFLTSPTable(e)',string(nrules));
							TCL_SetVar('sciFLTSPTable(f)',"1");
							TCL_EvalStr('sciFLTScicosParFLSUp');
						end
					end
				end		
			end
			if (ok==-1) then
				//x_message_modeless("The fls strucure is incompatible!");	
				messagebox("The fls strucure is incompatible!");
			end
		else
			TCL_EvalStr("set isScicosPar [winfo exist .sciFLTScicosParam]");
			if TCL_GetVar("isScicosPar")=="0" then break; end
		end
	end
	ok=evstr(TCL_GetVar('sciFLTSPTable(ok)'));
	ok=ok*pv;	
end
ok=ok==1;

endfunction


