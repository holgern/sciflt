// ====================================================================
// Allan CORNET
// Simon LIPP
// INRIA 2008
// This file is released into the public domain
// ====================================================================

src_dir = get_absolute_file_path("builder_src.sce");

//tbx_builder_src_lang("fortran", src_dir);
tbx_builder_src_lang("c_scilab", src_dir);
tbx_builder_src_lang("c_xcos", src_dir);

clear tbx_builder_src_lang;
clear src_dir;
