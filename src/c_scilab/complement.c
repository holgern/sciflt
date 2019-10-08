/* complement.f -- translated by f2c (version 20060506).
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
#include <sciprint.h>
/* Table of constant values */

static int c__0 = 0;
static int c__1 = 1;

/* ----------------------------------------------------------------------- */
/* Fuzzy Complement */
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
/* ************************************************** */
/* GENERAL ROUTINE */
/* ************************************************** */
/* Subroutine */ int complement_(char *class1, double *x, int *m, 
	int *n, double *par, int *npar, double *y, int *
	ierr, ftnlen class1_len)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;
    double d__1;

    /* Builtin functions */
    int s_cmp(char *, char *, ftnlen, ftnlen);
    double pow_dd(double *, double *);

    /* Local variables */
    static int i__, j;
    static double tmp1;
    extern /* Subroutine */ int erro_(char *, ftnlen);

/* ONE COMPLEMENT CLASS */
    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;
	//sciprint("Second: %s\n",*class1);

    /* Function Body */
    if (s_cmp(class1, "one", (ftnlen)3, (ftnlen)3) == 0) {
		
	i__1 = *n;
	for (j = 1; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		y[i__ + j * y_dim1] = 1. - x[i__ + j * x_dim1];
/* L110: */
	    }
/* L120: */
	}
	*ierr = 0;
/* YAGER COMPLEMENT CLASS */
    } else if (s_cmp(class1, "yager", (ftnlen)5, (ftnlen)5) == 0) {
	if (*npar != 1) {
	    erro_("yagger complement class need 1 parameter.", (ftnlen)41);
	    *ierr = 1;
	} else if (par[1] <= 0.) {
	    erro_("yagger complenent class need parameter>0.", (ftnlen)41);
	    *ierr = 1;
	} else {
	    tmp1 = 1. / par[1];
	    i__1 = *n;
	    for (j = 1; j <= i__1; ++j) {
		i__2 = *m;
		for (i__ = 1; i__ <= i__2; ++i__) {
		    d__1 = 1. - pow_dd(&x[i__ + j * x_dim1], &par[1]);
		    y[i__ + j * y_dim1] = pow_dd(&d__1, &tmp1);
/* L210: */
		}
/* L220: */
	    }
	    *ierr = 0;
	}
/* SUGENO COMPLEMENT CLASS */
    } else if (s_cmp(class1, "sugeno", (ftnlen)6, (ftnlen)6) == 0) {
	if (*npar != 1) {
	    erro_("sugeno complement class need 1 parameter.", (ftnlen)41);
	    *ierr = 1;
	} else if (par[1] <= -1.) {
	    erro_("sugeno complenent class need parameter>-1.", (ftnlen)42);
	    *ierr = 1;
	} else {
	    i__1 = *n;
	    for (j = 1; j <= i__1; ++j) {
		i__2 = *m;
		for (i__ = 1; i__ <= i__2; ++i__) {
		    tmp1 = par[1] * x[i__ + j * x_dim1] + 1.;
		    if (tmp1 == 0.) {
			*ierr = 1;
			erro_("UNKNOW VALUE IN SUGENO COMPLEMENT (DUE PARAME"
				"TER AND INPUT)", (ftnlen)59);
			goto L9999;
		    }
		    y[i__ + j * y_dim1] = (1. - x[i__ + j * x_dim1]) / tmp1;
/* L310: */
		}
/* L320: */
	    }
	    *ierr = 0;
	}
/* UNKNOW COMPLEMENT CLASS */
    } else {
		sciprint("error1: \n");
	erro_("Unknow complement class.", (ftnlen)24);
	*ierr = 1;
    }
L9999:
    return 0;
} /* complement_ */

/* ************************************************** */
/* THIS SUBROUTINE IS FOR INTERNAL USE */
/* ************************************************** */
/* Subroutine */ int complement2_(int *classid, double *x, int *m,
	 int *n, double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset;

    /* Local variables */
    extern /* Subroutine */ int complement_(char *, double *, int *, 
	    int *, double *, int *, double *, int *, 
	    ftnlen), erro_(char *, ftnlen);

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    if (*classid == 0) {
	complement_("one", &x[x_offset], m, n, &par[1], &c__0, &y[y_offset], 
		ierr, (ftnlen)3);
    } else if (*classid == 1) {
	complement_("yager", &x[x_offset], m, n, &par[1], &c__1, &y[y_offset],
		 ierr, (ftnlen)5);
    } else if (*classid == 2) {
	complement_("sugeno", &x[x_offset], m, n, &par[1], &c__1, &y[y_offset]
		, ierr, (ftnlen)6);
    } else {
	erro_("Unknow complement class.", (ftnlen)24);
	sciprint("error2: \n");
	*ierr = 1;
    }
/* L9999: */
    return 0;
} /* complement2_ */

/* ************************************************** */
/* THIS SUBROUTINE IS USED IN SCICOS */
/* ************************************************** */
/* Subroutine */ int scomplement_(int *flag__, int *nevprt, 
	double *t, double *xd, double *x, int *nx, double 
	*z__, int *nz, double *tvec, int *ntvec, double *rpar,
	 int *nrpar, int *ipar, int *nipar, double *u, 
	int *nu, double *y, int *ny)
{
    extern /* Subroutine */ int complement_(char *, double *, int *, 
	    int *, double *, int *, double *, int *, 
	    ftnlen);
    static int ierr;

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
    if (ipar[1] == 0) {
	complement_("one", &u[1], nu, &c__1, &rpar[1], nrpar, &y[1], &ierr, (
		ftnlen)3);
    } else if (ipar[1] == 1) {
	complement_("yager", &u[1], nu, &c__1, &rpar[1], nrpar, &y[1], &ierr, 
		(ftnlen)5);
    } else if (ipar[1] == 2) {
	complement_("sugeno", &u[1], nu, &c__1, &rpar[1], nrpar, &y[1], &ierr,
		 (ftnlen)6);
    } else {
/*      oops some error -> fix with 0 */
	y[1] = 0.;
    }
    return 0;
} /* scomplement_ */

