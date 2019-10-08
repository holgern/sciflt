/* -----------------------------------------------------------------------
 * SCICOS Complement COMPUTATION BLOCK
 * -----------------------------------------------------------------------
 * This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
 * Copyright (C) @YEARS@ Jaime Urzua Grez
 * mailto:jaime_urzua@yahoo.com
 * 
 * 2011 Holger Nahrstaedt
 * -----------------------------------------------------------------------
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * -----------------------------------------------------------------------
 * CHANGES :
 * 2004-11-08 Change error messages, Add flag detection -> The routine can
 *            be better!
 * -----------------------------------------------------------------------
 */

#include "api_scilab.h"
#include "Scierror.h"
#include <machine.h>
#include <scicos_block4.h>

#ifdef _WIN32
#include "MALLOC.h"
#endif
    
extern int F2C(mfeval2) (int *mfid, double *x, int *m, int *n, double *par, double *y, int *ierr);

void smfeval(scicos_block *block,int flag) 
{
	int nrpar=block->nrpar;
	int* ipar = GetIparPtrs(block);
	double* rpar = GetRparPtrs(block);
	int nu = GetNin(block);
	double * u = GetInPortPtrs(block,1);
	double * y = GetOutPortPtrs(block,1);
        int ierr;
	int one=1;
	int ipar1=ipar[0];
if (flag==1) {
		/* Make the real work */
	F2C(mfeval2)(&ipar1,u,&nu,&one,rpar,y,&ierr);
	

	if (ierr!=0) { flag=-999; }
}			



}

