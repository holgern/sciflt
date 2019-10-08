function plotsurf(fls,ivar,ovar,vivar,npart,mod)
//Plot fls output surface
//Calling Sequence
//plotsurf( fls [, ivar , ovar , [vivar [,npart [,mod]]]])
//Parameters
//fls:fls structure.
// ivar:vector, input variables.
// ovar:scalar, output variable.
// vivar:vector, value if input variable
// npart:vector, number of partitions domain for each input variable.
// mod:scalar, display mode.
//Description
//      
//          <literal>plotsurf </literal> plot the output fls surface. In the x axis was
//     plotted the <literal>ivar(1)</literal> input variable, in the y axes the
//     <literal>ivar(2)</literal> input variable and in the z axes the
//     <literal>ovar</literal> output variable.
//     
//     The rest of input variables take the
//     value defined in <literal>vivar</literal>, <literal>vivar(ivar(1))</literal> and
//     <literal>vivar(ivar(2))</literal> are generated internally, so this values don't
//     care.
// 
//     
//      The user can set the number of partitions for each input variable with
//     <literal>npart</literal> parameter. The default value for inputs is 21
//     partitions.
// 
//     
//       The <literal>mod</literal> parameter mean: 1 for grayscale, 2 for
//     jetcolormap, 3 for hotcolormap and 4 for internal color map.
// 
//     
//     If <literal>plotsurf</literal> is called with only <literal>fls</literal>
//     parameter, the a GUI to select inputs and outputs are launched.
//   
//Examples
// // READ A FLS
// fls=loadfls(flt_path()+"demos/fan1.fls");
// scf();clf();
// plotsurf(fls,[1 2],1);
// 
// scf();clf();
// plotsurf(fls,1,1,[0 50]);
// 
// scf();clf();
// plotsurf(fls)
//See also
//plotvar
//printrule
//newfls
//fls_structure
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// PLOT OUTPUT SURfACE OF A FLS
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

if (argn(2)==1) then
	if (typeof(fls)=="fls") then
		fls_filename=strsubst(TMPDIR+'/plsrf.txt','\','/');		
		[fd,err]=mopen(fls_filename,"w");
		mfprintf(fd,"<s>fls\n");
		mfprintf(fd,"<f>%s\n",fls.name);
		for i=1:length(fls.input)
			mfprintf(fd,"<i>%s\n",fls.input(i).name);
		end
		for i=1:length(fls.output)
			mfprintf(fd,"<o>%s\n",fls.output(i).name);
		end
		mclose(fd);
		TCL_EvalStr("sciFLTPlotSurf "+fls_filename);

		while %t,
			realtimeinit(0.1);realtime(0.1);
			TCL_EvalStr("set IsPlotsurft [winfo exist .sciFLTPlotSurf]");
			if TCL_GetVar("IsPlotsurft")=="0" then
				break
			end
		end		
	end

else
	if (argn(2)<3) then
		error("plotsurf need at least 3 parameters.");
	end

	// GET SOME IMPORTAN INFORMATION
	ninputs=length(fls.input);
	noutpus=length(fls.output);
	
	if (find(ivar>ninputs)~=[])|(length(ivar)>2) then
		error("Incorrect input variable to plot");
	end

	if (find(ovar>noutpus)~=[])|(length(ovar)>1) then
		error("Incorrect output variable to plot");
	end

	// SET DEFAULT VALUES
        if argn(2)<4 then
                 vivar=zeros(1,ninputs);
        end;
	npart2=[21 21];
	if argn(2)>4 then
		if (length(npart)==1) then
			npart2=[npart npart];
		else
			npart2=npart(1:2);
		end
	end

	if argn(2)<6 then
		mod=4;
	end

	range1=fls.input(ivar(1)).range;
	DOM1=linspace(min(range1),max(range1),npart2(1))';
	if length(ivar)==2 then
		range2=fls.input(ivar(2)).range;
		DOM2=linspace(min(range2),max(range2),npart2(2))';
		DXY=ones(npart2(1)*npart2(2),1).*.vivar;
		DXY(:,ivar)=genspace(DOM1,DOM2);
		LE=fls.input(ivar(1)).name+"@"+fls.input(ivar(2)).name+"@"+fls.output(ovar).name;
		mod2D=%f;
	else
		DXY=ones(npart2(1),1).*.vivar;
		DXY(:,ivar)=DOM1;	
		mod2D=%t;
	end


	// EVALUATE FLS

	Z=evalfls(DXY,fls);
        //Z=evalfis(DXY,fls);
	Z=Z(:,ovar);

	// NOW PLOT THE OUTPUT
	if (mod2D) then
		// ONE INPUT ONE OUTPUT
		plot2d(DOM1,Z);
		xtitle('',fls.input(ivar(1)).name,fls.output(ovar).name);
	else	
		Z=matrix(Z,npart2(2),npart2(1))';				
		if (mod>10) then
			Sgrayplot(DOM1,DOM2,Z);
			xtitle("",fls.input(ivar(1)).name,fls.input(ivar(2)).name);
		else
			plot3d(DOM1,DOM2,Z,theta=230,alpha=30,leg=LE);
		end

		h=get("hdl");
		f=get("current_figure");
				
		if (mod==1)|(mod==11) then
			f.color_map=graycolormap(128);
		elseif (mod==2)|(mod==12) then
			f.color_map=jetcolormap(128);
		elseif (mod==3)|(mod==13) then
			f.color_map=hotcolormap(128);
		elseif (mod==4)|(mod==14) then
			f.color_map=[linspace(0,1,128)' linspace(1,0,128)' ones(128,1)];
		end		
		if (mod<10) then
			h.color_flag=1;
		end
		a=gca();
		a.cube_scaling="on";
		a.z_label.font_angle=-90;
	end

end

endfunction


