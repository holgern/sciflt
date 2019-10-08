/* -----------------------------------------------------------------------
 * SCICOS FLS COMPUTATION BLOCK
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
    
struct sfls_struct{
        int *npev;
        double *mrule;
	double *mdomo,*mpari,*mparo,*mew,*tmp1,*tmp2,*tmp3,*tmp4,*y_tmp,*u_tmp;
	int tofree[12],ncolmparo;
	int ninputs,noutputs,nrules;
	int mid1[7];
	double mid2[3];
};

static int init(scicos_block *block)
{
  struct sfls_struct * ui = (struct sfls_struct *) malloc(sizeof(struct sfls_struct));
  int i,idx;
  int nu = GetInPortRows(block,1);
  int* ipar = GetIparPtrs(block);
  double* rpar = GetRparPtrs(block);
  int maxnpev=1001;
  int flag=0;
  		for (i=0;i<12;i++) { ui->tofree[i]=0; }
  		
  /* Check if the user choose a fls structure */
		if ( ipar[0]!=1 ) { sciFLT_doerror(2000); flag=-999; goto goout; }

		/* Get information */
		ui->ninputs=ipar[1];
		ui->noutputs=ipar[2];
		ui->nrules=ipar[3];

		/* Chek if are somethig to evaluate */
		if (ui->ninputs*ui->noutputs*ui->nrules==0) { sciFLT_doerror(2001); flag=-999; goto goout; }
		
		/* Check the input size */
		if (ui->ninputs!=nu) { sciFLT_doerror(2002); flag=-999; goto goout; }		
		
		/* Get the rest of integer parameters */
		idx=4;
		

		for (i=0;i<7;i++){
		  ui->mid1[i]=ipar[i+idx];
		  //printf("mid1 %i = %i\n",i, mid1[i]);
		}

		//ui->mid1=&ipar[idx];

		/* Get the ral values */
		
		
		idx=0;
		
		#ifdef FLT_USESCIALLOC
		ui->mrule=(double*)MALLOC(ui->nrules*(ui->ninputs+ui->noutputs+1)*sizeof(double));
		#else
		ui->mrule=(double*)malloc(ui->nrules*(ui->ninputs+ui->noutputs+1)*sizeof(double));
		#endif
		if (ui->mrule==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[0]=1;
		
	        for (i=0;i<ui->nrules*(ui->ninputs+ui->noutputs+1);i++){
		  ui->mrule[i]=rpar[i+idx];
		  //printf("mrule %i = %i\n",i, mrule[i]);
		}
		
		//ui->mrule=&ipar[idx];
		idx+=ui->nrules*(ui->ninputs+ui->noutputs+1);
		
		#ifdef FLT_USESCIALLOC
		ui->mdomo=(double*)MALLOC(ui->noutputs*2*sizeof(double));
		#else
		ui->mdomo=(double*)malloc(ui->noutputs*2*sizeof(double));
		#endif
		if (ui->mdomo==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[1]=1;
		
		for (i=0;i<ui->noutputs*2;i++){
		  ui->mdomo[i]=rpar[i+idx];
		  //printf("mdomo %i = %f\n",i, mdomo[i]);
		}
		//mdomo=&rpar[0];
		idx+=ui->noutputs*2;
		#ifdef FLT_USESCIALLOC	
		ui->mpari=(double*)MALLOC(ui->ninputs*ui->nrules*4*sizeof(double));
		#else
		ui->mpari=(double*)malloc(ui->ninputs*ui->nrules*4*sizeof(double));
		#endif
		if (ui->mpari==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[2]=1;
		
		for (i=0;i<ui->ninputs*ui->nrules*4;i++){
		  ui->mpari[i]=rpar[i+idx];
		  //printf("mpari %i = %f\n",i, mpari[i]);
		}
		//mpari=&rpar[idx];
		idx+=4*ui->ninputs*ui->nrules;
		
		if (ui->mid1[0]==0) {
			ui->ncolmparo=4;
		} else {
			ui->ncolmparo=ui->ninputs+1;
		}
		#ifdef FLT_USESCIALLOC
		ui->mparo=(double*)MALLOC(ui->noutputs*ui->nrules*ui->ncolmparo*sizeof(double));
		#else
		ui->mparo=(double*)malloc(ui->noutputs*ui->nrules*ui->ncolmparo*sizeof(double));
		#endif
		if (ui->mparo==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[3]=1;
		
		for (i=0;i<ui->noutputs*ui->nrules*ui->ncolmparo;i++){
		  ui->mparo[i]=rpar[i+idx];
		  //printf("mparo %i = %f\n",i, mparo[i]);
		}
		//mparo=&rpar[idx];
		idx+=ui->ncolmparo*ui->noutputs*ui->nrules;
		
		#ifdef FLT_USESCIALLOC	
		ui->mew=(double*)MALLOC(ui->nrules*sizeof(double));
		#else
		ui->mew=(double*)malloc(ui->nrules*sizeof(double));
		#endif
		if (ui->mew==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[4]=1;
		
		for (i=0;i<ui->nrules;i++){
		  ui->mew[i]=rpar[i+idx];
		 //printf("mew %i = %f\n",i, mew[i]);
		}
		//mew=&rpar[idx];
		idx+=ui->nrules;
		
		//mid2=&rpar[idx];
		for (i=0;i<3;i++){
		  ui->mid2[i]=rpar[i+idx];
		  //printf("mid2 %i = %f\n",i, mid2[i]);
		}
		
		/* Intiliaze */


		#ifdef FLT_USESCIALLOC
		ui->tmp1=(double*)MALLOC(ui->ninputs*sizeof(double));
		#else
		ui->tmp1=(double*)malloc(ui->ninputs*sizeof(double));
		#endif
		if (ui->tmp1==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[5]=1;

		#ifdef FLT_USESCIALLOC
		ui->tmp2=(double*)MALLOC(ui->nrules*ui->noutputs*sizeof(double));
		#else
		ui->tmp2=(double*)malloc(ui->nrules*ui->noutputs*sizeof(double));
		#endif
		if (ui->tmp2==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[6]=1;

		if ( ui->mid1[0]==0 ) {
			#ifdef FLT_USESCIALLOC
			ui->npev=(int*)MALLOC(ui->noutputs*sizeof(int));
			#else
			ui->npev=(int*)malloc(ui->noutputs*sizeof(int));
			#endif
			if (ui->npev==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
			ui->tofree[8]=1;
			for (i=0;i<ui->noutputs;i++) { ui->npev[i]=maxnpev; }
			#ifdef FLT_USESCIALLOC
			ui->tmp4=(double*)MALLOC(maxnpev*3*sizeof(double));
			#else
			ui->tmp4=(double*)malloc(maxnpev*3*sizeof(double));
			#endif
			if (ui->tmp4==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
			ui->tofree[7]=1;
		}
		#ifdef FLT_USESCIALLOC
		ui->tmp3=(double*)MALLOC(sizeof(double)); /* 1 DUMMY */
		#else
		ui->tmp3=(double*)malloc(sizeof(double)); /* 1 DUMMY */
		#endif
		if (ui->tmp3==NULL) { sciFLT_doerror(999);	flag=-999;goto goout; }
		ui->tofree[9]=1;
			
		#ifdef FLT_USESCIALLOC
		ui->y_tmp=(double*)MALLOC(ui->noutputs*sizeof(double));
		#else
		ui->y_tmp=(double*)malloc(ui->noutputs*sizeof(double));
		#endif
		if (ui->y_tmp==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[10]=1;
	
		for (i=0;i<ui->noutputs;i++)
		  ui->y_tmp[i]=0;
		  
		#ifdef FLT_USESCIALLOC
		ui->u_tmp=(double*)MALLOC(ui->ninputs*sizeof(double));
		#else
		ui->u_tmp=(double*)malloc(ui->ninputs*sizeof(double));
		#endif
		if (ui->u_tmp==NULL) { sciFLT_doerror(999); flag=-999; goto goout; }
		ui->tofree[11]=1;
  *block->work = (void*)ui;
  goout:
   return flag;
}

static int end(scicos_block *block)
{
	struct sfls_struct * ui = (struct sfls_struct *) (*block->work);
		#ifdef FLT_USESCIALLOC

		if (ui->tofree[0]==1) {FREE(ui->mrule); }
		if (ui->tofree[4]==1) {FREE(ui->mew);   }
		if (ui->tofree[2]==1) {FREE(ui->mpari); }
		if (ui->tofree[3]==1) {FREE(ui->mparo); }
		if (ui->tofree[1]==1) {FREE(ui->mdomo); }
		if (ui->tofree[5]==1 ) { FREE(ui->tmp1); }
		if (ui->tofree[6]==1 ) { FREE(ui->tmp2); }
		if (ui->tofree[7]==1 ) { FREE(ui->tmp4); }
		if (ui->tofree[8]==1 ) { FREE(ui->npev); }
		if (ui->tofree[9]==1 ) { FREE(ui->tmp3); }
		if (ui->tofree[10]==1 ) { FREE(ui->y_tmp); }
		if (ui->tofree[11]==1 ) { FREE(ui->u_tmp); }
		#else

		if (ui->tofree[0]==1) {free(ui->mrule); }
		if (ui->tofree[4]==1) {free(ui->mew);   }
		if (ui->tofree[2]==1) {free(ui->mpari); }
		if (ui->tofree[3]==1) {free(ui->mparo); }
		if (ui->tofree[1]==1) {free(ui->mdomo); }
		if (ui->tofree[5]==1 ) { free(ui->tmp1); }
		if (ui->tofree[6]==1 ) { free(ui->tmp2); }
		if (ui->tofree[7]==1 ) { free(ui->tmp4); }
		if (ui->tofree[8]==1 ) { free(ui->npev); }
		if (ui->tofree[9]==1 ) { free(ui->tmp3); }
		if (ui->tofree[10]==1 ) { free(ui->y_tmp); }	
		if (ui->tofree[11]==1 ) { free(ui->u_tmp); }	
		#endif
		free(ui);
		return 0;
}

// int C2F(sfls)(flag, nevprt, t, xd, x, nx, z, nz, tvec, ntvec, rpar, nrpar, ipar, nipar, u, nu, y, ny)
//      int *flag, *nevprt,*nx,*nz,*nrpar, *ipar, *nipar,*ntvec,*nu,*ny;
//      double *t, *xd, *x, *z, *tvec, *rpar, *u, *y;
// {
  
static int out(scicos_block *block)
{
	struct sfls_struct * ui = (struct sfls_struct *) (*block->work);
  	double * u = GetInPortPtrs(block,1);
	double * y = GetOutPortPtrs(block,1);
	int flag=0;
	int i,one=1;
	int maxnpev=1001,ierr;
	
	for (i=0;i<ui->ninputs;i++)
		  ui->u_tmp[i]=u[i];
	C2F(flsengine)(ui->u_tmp,ui->mid1,ui->mid2,ui->mew,ui->mrule,ui->mdomo,ui->mpari,ui->mparo,&(ui->ncolmparo),ui->npev,&(ui->ninputs),&(ui->noutputs),&(ui->nrules),&one,ui->tmp1,ui->tmp2,ui->tmp3,ui->tmp4,&maxnpev,ui->y_tmp,&ierr);

	for (i=0;i<ui->noutputs;i++)
		 y[i]=ui->y_tmp[i];
		
	if (ierr!=0) { flag=-999; }
	return flag;
}


void sfls(scicos_block *block,int flag) 
{
	if (flag==1) {      /* update output */
		flag=out(block);
	}
	else if (flag==5) { /* termination */ 
		flag=end(block);
	}
	else if (flag==4) { /* initialisation */
		flag=init(block);
	}
        
}

