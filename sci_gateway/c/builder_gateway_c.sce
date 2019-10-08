// ====================================================================
// Allan CORNET
// Simon LIPP
// INRIA 2008
// This file is released into the public domain
// ====================================================================


table=[
	"trimf","inter_anymf";
	"trapmf","inter_anymf";
	"gaussmf","inter_anymf";
	"gauss2mf","inter_anymf";
	"sigmf","inter_anymf";
	"psigmf","inter_anymf";
	"dsigmf","inter_anymf";
	"gbellmf","inter_anymf";
	"smf","inter_anymf";
	"zmf","inter_anymf";
	"pimf","inter_anymf";
	"constant","inter_anymf";
	"linear","inter_anymf";
	"mfeval","inter_mfeval";
	"complement","inter_complement";
	"snorm","inter_snorm";
	"tnorm","inter_tnorm";
	"defuzzm","inter_defuzzm";
	"flsencode","inter_flsencode";
	"evalfls","inter_evalfls";
	"repvec","inter_repvec";
	"fltmulnor","inter_fltmulnor";
	"fltsumnor","inter_fltsumnor";
	"repvecc","inter_repvecc";
	"sp01","inter_sp01";
//	"sp02","inter_sp02"
];


//CFLAGS = '-D__USE_DEPRECATED_STACK_FUNCTIONS__';
CFLAGS = '';

files = ['inter_sciFLT.c','flsencode6.c'];

LIBS=['../../src/c_xcos/libsciFLT_c_xcos','../../src/c_scilab/libsciFLT_c_scilab'];
LDFLAGS = '';

// if getos() == 'Windows' then
//     LDFLAGS = SCI + '/bin/elementary_functions.lib ' + SCI + '/bin/elementary_functions_f.lib';
// end


tbx_build_gateway('sciFLT_gateway_c', table, files, ..
                  get_absolute_file_path('builder_gateway_c.sce'), ..
                  LIBS,LDFLAGS,CFLAGS);

clear tbx_build_gateway table files LIBS LDFLAGS;
