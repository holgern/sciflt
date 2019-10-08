function fls=loadfls(fls_filename)
//Load fls structure from a file
//Calling Sequence
//fls=loadfls(fls_filename)
//Parameters
//fls:fls structure.
// fls_filename:string, the file name where to save.
//Description
//         <literal>loadfls </literal> get the fuzzy logic system from
//     <literal>fls_filename</literal>.The extension <literal>'.fls'</literal> is assumed for
//     <literal>fls_filename</literal> if it is not already present.
//Examples
//// Create a new structure
// fls1=newfls('ts');
// fls1.comment="This is an example"
// 
// // Save the structure in TMPDIR/example1.fls
// savefls(fls1,TMPDIR+"/example1");
// 
// // Restore the value
// fls2=loadfls(TMPDIR+"/example1")
//See also
//savefls
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Read fls from a file 
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

// CHECK ARGUMENTS
if (argn(2)~=1) then
	error("loadfls need 1 parameters.");
end

if (type(fls_filename)~=10) then
	error("The parameter must be a string.");
end

if (convstr(fileparts(fls_filename,"extension"),"l")~=".fls") then
	fls_filename2=fls_filename+".fls";
else
	fls_filename2=fls_filename;
end

// OPEN THE FILE
[fd,ierr]=mopen(fls_filename2,"r");
if (ierr~=0) then
	error("Unable to open the file!");
end

// CREATE AN EMPTY STRUCTURE
fls=newfls();

// SOME INTERNAL VALUES
tofind1=["<REVISION>" "<DESCRIPTION>" "<INPUT>" "<OUTPUT>" "<RULE>"];
tofind2=["<name>" "<comment>" "<type>" "<SNorm>" "<SNormPar>" "<TNorm>" "<TNormPar>" "<Comp>" "<CompPar>" "<ImpMethod>" "<AggMethod>" "<defuzzMethod>"];
tofind3=["<name>" "<range>"];
tofind4=["<mf_name>" "<mf_type>" "<mf_par>"];

flsvar_def=tlist(['flsvar','name','range','mf'],"",[],list());
flsmf_def=tlist(['flsmf','name','type','par'],"","",[]);

curpart="";
isname=%f;isrange=%f;isputvar=%f;
ismfname=%f;ismftype=%f;ismfpar=%f;
curvari=0;
curvaro=0;
rule=[];
varin=list();
varot=list();

while (meof(fd)==0),
	txt=mgetl(fd,1);

    if isempty(txt);
        eof_cnt = eof_cnt + 1;
        if eof_cnt > 10;
            break;
        end
        
    else
        eof_cnt = 0;
    end
    
    
	if (txt==[]) then txt=""; end;

	// FIND PART
	[a,b]=grep(txt,tofind1);
	if (b~=[]) then
		curpart=tofind1(b);
	end

	// FIND ITEMS IN DESCRIPTION
	if (curpart=="<DESCRIPTION>") then
		isname=%f;isrange=%f;
		ismfname=%f;ismftype=%f;ismfpar=%f;
		[a,b]=grep(txt,tofind2);
		if (b~=[]) then
			curit=tofind2(b);
			value=stripblanks(strsubst(txt,curit,""));
			curit=strsubst(curit,"<","");
			curit=strsubst(curit,">","");
			if (curit=="name") then
				fls.name=value;
			elseif (curit=="comment") then
				fls.comment=value;
			elseif (curit=="type") then
				fls.type=value;
			elseif (curit=="SNorm") then
				fls.SNorm=value;
			elseif (curit=="SNormPar") then
				fls.SNormPar=evstr(value)
			elseif (curit=="TNorm") then
				fls.TNorm=value;
			elseif (curit=="TNormPar") then
				fls.TNormPar=evstr(value);
			elseif (curit=="Comp") then
				fls.Comp=value;
			elseif (curit=="CompPar") then
				fls.CompPar=evstr(value);
			elseif (curit=="ImpMethod") then
				fls.ImpMethod=value;
			elseif (curit=="AggMethod") then
				fls.AggMethod=value;
			elseif (curit=="defuzzMethod") then
				fls.defuzzMethod=value;
			end
		end
	end

	// FIND INOUT OR OUTPUT
	if (curpart=="<INPUT>")|(curpart=="<OUTPUT>") then
		[a,b]=grep(txt,tofind3);
		if (b~=[]) then
			curit=tofind3(b);
			value=stripblanks(strsubst(txt,curit,""));
			curit=strsubst(curit,"<","");
			curit=strsubst(curit,">","");
			if (curit=="name") then
				isname=%t;isrange=%f;isputvar=%f;
				varname=value;
			end
			if (curit=="range") then
				isrange=%t;isputvar=%f;
				[value,ierr]=evstr(value);				
				if (ierr~=0) then
					isrange=%f;
					value=[];
				end
				varrange=value;
			end			
		end

		if ((isname)&(isrange)&(~isputvar)) then
			flsvar=flsvar_def;
			flsvar.name=varname;
			flsvar.range=varrange;
			if (curpart=="<INPUT>") then
				fls.input($+1)=flsvar;
			elseif (curpart=="<OUTPUT>") then
				fls.output($+1)=flsvar;
			end
			isputvar=%t;
		end

		if ((isname)&(isrange)) then
			[a,b]=grep(txt,tofind4);
			if (b~=[]) then
				curit=tofind4(b);
				value=stripblanks(strsubst(txt,curit,""));
				curit=strsubst(curit,"<","");
				curit=strsubst(curit,">","");				
				if (curit=="mf_name") then
					ismfname=%t;ismftype=%f;ismfpar=%f;
					t_mfname=value;
				end
				if (curit=="mf_type") then
					ismftype=%t;ismfpar=%f;
					t_mftype=value;
				end
				if (curit=="mf_par") then
					[t_mfpar,ierr]=evstr(value);
					ismfpar=%t;
					if (ierr~=0) then
						ismfpar=%f;
					end
				end
			end
		end

		if ((ismfname)&(ismftype)&(ismfpar)&(isputvar)) then
			flsmf=flsmf_def;
			flsmf.name=t_mfname;
			flsmf.type=t_mftype;
			flsmf.par=t_mfpar;
			if (curpart=="<INPUT>") then
				fls.input($).mf($+1)=flsmf;
			elseif (curpart=="<OUTPUT>") then
				fls.output($).mf($+1)=flsmf;
			end
			ismfname=%f;ismftype=%f;ismfpar=%f;
		end
	end

	// FIND THE RULE PART
	if (curpart=="<RULE>") then
		isname=%f;isrange=%f;
		ismfname=%f;ismftype=%f;ismfpar=%f;
		if (txt~="") then
			[value,ierr]=evstr(txt);
			if (ierr==0) then
				n=size(rule,2);
				if ((n==0)|(n==size(value,2))) then
					rule=[rule;value];
				end
			end
		end
	end
end
fls.rule=rule;
mclose(fd);

endfunction

