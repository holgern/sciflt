/* flsengine.f -- translated by f2c (version 20060506).
   You must link the resulting object file with libf2c:
	on Microsoft Windows system, link with libf2c.lib;
	on Linux or Unix systems, link with .../path/to/libf2c.a -lm
	or, if you install libf2c.a in a standard place, with -lf2c -lm
	-- in that order, at the end of the command line, as in
		cc *.o -lf2c -lm
	Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

		http://www.netlib.org/f2c/libf2c.zip
*/

#include "f2c.h"

/* Table of constant values */

static int c__1 = 1;
static double c_b13 = 0.;
static double c_b14 = 1.;

/* ----------------------------------------------------------------------- */
/* EVALUATE FLS STRUCTURE */
/* ----------------------------------------------------------------------- */
/* This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox ) */
/* Copyright (C) @YEARS@ Jaime Urzua Grez */
/* mailto:jaime_urzua@yahoo.com */

/* Holger Nahrstaedt */
/* ----------------------------------------------------------------------- */
/* This program is free software; you can redistribute it and/or modify */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation; either version 2 of the License, or */
/* (at your option) any later version. */
/* ----------------------------------------------------------------------- */
/* CHANGES: */
/* 2004-10-06 Change S-Norm and T-Norm call */
/* 2004-11-03 Change matrix initialization subroutine */
/* 2004-11-07 Change some internal subroutines to use BLAS primitives */
/* ----------------------------------------------------------------------- */
/* Subroutine */ int flsengine_(double *x, int *mid1, double *
	mid2, double *mew, double *mrule, double *mdomo, 
	double *mpari, double *mparo, int *nparo, int *npev, 
	int *ninputs, int *noutputs, int *nrules, int *
	npoints, double *tmp1, double *tmp2, double *tmp3, 
	double *tmp4, int *maxnpev, double *y, int *ierr)
{
	/* System generated locals */
	int x_dim1, x_offset, mrule_dim1, mrule_offset, mdomo_dim1, 
		mdomo_offset, mparo_dim1, mparo_offset, y_dim1, y_offset, 
		tmp1_dim1, tmp1_offset, tmp2_dim1, tmp2_offset, tmp4_dim1, 
		tmp4_offset, i__1, i__2, i__3, i__4;
	double d__1, d__2, d__3, d__4;

	/* Builtin functions */
	double d_int(double *), d_nint(double *), pow_dd(double *, 
		double *);

	/* Local variables */
	static double tmp_idx3__;
	extern /* Subroutine */ int defuzzm2_(int *, double *, int *, 
		double *, double *, int *), dolinspa_(double *, 
		double *, int *, double *);
	static int i__;
	static logical dowarning;
	static int ip;
	static double dd1;
	static int pt1;
	extern /* Subroutine */ int complement2_(int *, double *, int 
		*, int *, double *, double *, int *);
	static int inp, rul, idx1, idx2;
	static double idx3;
	extern int isgn_(int *);
	static double esum;
	static int outp;
	extern /* Subroutine */ int dscal_(int *, double *, double *, 
		int *), daxpy_(int *, double *, double *, int 
		*, double *, int *);
	static double eprod1, eprod2;
	extern /* Subroutine */ int mfeval2_(int *, double *, int *, 
		int *, double *, double *, int *), csnorm2_(
		int *, double *, int *, int *, double *, 
		double *, int *), ctnorm2_(int *, double *, 
		int *, int *, double *, double *, int *), 
		uinival_(double *, int *, double *);

/* ----------------------------------------------------------------------- */
/* COMPUTE THE IF PART */
/* ----------------------------------------------------------------------- */
	/* Parameter adjustments */
	--mid1;
	--mid2;
	--npev;
	mdomo_dim1 = *noutputs;
	mdomo_offset = 1 + mdomo_dim1;
	mdomo -= mdomo_offset;
	mparo_dim1 = *nparo;
	mparo_offset = 1 + mparo_dim1;
	mparo -= mparo_offset;
	mpari -= 5;
	mrule_dim1 = *nrules;
	mrule_offset = 1 + mrule_dim1;
	mrule -= mrule_offset;
	--mew;
	y_dim1 = *npoints;
	y_offset = 1 + y_dim1;
	y -= y_offset;
	--tmp3;
	tmp2_dim1 = *npoints;
	tmp2_offset = 1 + tmp2_dim1;
	tmp2 -= tmp2_offset;
	tmp1_dim1 = *npoints;
	tmp1_offset = 1 + tmp1_dim1;
	tmp1 -= tmp1_offset;
	x_dim1 = *npoints;
	x_offset = 1 + x_dim1;
	x -= x_offset;
	tmp4_dim1 = *maxnpev;
	tmp4_offset = 1 + tmp4_dim1;
	tmp4 -= tmp4_offset;

	/* Function Body */
	i__1 = *nrules;
	for (rul = 1; rul <= i__1; ++rul) {
	i__2 = *ninputs;
	for (inp = 1; inp <= i__2; ++inp) {
		idx1 = (i__3 = (int) mrule[rul + inp * mrule_dim1], abs(i__3));
		i__3 = (int) mrule[rul + inp * mrule_dim1];
		idx2 = isgn_(&i__3);
		//idx1 = abs(int(mrule(rul, inp)))
		//idx2 = isgn(int(mrule(rul, inp)))

/*        idx3=hedge(mrule(rul,inp)) */
		d__4 = (d__2 = mrule[rul + inp * mrule_dim1], abs(d__2));
		d__3 = ((d__1 = mrule[rul + inp * mrule_dim1], abs(d__1)) - d_int(&d__4)) * 100.;
		idx3 = d_nint(&d__3) / 10.;
		
/*       EVALUATE MEMBER FUNCTION */
		if (idx1 > 0) {
		pt1 = (inp - 1) * *nrules + rul;
		//sciprint("pt1");
		//sciprint("pt1 :%i\n", pt1);
		//sciprint("pt1");
		//mfeval2(idx1,x(1,inp),npoints,1,mpari(1,pt1),tmp1(1,inp),ierr)
		mfeval2_(&idx1, &x[inp * x_dim1 + 1], npoints, &c__1, &mpari[(pt1 << 2) + 1], &tmp1[inp * tmp1_dim1 + 1], ierr);
		
		if (*ierr > 0) {
			goto L9999;
		}
		if (idx3 > 0.) {
			i__3 = *npoints;
			for (i__ = 1; i__ <= i__3; ++i__) 
			{
				tmp1[i__ + inp * tmp1_dim1] = pow_dd(&tmp1[i__ + inp *tmp1_dim1], &idx3);
				/* L90: */		
				
			}
		}

		//sciprint("engine tmp1 :%i\n", tmp1[i__ + inp * tmp1_dim1]);

/*        DO COMPLEMENT IF IS REQUIRED */
		if (idx2 < 0) {
			complement2_(&mid1[4], &tmp1[inp * tmp1_dim1 + 1], npoints, &c__1, &mid2[3], &tmp1[inp * tmp1_dim1 + 1], ierr);
			if (*ierr > 0) {
			goto L9999;
			}
		}
		} else {
		dd1 = (double) ((int) mrule[rul + (*ninputs + *noutputs + 1) * mrule_dim1]);
		uinival_(&tmp1[inp * tmp1_dim1 + 1], npoints, &dd1);
		}
		
		
/* L100: */
	}
	//sciprint("tmp1 %i\n",tmp1[inp * tmp1_dim1 + 1]);




/*      DO THE S-NORM OR THE T-NORM */
	if ((int) mrule[rul + (*ninputs + *noutputs + 1) * mrule_dim1] == 0) {
		csnorm2_(&mid1[2], &tmp1[tmp1_offset], npoints, ninputs, &mid2[1],&tmp2[rul * tmp2_dim1 + 1], ierr);
		if (*ierr > 0) {
		goto L9999;
		}
	} else {
		ctnorm2_(&mid1[3], &tmp1[tmp1_offset], npoints, ninputs, &mid2[2],&tmp2[rul * tmp2_dim1 + 1], ierr);
		if (*ierr > 0) {
		goto L9999;
		}
	}

	

	i__2 = *npoints;
	for (i__ = 1; i__ <= i__2; ++i__) {
		tmp2[i__ + rul * tmp2_dim1] *= mew[rul];
		//sciprint("%f\n", mew[rul]);
/* L110: */
	}
/* L200: */


	}




	i__1 = *noutputs;
	for (outp = 2; outp <= i__1; ++outp) {
	i__2 = *npoints;
	for (i__ = 1; i__ <= i__2; ++i__) {
		i__3 = *nrules;
		for (rul = 1; rul <= i__3; ++rul) {
		tmp2[i__ + (rul + (outp - 1) * *nrules) * tmp2_dim1] = tmp2[i__ + rul * tmp2_dim1];
		
/* L300: */
		}
/* L400: */
	}
/* L500: */
	}

	//sciprint("%f\n", tmp2[i__ + rul * tmp2_dim1]);

/* ----------------------------------------------------------------------- */
/* COMPUTE THE THEN PART */
/* ----------------------------------------------------------------------- */
	if (mid1[1] == 1) {
	goto L2000;
	}
/* ************************** */
/*    IT'S A MAMDANI */
/* ************************** */
	


	i__1 = *maxnpev * 3;
	uinival_(&tmp4[tmp4_offset], &i__1, &c_b13);
	i__1 = *npoints * *noutputs;
	uinival_(&y[y_offset], &i__1, &c_b14);
	i__1 = *npoints;
	for (ip = 1; ip <= i__1; ++ip) {
	i__2 = *noutputs;
	for (outp = 1; outp <= i__2; ++outp) {
		dolinspa_(&mdomo[outp + mdomo_dim1], &mdomo[outp + (mdomo_dim1 << 1)], &npev[outp], &tmp4[tmp4_dim1 * 3 + 1]);	
		uinival_(&tmp4[tmp4_offset], &npev[outp], &c_b13);
		i__3 = *nrules;
		for (rul = 1; rul <= i__3; ++rul) {
		idx1 = (i__4 = (int) mrule[rul + (*ninputs + outp) * mrule_dim1], abs(i__4));

		i__4 = (int) mrule[rul + (*ninputs + outp) * mrule_dim1];
		idx2 = isgn_(&i__4);
/*         idx3=hedge(mrule(rul,ninputs+outp)) */
		d__4 = (d__2 = mrule[rul + (*ninputs + outp) * mrule_dim1], abs(d__2));
		d__3 = ((d__1 = mrule[rul + (*ninputs + outp) * mrule_dim1], abs(d__1)) - d_int(&d__4)) * 100.;
		idx3 = d_nint(&d__3) / 10.;
		//sciprint("idx1 :%i\n", idx1);
		//sciprint("idx2 :%i\n", idx2);
		//sciprint("idx3 :%f\n", idx3);


/*        EVALUATE MEMBER FUNCTION */
		if (idx1 > 0) {
			pt1 = (outp - 1) * *nrules + rul;

			mfeval2_(&idx1, &tmp4[tmp4_dim1 * 3 + 1], &npev[outp], &c__1, &mparo[pt1 * mparo_dim1 + 1], &tmp4[(tmp4_dim1 << 1) + 1], ierr);

			if (*ierr > 0) {
			goto L9999;
			}
			if (idx3 > 0.) {
			i__4 = npev[outp];
			for (i__ = 1; i__ <= i__4; ++i__) {
				tmp4[i__ + (tmp4_dim1 << 1)] = pow_dd(&tmp4[i__ + (tmp4_dim1 << 1)], &idx3);
/* L900: */

			}
			}
			if (idx2 < 0) {
			complement2_(&mid1[4], &tmp4[(tmp4_dim1 << 1) + 1], &npev[outp], &c__1, &mid2[3], &tmp4[(tmp4_dim1 << 1) + 1], ierr);
			if (*ierr > 0) {
				goto L9999;
			}
			}
/*         MAKE IMPLICATION */
			if (mid1[5] == 0) {
/*          minimum */
			i__4 = npev[outp];
			for (i__ = 1; i__ <= i__4; ++i__) {
/* Computing MIN */
				d__1 = tmp4[i__ + (tmp4_dim1 << 1)], d__2 = tmp2[ip + rul * tmp2_dim1];
				tmp4[i__ + (tmp4_dim1 << 1)] = min(d__1,d__2);
/* L1000: */
			}
			} else if (mid1[5] == 1) {
/*          product */
			dscal_(&npev[outp], &tmp2[ip + rul * tmp2_dim1], &tmp4[(tmp4_dim1 << 1) + 1], &c__1);
			} else {
/*          einstein product */
			i__4 = npev[outp];
			for (i__ = 1; i__ <= i__4; ++i__) {
				eprod1 = tmp4[i__ + (tmp4_dim1 << 1)] * tmp2[ip + rul * tmp2_dim1];
				eprod2 = 2. - (tmp4[i__ + (tmp4_dim1 << 1)] + tmp2[ip + rul * tmp2_dim1] - eprod1);
				tmp4[i__ + (tmp4_dim1 << 1)] = eprod1 / eprod2;
/* L1010: */
			}
			}
/*         MAKE AGGREGATION */
			
			if (mid1[6] == 0) {
/*          maximum */
			i__4 = npev[outp];
			for (i__ = 1; i__ <= i__4; ++i__) {
/* Computing MAX */
	
				d__1 = tmp4[i__ + tmp4_dim1], d__2 = tmp4[i__ + (tmp4_dim1 << 1)];
				tmp4[i__ + tmp4_dim1] = max(d__1,d__2);

				
/* L1020: */
			}
			} else if (mid1[6] == 1) {
/*          sum */
			i__4 = npev[outp];
			for (i__ = 1; i__ <= i__4; ++i__) {
				tmp4[i__ + tmp4_dim1] += tmp4[i__ + (tmp4_dim1 << 1)];
/* L1030: */
			}
			} else if (mid1[6] == 2) {
/*          einstein sum */
			i__4 = npev[outp];
			for (i__ = 1; i__ <= i__4; ++i__) {
				esum = tmp4[i__ + tmp4_dim1] * tmp4[i__ + (tmp4_dim1 << 1)] + 1.;
				tmp4[i__ + tmp4_dim1] = (tmp4[i__ + tmp4_dim1] + tmp4[i__ + (tmp4_dim1 << 1)]) / esum;
/* L1040: */
			}
			} else {
/*          probor */
			i__4 = npev[outp];
			for (i__ = 1; i__ <= i__4; ++i__) {
				tmp4[i__ + tmp4_dim1] = tmp4[i__ + tmp4_dim1] + tmp4[i__ + (tmp4_dim1 << 1)] - tmp4[i__ + tmp4_dim1] * tmp4[i__ + (tmp4_dim1 << 1)];
/* L1050: */
			}
			}
			
		}
/* L1100: */

		
		}
/*       MAKE DEFUZZIFICATION */

		//defuzzm2_(&mid1[7], &tmp4[tmp4_dim1 * 3 + 1], &npev[outp], &tmp4[tmp4_dim1 + 1], &y[ip + outp * y_dim1], ierr);
		
		//sciprint("=================\n");
		//sciprint("%i\n", mid1[7]);
		//for (int i = 0; i < 101; i++) {
		//	sciprint("%f\n", tmp4[tmp4_dim1  + 1 + i]);
		//}
		//sciprint("%i\n", npev[outp]);
		//sciprint("%f\n", tmp4[tmp4_dim1 + 1]);
		//sciprint("%f\n", y[ip + outp * y_dim1]);
		//sciprint("=================\n");
		//for (int i = 0; i < *npoints* *ninputs; i++)
		//{
		//	sciprint("tmp1 : %f\n", *(tmp1 + i));
		//}

		//for (int i = 0; i < *npoints* *nrules; i++)
		//{
		//	sciprint("tmp2 : %f\n", *(tmp2 + i));
		//}

		defuzzm2_(&mid1[7], &tmp4[tmp4_dim1 * 3 + 1], &npev[outp], &tmp4[tmp4_dim1 + 1], &y[ip + outp * y_dim1], ierr);
		//sciprint("tmp4-1 :%i\n", tmp4[tmp4_dim1 + 1]);
		//sciprint("tmp4-3 :%i\n", tmp4[tmp4_dim1 * 3 + 1]);
		//sciprint("ierr at engine: %i\n", *ierr);

		if (*ierr > 0) {
		goto L9999;
		}
/* L1200: */
	}
/* L1300: */
	}
	goto L9999;
/* ************************** */
/*    IT'S A TAKAGI-SUGENO */
/* ************************** */
L2000:
	dowarning = FALSE_;
/*     COMPUTE EACH THEN PART OF RULE FOR ALL OUTPUTS (NOT WEIGTHED) */
	i__1 = *npoints * *noutputs;
	uinival_(&y[y_offset], &i__1, &c_b13);
	i__1 = *nrules;
	for (rul = 1; rul <= i__1; ++rul) {
	i__2 = *noutputs;
	for (outp = 1; outp <= i__2; ++outp) {
		idx1 = (i__3 = (int) mrule[rul + (*ninputs + outp) * mrule_dim1], abs(i__3));
		d__4 = (d__2 = mrule[rul + (*ninputs + outp) * mrule_dim1], abs(d__2));
		d__3 = ((d__1 = mrule[rul + (*ninputs + outp) * mrule_dim1], abs(d__1)) - d_int(&d__4)) * 100.;
		idx3 = d_nint(&d__3) / 10.;
		if (idx1 > 0) {
		pt1 = (outp - 1) * *nrules + rul;
		mfeval2_(&idx1, &x[x_offset], npoints, ninputs, &mparo[pt1 * mparo_dim1 + 1], &tmp3[1], ierr);
		if (*ierr > 0) {
			goto L9999;
		}
		if (idx3 > 0.) {
			i__3 = *npoints;
			for (i__ = 1; i__ <= i__3; ++i__) {
			d__1 = 1. / idx3;
			tmp_idx3__ = pow_dd(&tmp2[i__ + (rul + (outp - 1) * *nrules) * tmp2_dim1], &d__1);
			tmp2[i__ + (rul + (outp - 1) * *nrules) * tmp2_dim1] =tmp_idx3__;
/* L2005: */
			}
		}
		i__3 = *npoints;
		for (i__ = 1; i__ <= i__3; ++i__) {
			y[i__ + outp * y_dim1] += tmp2[i__ + (rul + (outp - 1) * *nrules) * tmp2_dim1] * tmp3[i__];
/* L2010: */
		}
		}
/* L2100: */
	}
/* L2200: */
	}
/* DEFUZZIFICATION METHOD IS WAVER ? */
/*      goto 9999 */
	if (mid1[7] == 7) {
	goto L9999;
	}
	i__1 = *noutputs;
	for (outp = 1; outp <= i__1; ++outp) {
	uinival_(&tmp3[1], npoints, &c_b13);
	i__2 = *nrules;
	for (rul = 1; rul <= i__2; ++rul) {
		if ((int) mrule[rul + (*ninputs + outp) * mrule_dim1] != 0) {
		daxpy_(npoints, &mew[rul], &tmp2[(rul + (outp - 1) * *nrules) * tmp2_dim1 + 1], &c__1, &tmp3[1], &c__1);
		}
/* L2260: */
	}
	i__2 = *npoints;
	for (i__ = 1; i__ <= i__2; ++i__) {
		y[i__ + outp * y_dim1] /= tmp3[i__];
/* L2270: */
	}
/* L2280: */
	}
L9999:
	return 0;
} /* flsengine_ */

