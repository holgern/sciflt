/* snorm.f -- translated by f2c (version 20060506).
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
static int c__0 = 0;

/* ----------------------------------------------------------------------- */
/* S-NORM */
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
/* CHANGES */
/* 2004-10-06 Change subroutine names */
/* 2004-11-08 Scicos Block -> Add flag detection */
/*            Use some BLAS */
/* ----------------------------------------------------------------------- */
/* ************************************************** */
/* GENERAL ROUTINE */
/* ************************************************** */
/* Subroutine */ int csnorm_(char *class1, double *x, int *m, int 
	*n, double *par, int *npar, double *y, int *ierr, 
	ftnlen class1_len)
{
    /* System generated locals */
    int x_dim1, x_offset, i__1, i__2;
    double d__1, d__2;

    /* Builtin functions */
    int s_cmp(char *, char *, ftnlen, ftnlen);
    double pow_dd(double *, double *);

    /* Local variables */
    static int i__, j;
    static double tmp1, tmp2, tmp3;
    extern /* Subroutine */ int erro_(char *, ftnlen), dcopy_(int *, 
	    double *, int *, double *, int *);

/* DUBOIS S-NORM CLASS */
    /* Parameter adjustments */
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;
    --y;

    /* Function Body */
    if (s_cmp(class1, "dubois", (ftnlen)6, (ftnlen)6) == 0) {
	if (*npar != 1) {
	    erro_("dubois s-norm class need 1 parameter.", (ftnlen)37);
	    *ierr = 1;
	} else if (par[1] < 0. || par[1] > 1.) {
	    erro_("dubois s-norm class need 0<=parameter<=1.", (ftnlen)41);
	    *ierr = 1;
	} else {
	    dcopy_(m, &x[x_offset], &c__1, &y[1], &c__1);
	    tmp1 = 1. - par[1];
	    i__1 = *n;
	    for (j = 2; j <= i__1; ++j) {
		i__2 = *m;
		for (i__ = 1; i__ <= i__2; ++i__) {
/* Computing MIN */
		    d__1 = y[i__], d__2 = x[i__ + j * x_dim1], d__1 = min(
			    d__1,d__2);
		    tmp2 = y[i__] + x[i__ + j * x_dim1] - y[i__] * x[i__ + j *
			     x_dim1] - min(d__1,tmp1);
/* Computing MAX */
		    d__1 = 1. - y[i__], d__2 = 1. - x[i__ + j * x_dim1], d__1 
			    = max(d__1,d__2);
		    tmp3 = max(d__1,par[1]);
		    if (tmp3 == 0.) {
			erro_("UNKNOW VALUE IN DOUBOIS S-NORM CLASS (DUE INP"
				"UT AND PARAMETER", (ftnlen)61);
			*ierr = 1;
			goto L9999;
		    }
		    y[i__] = tmp2 / tmp3;
/* L120: */
		}
/* L130: */
	    }
	    *ierr = 0;
	}
/* YAGER S-NORM CLASS */
    } else if (s_cmp(class1, "yager", (ftnlen)5, (ftnlen)5) == 0) {
	if (*npar != 1) {
	    erro_("yagger s-norm class need 1 parameter.", (ftnlen)37);
	    *ierr = 1;
	} else if (par[1] <= 0.) {
	    erro_("yagger s-norm class need parameter>0.", (ftnlen)37);
	    *ierr = 1;
	} else {
	    dcopy_(m, &x[x_offset], &c__1, &y[1], &c__1);
	    tmp1 = 1. / par[1];
	    i__1 = *n;
	    for (j = 2; j <= i__1; ++j) {
		i__2 = *m;
		for (i__ = 1; i__ <= i__2; ++i__) {
		    tmp2 = pow_dd(&y[i__], &par[1]) + pow_dd(&x[i__ + j * 
			    x_dim1], &par[1]);
/* Computing MIN */
		    d__1 = 1., d__2 = pow_dd(&tmp2, &tmp1);
		    y[i__] = min(d__1,d__2);
/* L220: */
		}
/* L230: */
	    }
	    *ierr = 0;
	}
/* DRASTIC-SUM S-NORM CLASS */
    } else if (s_cmp(class1, "dsum", (ftnlen)4, (ftnlen)4) == 0) {
	dcopy_(m, &x[x_offset], &c__1, &y[1], &c__1);
	i__1 = *n;
	for (j = 2; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		if (x[i__ + j * x_dim1] == 0.) {
/*         mantain the same value */
		} else if (y[i__] == 0.) {
		    y[i__] = x[i__ + j * x_dim1];
		} else {
		    y[i__] = 1.;
		}
/* L320: */
	    }
/* L330: */
	}
	*ierr = 0;
/* EINSTEIN-SUM S-NORM CLASS */
    } else if (s_cmp(class1, "esum", (ftnlen)4, (ftnlen)4) == 0) {
	dcopy_(m, &x[x_offset], &c__1, &y[1], &c__1);
	i__1 = *n;
	for (j = 2; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		tmp3 = y[i__] * x[i__ + j * x_dim1] + 1.;
		if (tmp3 == 0.) {
		    erro_("UNKNOW VALUE IN EINSTEIN S-NORM CLASS DUE INPUT A"
			    "ND PARAMETER", (ftnlen)61);
		    *ierr = 1;
		    goto L9999;
		}
		y[i__] = (y[i__] + x[i__ + j * x_dim1]) / tmp3;
/* L420: */
	    }
/* L430: */
	}
	*ierr = 0;
/* ALGEBRAIC-SUM S-NORM CLASS */
    } else if (s_cmp(class1, "asum", (ftnlen)4, (ftnlen)4) == 0) {
	dcopy_(m, &x[x_offset], &c__1, &y[1], &c__1);
	i__1 = *n;
	for (j = 2; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		y[i__] = y[i__] + x[i__ + j * x_dim1] - y[i__] * x[i__ + j * 
			x_dim1];
/* L520: */
	    }
/* L530: */
	}
	*ierr = 0;
/* MAXIMUM-SUM S-NORM CLASS */
    } else if (s_cmp(class1, "max", (ftnlen)3, (ftnlen)3) == 0) {
	dcopy_(m, &x[x_offset], &c__1, &y[1], &c__1);
	i__1 = *n;
	for (j = 2; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		if (x[i__ + j * x_dim1] > y[i__]) {
		    y[i__] = x[i__ + j * x_dim1];
		}
/* L620: */
	    }
/* L630: */
	}
	*ierr = 0;
/* UNKNOW */
    } else {
	erro_("Unknow s-norm class.", (ftnlen)20);
	*ierr = 1;
    }
L9999:
    return 0;
} /* csnorm_ */

/* ************************************************** */
/* THIS SUBROUTINE IS FOR INTERNAL USE */
/* ************************************************** */
/* Subroutine */ int csnorm2_(int *classid, double *x, int *m, 
	int *n, double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset;

    /* Local variables */
    extern /* Subroutine */ int erro_(char *, ftnlen), csnorm_(char *, 
	    double *, int *, int *, double *, int *, 
	    double *, int *, ftnlen);

    /* Parameter adjustments */
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;
    --y;

    /* Function Body */
    if (*classid == 0) {
	csnorm_("dubois", &x[x_offset], m, n, &par[1], &c__1, &y[1], ierr, (
		ftnlen)6);
    } else if (*classid == 1) {
	csnorm_("yager", &x[x_offset], m, n, &par[1], &c__1, &y[1], ierr, (
		ftnlen)5);
    } else if (*classid == 2) {
	csnorm_("dsum", &x[x_offset], m, n, &par[1], &c__0, &y[1], ierr, (
		ftnlen)4);
    } else if (*classid == 3) {
	csnorm_("esum", &x[x_offset], m, n, &par[1], &c__0, &y[1], ierr, (
		ftnlen)4);
    } else if (*classid == 4) {
	csnorm_("asum", &x[x_offset], m, n, &par[1], &c__0, &y[1], ierr, (
		ftnlen)4);
    } else if (*classid == 5) {
	csnorm_("max", &x[x_offset], m, n, &par[1], &c__0, &y[1], ierr, (
		ftnlen)3);
    } else {
	erro_("Unknow s-norm class.", (ftnlen)20);
	*ierr = 1;
    }
/* L9999: */
    return 0;
} /* csnorm2_ */

/* ************************************************** */
/* THIS SUBROUTINE IS USED IN SCICOS */
/* ************************************************** */
/* Subroutine */ int ssnorm_(int *flag__, int *nevprt, double *t, 
	double *xd, double *x, int *nx, double *z__, int *
	nz, double *tvec, int *ntvec, double *rpar, int *
	nrpar, int *ipar, int *nipar, double *u, int *nu, 
	double *y, int *ny)
{
    static int ierr;
    extern /* Subroutine */ int csnorm_(char *, double *, int *, 
	    int *, double *, int *, double *, int *, 
	    ftnlen);

    /* Parameter adjustments */
    --y;
    --u;
    --ipar;
    --rpar;
    --tvec;
    --z__;
    --x;
    --xd;

    /* Function Body */
    if (*flag__ == 1) {
	if (ipar[1] == 0) {
	    csnorm_("dubois", &u[1], &c__1, nu, &rpar[1], nrpar, &y[1], &ierr,
		     (ftnlen)6);
	} else if (ipar[1] == 1) {
	    csnorm_("yager", &u[1], &c__1, nu, &rpar[1], nrpar, &y[1], &ierr, 
		    (ftnlen)5);
	} else if (ipar[1] == 2) {
	    csnorm_("dsum", &u[1], &c__1, nu, &rpar[1], nrpar, &y[1], &ierr, (
		    ftnlen)4);
	} else if (ipar[1] == 3) {
	    csnorm_("esum", &u[1], &c__1, nu, &rpar[1], nrpar, &y[1], &ierr, (
		    ftnlen)4);
	} else if (ipar[1] == 4) {
	    csnorm_("asum", &u[1], &c__1, nu, &rpar[1], nrpar, &y[1], &ierr, (
		    ftnlen)4);
	} else if (ipar[1] == 5) {
	    csnorm_("max", &u[1], &c__1, nu, &rpar[1], nrpar, &y[1], &ierr, (
		    ftnlen)3);
	} else {
/*       oops some error -> fix with 0 */
	    y[1] = 0.;
	}
    }
    return 0;
} /* ssnorm_ */

