// ====================================================================
// Allan CORNET
// Simon LIPP
// INRIA 2008
// This file is released into the public domain
// ====================================================================



files=['complement.c';...
        'defuzzm.c';...
        'flsengine.c';...
        'mfs.c';...
        'optfls.c';...
        'snorm.c';...
        'tnorm.c';...
        'util1.c';...
];

LIBS = [];
LDFLAGS = '';

// if getos() == 'Windows' then
// 	  LDFLAGS = SCI + '/bin/elementary_functions_f.lib';
// end
//CFLAGS = '-D__USE_DEPRECATED_STACK_FUNCTIONS__';
CFLAGS = ' -lf2c';
tbx_build_src(['sciFLT_c_scilab'], files, 'c', ..
              get_absolute_file_path('builder_c.sce'),LIBS,LDFLAGS,CFLAGS);

clear tbx_build_src files;
