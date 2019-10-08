/* ------------------------------------------------------------------------
* This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
* Copyright (C) @YEARS@ Jaime Urzua Grez
* mailto:jaime_urzua@yahoo.com
* 
* 2011 Holger Nahrstaedt
* 2019 Tan Chin Luh
* ------------------------------------------------------------------------
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
* ------------------------------------------------------------------------
* CHANGES:
* 2004-11-04 Delete some variable initialization, clean code
*            Use more optimized memory subroutines
* 2006-08-28 Use SCILAB memory allocation
* 2019-09-24 Updating source and gateway to work with Scilab 6.0.x
* ------------------------------------------------------------------------
*/

#include "api_scilab.h"
#include "Scierror.h"
#include <sciprint.h>
#include "machine.h"
#include "cvstr.h"

#ifdef _WIN32
#include "MALLOC.h"
#endif

extern int F2C(complement) (char *class1, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

/* ---------------------------------------------------------------- */
/* INTERFACE TO complement                                          */
/* ---------------------------------------------------------------- */
int inter_complement(char *fname,void* pvApiCtx)

{
	SciErr sciErr;
	int* piAddr = NULL;
	int iType   = 0;
	int iRet    = 0;

	int mx,nx,extra,icero=0,mp,np,ierr;
	double dcero=0.0;

	//CheckRhs(2,3);
	CheckInputArgument(pvApiCtx, 2, 3);
	//CheckLhs(1,1);
	CheckOutputArgument(pvApiCtx, 1, 1);


	//GetRhsVar(1,"d",&mx,&nx,&lx);

	//sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	//if (sciErr.iErr)
	//{
	//	printError(&sciErr, 0);
	//	return 0;
	//}
	double* lx = NULL;
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if(isDoubleType(pvApiCtx, piAddr))
	{
			sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mx, &nx, &lx);
	}

	//GetRhsVar(2,"c",&mc,&nc,&lc);
	char* lc = NULL;
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if(isStringType(pvApiCtx, piAddr))
	{
		if(isScalar(pvApiCtx, piAddr))
		{
			iRet = getAllocatedSingleString(pvApiCtx, piAddr, &lc);
		}
		else {
			sciprint("Not Scalar Type\n");
		}
	}

	extra=0;
	if ((strncmp(lc,"sugeno",6)==0) | (strncmp(lc,"yager",5)==0)) {
		extra =1;
	}
	double* ly = NULL;
	ly = (double*)malloc(sizeof(double) * mx * nx);
	double* lp = NULL;

	if (extra==0) {
		//CreateVar(3,"d",&mx,&nx,&ly);
		// F2C(complement)(cstk(lc),stk(lx),&mx,&nx,&dcero,&icero,stk(ly),&ierr);	
		F2C(complement)(lc, lx, &mx, &nx, &dcero, &icero, ly, &ierr);
		sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, nx, ly);
	} else {
		mp=0;
		if (Rhs==3) {
			//GetRhsVar(3,"d",&mp,&np,&lp);
			sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
			if(isDoubleType(pvApiCtx, piAddr))
			{
					sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mp, &np, &lp);
			}
		}
		if (mp!=1) {
			Scierror(999,"This complement class need a row vector of parameters.");
			ierr=1;
		} else {
			//CreateVar(4,"d",&mx,&nx,&ly);
			//double* ly	= NULL;
			F2C(complement)(lc, lx, &mx, &nx, lp, &np, ly, &ierr);
			sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, nx, ly);
		}
	}

	//if (ierr==0) {
	//	//LhsVar(1)=3+extra;
	//	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	//}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO ANY REGISTERED MEMBER FUNCTION                      */
/* ---------------------------------------------------------------- */

int inter_anymf(char * fname, void* pvApiCtx)
{
	SciErr sciErr;
	int* piAddr = NULL;
	//int mx,nx,lx,mp,np,lp,ly,ierr,one;
	int mx, nx, mp, np, ierr, one;
	double *lx = NULL;
	double *lp = NULL;
	double *ly = NULL;

	//CheckRhs(2,2);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);


	//GetRhsVar(1,"d",&mx,&nx,&lx);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mx, &nx, &lx);
	}

	//GetRhsVar(2,"d",&mp,&np,&lp);
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mp, &np, &lp);
	}
	
	if (mp!=1) {
		Scierror(999,"This member function need a row vector parameters.");
		ierr=1;
	} else {
		if ((strncmp(fname,"linear",6)==0) | (strncmp(fname,"constant",8)==0)) {
			one=1;
		} else {
			one=nx;
		}

		ly = (double*)malloc(sizeof(double) * mx * one);
		//CreateVar(3,"d",&mx,&one,&ly);
		//F2C(mfeval)(fname,stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);	
		F2C(mfeval)(fname, lx, &mx, &nx, lp, &np, ly, &ierr);
		sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, one, ly);
	}

	if (ierr==0) {
		//LhsVar(1)=3;
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	}

	return 0;
}

extern int F2C(mfeval) (char *mfname, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

/* ---------------------------------------------------------------- */
/* INTERFACE TO mfeval                                              */
/* ---------------------------------------------------------------- */
int inter_mfeval(char * fname, void* pvApiCtx)

{
	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;
	//int mx,nx,lx,mmf,nmf,lmf,mp,np,lp,ly,ierr,one,i;
	int mx, nx, mmf, nmf, mp, np, ierr, one, i;
	double *lx = NULL;
	double *lp = NULL;
	double *ly = NULL;

	//int m_hedge,n_hedge,l_hedge,m_not_flag,n_not_flag,l_not_flag;
	int m_hedge, n_hedge, m_not_flag, n_not_flag;
	double *l_hedge = NULL;
	double *l_not_flag = NULL;

	//CheckRhs(3,5);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 3, 5);
	CheckOutputArgument(pvApiCtx, 1, 1);

	//GetRhsVar(1,"d",&mx,&nx,&lx);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mx, &nx, &lx);
	}

	//GetRhsVar(2,"c",&mmf,&nmf,&lmf);
	//GetRhsVar(2,"c",&mc,&nc,&lc);
	char* lmf = NULL;
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (isStringType(pvApiCtx, piAddr))
	{
		if (isScalar(pvApiCtx, piAddr))
		{
			iRet = getAllocatedSingleString(pvApiCtx, piAddr, &lmf);
		}
		else {
			sciprint("Not Scalar Type\n");
		}
	}

	//GetRhsVar(3,"d",&mp,&np,&lp);
	sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mp, &np, &lp);
	}

	//if (Rhs>=4)
	//  GetRhsVar(4,"d",&m_hedge,&n_hedge,&l_hedge);
	if (Rhs>=4)
	{
		sciErr = getVarAddressFromPosition(pvApiCtx, 4, &piAddr);
		if (isDoubleType(pvApiCtx, piAddr))
		{
			sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &m_hedge, &n_hedge, &l_hedge);
		}
	}
	 
	//
	//if (Rhs>=5)
	//  GetRhsVar(5,"d",&m_not_flag,&n_not_flag,&l_not_flag);
	if (Rhs >= 5)
	{
		sciErr = getVarAddressFromPosition(pvApiCtx, 4, &piAddr);
		if (isDoubleType(pvApiCtx, piAddr))
		{
			sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &m_not_flag, &n_not_flag, &l_not_flag);
		}
	}


	////////////////

	if (mp!=1) {
		Scierror(999,"This member function need a row vector parameters.");
		ierr=1;
	} else {
		if ((strncmp(lmf,"linear",6)==0) | (strncmp(lmf,"constant",8)==0)) {
			one=1;
		} else {
			one=nx;
		}
		//CreateVar(Rhs+1,"d",&mx,&one,&ly);
		//F2C(mfeval)(cstk(lmf),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
		ly = (double*)malloc(sizeof(double) * mx * one);
		F2C(mfeval)(lmf, lx, &mx, &nx, lp, &np, ly, &ierr);
		sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, one, ly);

		//if (strncmp(cstk(lmf),"linear",6)==0)  {
		//  ;
		//} else if (strncmp(cstk(lmf),"constant",8)==0) {
		//  if (Rhs>=5 && m_not_flag==1 && n_not_flag==1 && stk(l_not_flag)[0])
		//    for(i=0;i<mx*one;i++)
		//      stk(ly)[i]=1.0 - stk(ly)[i];
		//	
		//} else {
		//  if (Rhs>=4 && m_hedge==1 && n_hedge==1 && stk(l_hedge)[0]>0.001 )
		//    for(i=0;i<mx*one;i++)
		//      stk(ly)[i]=pow(stk(ly)[i],stk(l_hedge)[0]);
		//  
		//  if (Rhs>=5 && m_not_flag==1 && n_not_flag==1 && stk(l_not_flag)[0])
		//    for(i=0;i<mx*one;i++)
		//      stk(ly)[i]=1.0 - stk(ly)[i];
		 
		if (strncmp(lmf,"linear",6)==0)  {
		  ;
		} else if (strncmp(lmf,"constant",8)==0) {
		  if (Rhs>=5 && m_not_flag==1 && n_not_flag==1 && *l_not_flag)
			for(i=0;i<mx*one;i++)
			  *(ly+i)=1.0 - *(ly + i);
			
		} else {
		  if (Rhs>=4 && m_hedge==1 && n_hedge==1 && *l_hedge>0.001 )
			for(i=0;i<mx*one;i++)
				*(ly + i) =pow(*(ly + i),*l_hedge);
		  
		  if (Rhs>=5 && m_not_flag==1 && n_not_flag==1 && *l_not_flag)
			for(i=0;i<mx*one;i++)
				*(ly + i) =1.0 - *(ly + i);

			
		}
	}

	if (ierr==0) {
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	}

	return 0;
}


/* ---------------------------------------------------------------- */
/* INTERFACE TO tnorm                                               */
/* ---------------------------------------------------------------- */
extern int F2C(ctnorm) (char *class1, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

int inter_tnorm(char * fname, void* pvApiCtx)

{
	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;
	//int mx,nx,lx,mc,nc,lc,extra,ly,icero=0,one=1,mp,np,lp,ierr;
	int mx, nx, mc, nc, extra, icero = 0, one = 1, mp, np, ierr;
	double *lx = NULL;
	double *lp = NULL;
	double *ly = NULL;
	//double *lc = NULL;

	//double dcero=0.0;
	//CheckRhs(2,3);
	//CheckLhs(1,1);
	double dcero = 0.0;
	CheckInputArgument(pvApiCtx, 2, 3);
	CheckOutputArgument(pvApiCtx, 1, 1);

	//GetRhsVar(1,"d",&mx,&nx,&lx);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mx, &nx, &lx);
	}

	//GetRhsVar(2,"c",&mc,&nc,&lc);
	char* lc = NULL;
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (isStringType(pvApiCtx, piAddr))
	{
		if (isScalar(pvApiCtx, piAddr))
		{
			iRet = getAllocatedSingleString(pvApiCtx, piAddr, &lc);
		}
		else {
			sciprint("Not Scalar Type\n");
		}
	}


	extra=0;
	if ((strncmp(lc,"dubois",6)==0) | (strncmp(lc,"yager",5)==0)) {
		extra =1;
	}
	
	if (extra==0) {
		//CreateVar(3,"d",&mx,&one,&ly);
		//F2C(ctnorm)(cstk(lc),stk(lx),&mx,&nx,&dcero,&icero,stk(ly),&ierr);
		ly = (double*)malloc(sizeof(double) * mx * one);
		F2C(ctnorm)(lc, lx, &mx, &nx, &dcero, &icero, ly, &ierr);
		sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, one, ly);


	} else {
		mp=0;
		if (Rhs==3) {
			//GetRhsVar(3,"d",&mp,&np,&lp);
			sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
			if (isDoubleType(pvApiCtx, piAddr))
			{
				sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mp, &np, &lp);
			}
		}

		if (mp!=1) {
			Scierror(999,"This t-norm class need a row vector of parameters.");
			ierr=1;
		} else {
			//CreateVar(4,"d",&mx,&one,&ly);
			//F2C(ctnorm)(cstk(lc),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
			ly = (double*)malloc(sizeof(double) * mx * one);
			F2C(ctnorm)(lc, lx, &mx, &nx, lp, &np, ly, &ierr);
			sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, one, ly);

		}
	}

	if (ierr==0) {
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	}

	return 0;
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO snorm                                               */
/* ---------------------------------------------------------------- */
extern int F2C(csnorm) (char *class1, double *x, int *m, int *n, double *par, int *npar, double *y, int *ierr);

int inter_snorm(char * fname, void* pvApiCtx)

{
	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;
	
	int mx,nx,mc,nc,extra,icero=0,one=1,mp,np,ierr;
	double *lx = NULL;
	double *lp = NULL;
	double *ly = NULL;

	double dcero=0.0;
	//CheckRhs(2,3);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 2, 3);
	CheckOutputArgument(pvApiCtx, 1, 1);

	//GetRhsVar(1,"d",&mx,&nx,&lx);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mx, &nx, &lx);
	}

	//GetRhsVar(2,"c",&mc,&nc,&lc);
	char* lc = NULL;
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (isStringType(pvApiCtx, piAddr))
	{
		if (isScalar(pvApiCtx, piAddr))
		{
			iRet = getAllocatedSingleString(pvApiCtx, piAddr, &lc);
		}
		else {
			sciprint("Not Scalar Type\n");
		}
	}

	//extra=0;
	//if ((strncmp(cstk(lc),"dubois",6)==0) | (strncmp(cstk(lc),"yager",5)==0)) {
	//	extra =1;
	//}
	//
	//if (extra==0) {
	//	CreateVar(3,"d",&mx,&one,&ly);
	//	F2C(csnorm)(cstk(lc),stk(lx),&mx,&nx,&dcero,&icero,stk(ly),&ierr);
	//} else {
	//	mp=0;
	//	if (Rhs==3) {
	//		GetRhsVar(3,"d",&mp,&np,&lp);
	//	}

	//	if (mp!=1) {
	//		Scierror(999,"This s-norm class need a row vector of parameters.");
	//		ierr=1;
	//	} else {
	//		CreateVar(4,"d",&mx,&one,&ly);
	//		F2C(csnorm)(cstk(lc),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
	//	}
	//}

	//if (ierr==0) {
	//	LhsVar(1)=3+extra;
	//}
	extra = 0;
	if ((strncmp(lc, "dubois", 6) == 0) | (strncmp(lc, "yager", 5) == 0)) {
		extra = 1;
	}
	if (extra == 0) {
		ly = (double*)malloc(sizeof(double) * mx * one);
		F2C(csnorm)(lc, lx, &mx, &nx, &dcero, &icero, ly, &ierr);
		sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, one, ly);
	}
	else {
		mp = 0;
		if (Rhs == 3) {
			//GetRhsVar(3,"d",&mp,&np,&lp);
			sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
			if (isDoubleType(pvApiCtx, piAddr))
			{
				sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mp, &np, &lp);
			}
		}

		if (mp != 1) {
			Scierror(999, "This t-norm class need a row vector of parameters.");
			ierr = 1;
		}
		else {
			//CreateVar(4,"d",&mx,&one,&ly);
			//F2C(ctnorm)(cstk(lc),stk(lx),&mx,&nx,stk(lp),&np,stk(ly),&ierr);
			ly = (double*)malloc(sizeof(double) * mx * one);
			F2C(csnorm)(lc, lx, &mx, &nx, lp, &np, ly, &ierr);
			sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, mx, one, ly);

		}
	}

	if (ierr == 0) {
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	}


	return 0;
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO defuzzm                                             */
/* ---------------------------------------------------------------- */
extern int F2C(defuzzm) (char *method, double *x, int *m, double *y, double *ou, int *ierr);
int inter_defuzzm(char * fname, void* pvApiCtx)

{
	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;

	int mx, nx;
	double *lx = NULL;
	int my, ny;
	double *ly =NULL;
	int mmethod, nmethod;
	char *lmethod;
	int ione = 1;
	double *lout;
	int ierr;

	//CheckRhs(3,3);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 1, 1);

	//GetRhsVar(1,"d",&mx,&nx,&lx);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &mx, &nx, &lx);
	}
	
	//GetRhsVar(2,"d",&my,&ny,&ly);
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &my, &ny, &ly);
	}
	
	//GetRhsVar(3,"c",&mmethod,&nmethod,&lmethod);
	sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
	if (isStringType(pvApiCtx, piAddr))
	{
		if (isScalar(pvApiCtx, piAddr))
		{
			iRet = getAllocatedSingleString(pvApiCtx, piAddr, &lmethod);
		}
		else {
			sciprint("Not Scalar Type\n");
		}
	}


	if (mx!=my) {
		Scierror(999,"Column vector must have the same size!");
		ierr=1;
	} else {
		if ((nx!=1)|(ny!=1)) {
			Scierror(999,"The first two parameters must be a column vector");
			ierr=1;
		} else {
			//CreateVar(4,"d",&ione,&ione,&lout);
			//F2C(defuzzm)(cstk(lmethod),stk(lx),&mx,stk(ly),stk(lout),&ierr);
			lout = (double*)malloc(sizeof(double) * ione * ione);
			F2C(defuzzm)(lmethod, lx, &mx, ly, lout, &ierr);
			sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, ione, ione, lout);
		}
	}	

	if (ierr==0) {
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	}
	return (0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO repvecc                                             */
/* ---------------------------------------------------------------- */
extern int F2C(repvecc) (double *y, double *x, int *m, int *n);
int inter_repvecc(char * fname, void* pvApiCtx)

{
	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;

	int d, m;
	double *n = NULL;
	double *x = NULL;
	double *y = NULL;
	//CheckRhs(2,2);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	//GetRhsVar(1,"i",&d,&d,&n);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &d, &d, &n);
	}
	//sciprint("%i , %i\n", *n, n);
	//GetRhsVar(2,"d",&m,&d,&x);
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &m, &d, &x);
	}
	

	int n2 = (int)*n;
	////CreateVar(3,"d",&m,istk(n),&y);
	////F2C(repvecc)(stk(y),stk(x),&m,istk(n));
	y = (double*)malloc(sizeof(double) * m * n2);

	F2C(repvecc)(y, x, &m, &n2);
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, m, n2, y);

	////LhsVar(1)=3;
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return(0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO repvec                                              */
/* ---------------------------------------------------------------- */
extern int F2C(repvec) (double *y, double *x, int *m, int *n);
int inter_repvec(char * fname, void* pvApiCtx)
{
	//int d,m,n,x,y;
	//CheckRhs(2,2);
	//CheckLhs(1,1);
	//GetRhsVar(1,"i",&d,&d,&m);
	//GetRhsVar(2,"d",&d,&n,&x);
	//CreateVar(3,"d",istk(m),&n,&y);
	//F2C(repvec)(stk(y),stk(x),istk(m),&n);
	//LhsVar(1)=3;
	//return(0);
	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;

	int d, n;
	double *m = NULL;
	double *x = NULL;
	double *y = NULL;
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &d, &d, &m);
	}
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &d, &n, &x);
	}
	int m2 = (int)*m;
	//CreateVar(3,"d",istk(m),&n,&y);
	//F2C(repvec)(stk(y),stk(x),istk(m),&n);
	y = (double*)malloc(sizeof(double) * n * m2);
	F2C(repvec)(y, x, &m2, &n);
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, m2, n, y);

	////LhsVar(1)=3;
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
return(0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO fltmulnor                                           */
/* ---------------------------------------------------------------- */
extern int F2C(fltmulnor) (double *x, int *m, int *n, double *y);
int inter_fltmulnor(char *fname, void* pvApiCtx)

{
	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;

	int m, n, one = 1;
	double *x = NULL;
	double *y = NULL;

	//CheckRhs(1,1);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);
	
	//GetRhsVar(1,"d",&m,&n,&x);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &m, &n, &x);
	}
	//CreateVar(2,"d",&m,&one,&y);
	//F2C(fltmulnor)(stk(x),&m,&n,stk(y));
	y = (double*)malloc(sizeof(double) * m * one);
	F2C(fltmulnor)(x, &m, &n, y);
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, m, one, y);

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	
	return(0);
}

/* ---------------------------------------------------------------- */
/* INTERFACE TO fltsumnor                                           */
/* ---------------------------------------------------------------- */
extern int F2C(fltsumnor) (double *x, int *m, int *n, double *y);
int inter_fltsumnor(char *fname, void* pvApiCtx)

{
	//int m,n,one=1,x,y;
	//CheckRhs(1,1);
	//CheckLhs(1,1);
	//GetRhsVar(1,"d",&m,&n,&x);
	//CreateVar(2,"d",&m,&one,&y);
	//F2C(fltsumnor)(stk(x),&m,&n,stk(y));
	//LhsVar(1)=2;
	//return(0);

	SciErr sciErr;
	int* piAddr = NULL;
	int iRet = 0;
	int m, n, one = 1;
	double *x = NULL;
	double *y = NULL;

	//CheckRhs(1,1);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	//GetRhsVar(1,"d",&m,&n,&x);
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	if (isDoubleType(pvApiCtx, piAddr))
	{
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &m, &n, &x);
	}
	//CreateVar(2,"d",&m,&one,&y);
	//F2C(fltmulnor)(stk(x),&m,&n,stk(y));
	y = (double*)malloc(sizeof(double) * m * one);
	F2C(fltsumnor)(x, &m, &n, y);
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, m, one, y);

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return(0);

}



/* FOR TEST */
extern int F2C(fltcd) (double *destin, double *source, int* length);
int inter_sp01(char *fname)
{
	//int m,n,z,x,y;
	//CheckRhs(1,1);
	//CheckLhs(1,1);
	//GetRhsVar(1,"d",&m,&n,&x);
	//CreateVar(2,"d",&m,&n,&y);
	//z=m*n;
	//F2C(fltcd)(stk(y),stk(x),&z);
	//LhsVar(1)=2;
	return(0);
}

// int inter_sp02(char *fname)
// {
// 	int m,n,z,x,y,one=1;
// 	CheckRhs(1,1);
// 	CheckLhs(1,1);
// 	GetRhsVar(1,"d",&m,&n,&x);
// 	CreateVar(2,"d",&m,&n,&y);
// 	z=m*n;
// 	//C2F(fltcd)(stk(y),stk(x),&z);
// 	F2C(dcopy)(&z,stk(x),&one,stk(y),&one);
// 	LhsVar(1)=2;
// 	return(0);
// }
