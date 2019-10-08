function editfls(varargin)
//GUI fls editor.
//Calling Sequence
//y=evalfls(x,fls,[npev])
//Parameters
//fls:fls structure to evaluate
//Description
//    
//          <literal>editfls </literal> is an embedded scilab fuzzy logic system editor
//     written in TCL/TK.
//     
//       The main window have four zones:
//       
//       <itemizedlist>
//          <listitem>
//                <emphasis role="bold">Menu</emphasis>: At top level. This zone have the <emphasis role="bold">File</emphasis>,
//         <emphasis role="bold">View</emphasis> and <emphasis role="bold">Help</emphasis> command.   
//          </listitem>
//          <listitem>
//                <emphasis role="bold">Center left window</emphasis> (main selection) : Show a tree of
//         current editing structure. With one click the state change and show
//         the associated information or possible parameters in the center right
//         window.
//          </listitem>
//          <listitem>
//                <emphasis role="bold">Center right window</emphasis> (change information): Display
//         information and parameters. This is the zone of editing.
//          </listitem>     
//          <listitem>       
//                <emphasis role="bold">Status bar</emphasis>: Show some important information about the
//         editor status, also, warnings to the user.
//          </listitem>
//       </itemizedlist>
//     
//       If <literal>editfls</literal> is called without any argument, then only open
//     the editor.
//     
//Examples
//fls=newfls("m","Example");
// editfls fls
//See also
//fls_structure
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Edit a fls structure using internal editor
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

nav=sciFLTgetFLS();

TCL_EvalStr("sciFLTEditorInit");
nf=TCL_GetVar("sciFLTEditorTable(curfileidx)");
TCL_EvalStr("incr sciFLTEditorTable(curfileidx)");
filename=strsubst(TMPDIR+"/fls_to_edit"+nf+".fls","\","/");
if (argn(2)==0) then
	TCL_EvalStr("sciFLTEditor");
else
	if (typeof(varargin(1))=="fls") then
		write(%io(2),"Please wait");
		savefls(varargin(1),filename);
		TCL_EvalStr("sciFLTEditor """+filename+""" yes");
	else
		nam=varargin(1);
		[a,b]=grep(nav,nam);
		if (a~=[]) then
			write(%io(2),"Please wait");
			savefls(evstr(varargin(1)),filename);
			TCL_EvalStr("sciFLTEditor """+filename+""" yes");
		else		
			error("The argument no are a fls!");
		end
	end
end

endfunction

