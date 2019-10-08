function ou=ie_fls_edit(op1,op2)
// ----------------------------------------------------------------------
// Multi pourpose import/export rutine -- editfls utility
// ----------------------------------------------------------------------
// This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
// Copyright (C) @YEARS@ Jaime Urzua Grez
// mailto:jaime_urzua@yahoo.com
// 
// 2011 Holger Nahrstaedt
// 
// ----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ----------------------------------------------------------------------
ou=[];
if (argn(2)==0) then
  op1=[];op2=[];
end;

TCL_EvalStr('fltEdit');
// IMPORT FROM FILE OR WORKSPACE
if (op1==1)|(op1==2)|(op1==3) then
	if (op1==1) then
		// Import from file
		if (fileparts(op2,'extension')==".fls") then			
			fls=loadfls(op2);
		else 
			fls=importfis(op2);
		end
	elseif (op1==2) then
		// Import from workspace
		execstr('%_fls='+op2);
		fls=%_fls;
	else
		// Create a new fls
		if (op2=='m') then
			fls=newfls('m');
		else
			fls=newfls('ts');
		end
	end
	TCL_SetVar("fltEditTable(fls,name)",fls.name);
	TCL_SetVar("fltEditTable(fls,comment)",fls.comment);
	TCL_SetVar("fltEditTable(fls,type)",fls.type);
	TCL_SetVar("fltEditTable(fls,SNorm)",fls.SNorm);
	TCL_SetVar("fltEditTable(fls,SNormPar)",string(fls.SNormPar+0));
	TCL_SetVar("fltEditTable(fls,TNorm)",fls.TNorm);
	TCL_SetVar("fltEditTable(fls,TNormPar)",string(fls.TNormPar+0));
	TCL_SetVar("fltEditTable(fls,Comp)",fls.Comp);
	TCL_SetVar("fltEditTable(fls,CompPar)",string(fls.CompPar+0));
	TCL_SetVar("fltEditTable(fls,ImpMethod)",fls.ImpMethod);
	TCL_SetVar("fltEditTable(fls,AggMethod)",fls.AggMethod);
	TCL_SetVar("fltEditTable(fls,defuzzMethod)",fls.defuzzMethod);
	TCL_SetVar("fltEditTable(fls,input,nvar)",length(fls.input));
	TCL_SetVar("fltEditTable(fls,output,nvar)",length(fls.output));
	// Export antecedents information
	for i=1:length(fls.input),
		TCL_SetVar("fltEditTable(fls,input,"+string(i)+",name)",fls.input(i).name);
		TCL_SetVar("fltEditTable(fls,input,"+string(i)+",range)",strcat(string(fls.input(i).range)," "));
		TCL_SetVar("fltEditTable(fls,input,"+string(i)+",nmf)",length(fls.input(i).mf));
		for j=1:length(fls.input(i).mf),
			TCL_SetVar("fltEditTable(fls,input,"+string(i)+","+string(j)+",name)",fls.input(i).mf(j).name);
			TCL_SetVar("fltEditTable(fls,input,"+string(i)+","+string(j)+",type)",fls.input(i).mf(j).type);
			TCL_SetVar("fltEditTable(fls,input,"+string(i)+","+string(j)+",par)",strcat(string(fls.input(i).mf(j).par)," "));
		end
	end
	// Export consecuents information
	for i=1:length(fls.output),
		TCL_SetVar("fltEditTable(fls,output,"+string(i)+",name)",fls.output(i).name);
		TCL_SetVar("fltEditTable(fls,output,"+string(i)+",range)",strcat(string(fls.output(i).range)," "));
		TCL_SetVar("fltEditTable(fls,output,"+string(i)+",nmf)",length(fls.output(i).mf));
		for j=1:length(fls.output(i).mf),
			TCL_SetVar("fltEditTable(fls,output,"+string(i)+","+string(j)+",name)",fls.output(i).mf(j).name);
			TCL_SetVar("fltEditTable(fls,output,"+string(i)+","+string(j)+",type)",fls.output(i).mf(j).type);
			TCL_SetVar("fltEditTable(fls,output,"+string(i)+","+string(j)+",par)",strcat(string(fls.output(i).mf(j).par)," "));
		end
	end

	// Export Rules
	TCL_SetVar("fltEditTable(fls,nrul)",size(fls.rule,1));
	for i=1:size(fls.rule,1),
		st=strcat(string(fls.rule(i,:))," ");
		TCL_SetVar("fltEditTable(fls,rule,"+string(i)+")",st);		
	end

	// Redraw informacion on screen
	TCL_EvalStr("fltEditRedraw 0");


// EXPORT TO FILE OR WORKSPACE
elseif (op1==4)|(op1==5) then
	fls=newfls(TCL_GetVar("fltEditTable(fls,type)"));
	fls.name=TCL_GetVar("fltEditTable(fls,name)");
	fls.comment=TCL_GetVar("fltEditTable(fls,comment)");
	fls.SNorm=TCL_GetVar("fltEditTable(fls,SNorm)");
	SNormPar=TCL_GetVar("fltEditTable(fls,SNormPar)")
	[SNormPar,ierr]=evstr(SNormPar);
	if (ierr~=0) then SNormPar=0; end;
	fls.SNormPar=SNormPar;
	fls.TNorm=TCL_GetVar("fltEditTable(fls,TNorm)");
	TNormPar=TCL_GetVar("fltEditTable(fls,TNormPar)");
	[TNormPar,ierr]=evstr(TNormPar);
	if (ierr~=0) then TNormPar=0; end;
	fls.TNormPar=TNormPar;
	fls.Comp=TCL_GetVar("fltEditTable(fls,Comp)");
	CompPar=TCL_GetVar("fltEditTable(fls,CompPar)");
	[CompPar,ierr]=evstr(CompPar);
	if (ierr~=0) then CompPar=0; end;
	fls.CompPar=CompPar;
	fls.ImpMethod=TCL_GetVar("fltEditTable(fls,ImpMethod)");
	fls.AggMethod=TCL_GetVar("fltEditTable(fls,AggMethod)");
	fls.defuzzMethod=TCL_GetVar("fltEditTable(fls,defuzzMethod)");

	// Import antecedents information
	for i=1:evstr(TCL_GetVar("fltEditTable(fls,input,nvar)")),
		varname=TCL_GetVar("fltEditTable(fls,input,"+string(i)+",name)");
		varrange=evstr(TCL_GetVar("fltEditTable(fls,input,"+string(i)+",range)"));
		fls=addvar(fls,'input',varname,varrange);
		for j=1:evstr(TCL_GetVar("fltEditTable(fls,input,"+string(i)+",nmf)")),
			mfname=TCL_GetVar("fltEditTable(fls,input,"+string(i)+","+string(j)+",name)");
			mftype=TCL_GetVar("fltEditTable(fls,input,"+string(i)+","+string(j)+",type)");
			mfpara=evstr(TCL_GetVar("fltEditTable(fls,input,"+string(i)+","+string(j)+",par)"));
			fls=addmf(fls,'input',i,mfname,mftype,mfpara);
		end
	end

	// Import consecuents information
	for i=1:evstr(TCL_GetVar("fltEditTable(fls,output,nvar)")),
		varname=TCL_GetVar("fltEditTable(fls,output,"+string(i)+",name)");
		varrange=evstr(TCL_GetVar("fltEditTable(fls,output,"+string(i)+",range)"));
		fls=addvar(fls,'output',varname,varrange);
		for j=1:evstr(TCL_GetVar("fltEditTable(fls,output,"+string(i)+",nmf)")),
			mfname=TCL_GetVar("fltEditTable(fls,output,"+string(i)+","+string(j)+",name)");
			mftype=TCL_GetVar("fltEditTable(fls,output,"+string(i)+","+string(j)+",type)");
			mfpara=evstr(TCL_GetVar("fltEditTable(fls,output,"+string(i)+","+string(j)+",par)"));
			fls=addmf(fls,'output',i,mfname,mftype,mfpara);
		end
	end
	// Import Rules
	rule=[];
	nrules=evstr(TCL_GetVar("fltEditTable(fls,nrul)"));
	for i=1:nrules,
		ru=evstr(TCL_GetVar("fltEditTable(fls,rule,"+string(i)+")"));
		rule=[rule;ru];
	end

	fls.rule=rule;

	if (op1==4) then
		// Save to a file
		savefls(fls,op2);
	else
		// Export to workspace as output of this function
		ou=fls;
	end

// EXPORT THE LIST OF ACTUALS FLS IN THE WORKSPACE
elseif (op1==6) then
	flslist=sciFLTgetFLS();
	TCL_SetVar("fltEditTable(fls,listworkspace)","");
	if (size(flslist,1)>0) then 
		TCL_SetVar("fltEditTable(fls,listworkspace)",flslist(1));
		for i=2:size(flslist,1),
			TCL_EvalStr("lappend fltEditTable(fls,listworkspace) "+flslist(i));
		end
	end
	TCL_EvalStr("fltEditImportFromWS 1");
else
	error("Incorrect calling sequence!");
end

endfunction

