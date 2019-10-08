function fls=newfls(fls_type,fls_name,fls_SNorm,fls_TNorm,fls_Comp,fls_defuzzMethod)
//Create a new fls structure.
//Calling Sequence
//fls=newfls([fls_type [,fls_name [,fls_SNorm [,fls_TNorm [,fls_Comp [,fls_defuzzMethod]]]]]])
//Parameters
//fls_type:string, fuzzy logic type ("m" - Mamdani or "ts" - Takagi-Sugeno).
// fls_name:string, internal tag name.
// fls_SNorm:string, S-Norm Class.
// fls_TNorm:string, T-Norm Class.
// fls_Comp:string, Complement Class.
// fls_defuzzMethod:string, Defuzzification Method.
//Description
//      
//          <literal>newfls </literal> create a new fuzzy logic structure.
// 
//      The default structure for Mamdani is: Algebaric sum S-Norm Class,
//     Algebraic product T-Norm Class, One (classic) Complement Class and
//     Centroide Defuzzification Method.
// 
//     
//      The default structure for Takagi-Sugeno is: Algebaric sum S-Norm Class,
//     Algebraic product T-Norm Class, One (classic) Complement Class and
//     Weigthed Average Defuzzification Method.
//
//Examples
// // Create new Mamdani with default values
//fls=newfls('m')
// // Create new Takagi-Sugeno with non-default values.
// fls=newfls('ts','demo','dsum','dprod','one','wtsum')
//See also
//fls_structure
//snorm
//tnorm
//complement
//defuzzm
//editfls
//addvar
//addmf
//
// Authors
// Jaime Urzua Grez
// Holger Nahrstaedt


// ----------------------------------------------------------------------
// Create a new Fuzzy Logic System
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

// CREATE INTERNAL STRUCTURE
fls=tlist(['fls','name','comment','type','SNorm','SNormPar','TNorm','TNormPar','Comp','CompPar','ImpMethod','AggMethod','defuzzMethod','input','output','rule'],'','','','',[],'',[],'',[],'','','',list(),list(),[]);

// FILL WITH DEFAULT INFORMATION
fls.name="unknow";
fls.comment="";
fls.type="ts";
fls.SNorm="asum";
fls.SNormPar=0;
fls.TNorm="aprod";
fls.TNormPar=0;
fls.Comp="one";
fls.CompPar=0;
fls.defuzzMethod="wtaver";
fls.ImpMethod = 'min';
fls.AggMethod = 'max';

// THE TYPE
if argn(2)>=1 then
	if (fls_type=='m') then
		fls.type='m';
		fls.defuzzMethod='centroide';
        fls.SNorm="max";
        fls.TNorm="min";
	elseif (fls_type=='ts') then
		// DO NOTHING BECAUSE USE DEFAULT VALUES
	else
		error('Unknow fls type.');
	end
end

// THE NAME
if argn(2)>=2 then
	fls.name=string(fls_name);
end

// THE S-NORM
if argn(2)>=3 then
	fls.SNorm=string(fls_SNorm);
end

// THE T-NORM
if argn(2)>=4 then
	fls.TNorm=string(fls_TNorm);
end

// COMPLEMENT
if argn(2)>=5 then
	fls.Comp=string(fls_Comp);
end

// DEFUZZIFICATION
if argn(2)>=6 then
	fls.defuzzMethod=string(fls_defuzzMethod);
end

endfunction
