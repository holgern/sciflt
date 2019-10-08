function pa=flt_path()
    //Return directory path name of sciFLT toolbox.
    //Calling Sequence
    //path=flt_path()
    //Description
    //flt_pathreturn directory path name of sciFLT toolbox.
    // Authors
    // Jaime Urzua Grez
    // Holger Nahrstaedt


    // ----------------------------------------------------------------------
    // Return the path of sciFLT
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
    // 2019-10-08 Change to Scilab calling.
    // ----------------------------------------------------------------------

    //pa=TCL_GetVar("sciFLTpath");    
    pa = [];
    if isdef('sciFLTlib') then
        [m, mp] = libraryinfo('sciFLTlib');
        pa = pathconvert(fullpath(mp + "/../"), %t, %t);
    end
endfunction
