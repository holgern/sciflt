// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function sciFLT_buildToolbox()

    mode(-1);
    lines(0);
    try
        getversion("scilab");
    catch
        error(gettext("Scilab 5.0 or more is required."));  
    end;
    // ====================================================================
    if ~with_module("development_tools") then
        error(msprintf(gettext("%s module not installed."),"development_tools"));
    end
    // ====================================================================
    TOOLBOX_NAME = "sciFLT";
    TOOLBOX_TITLE = "FuzzyToolbox";
    // ====================================================================
    toolbox_dir = get_absolute_file_path("builder.sce");


    if ~isdir(toolbox_dir+filesep()+"images"+filesep()+"h5")
        [status, msg] = mkdir(toolbox_dir+filesep()+"images"+filesep()+"h5");
	if and(status <> [1 2])
	  error(msg);
	end
    end
    
    tbx_builder_macros(toolbox_dir);
    tbx_builder_src(toolbox_dir);
    tbx_builder_gateway(toolbox_dir);
    tbx_builder_help(toolbox_dir);
    tbx_build_loader(toolbox_dir);
    tbx_build_cleaner(toolbox_dir);


endfunction 

sciFLT_buildToolbox();
clear sciFLT_buildToolbox;
