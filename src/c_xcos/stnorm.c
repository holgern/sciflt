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
    
extern int F2C(ctnorm) (char *class1, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

void stnorm(scicos_block *block,int flag) 
{
	int nrpar=block->nrpar;
	int* ipar = GetIparPtrs(block);
	double* rpar = GetRparPtrs(block);
	int nu = GetNin(block);
	double * u = GetInPortPtrs(block,1);
	double * y = GetOutPortPtrs(block,1);
	int one=1;
        int ierr;
if (flag==1) {
		/* Make the real work */
	if (ipar[0]==0)
	   //C2F(ctnorm)("dubois",u,1,nu,rpar,nrpar,y,&ierr);
	   F2C(ctnorm)("dubois",u,&one,&nu,rpar,&nrpar,y,&ierr);		
	else if (ipar[0]==1)
	  //C2F(ctnorm)("yager",u,1,nu,rpar,nrpar,y,&ierr);
	   F2C(ctnorm)("yager",u,&one,&nu,rpar,&nrpar,y,&ierr);
	else if (ipar[0]==2)
	  //C2F(ctnorm)("dsum",u,1,nu,rpar,nrpar,y,&ierr);
	   F2C(ctnorm)("dprod",u,&one,&nu,rpar,&nrpar,y,&ierr);
	else if (ipar[0]==3)
	  //C2F(ctnorm)("esum",u,1,nu,rpar,nrpar,y,&ierr);
	   F2C(ctnorm)("eprod",u,&one,&nu,rpar,&nrpar,y,&ierr);
	else if (ipar[0]==4)
	  //C2F(ctnorm)("asum",u,1,nu,rpar,nrpar,y,&ierr);
	   F2C(ctnorm)("aprod",u,&one,&nu,rpar,&nrpar,y,&ierr);
	else if (ipar[0]==5)
	  //C2F(ctnorm)("max",u,1,nu,rpar,nrpar,y,&ierr);
	   F2C(ctnorm)("min",u,&one,&nu,rpar,&nrpar,y,&ierr);
	else
	  y[0]=0;

	if (ierr!=0) { flag=-999; }
}			



}

