/* mfs.f -- translated by f2c (version 20060506).
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

static int c__1000 = 1000;
static int c__1010 = 1010;
static int c__1020 = 1020;
static int c__1030 = 1030;
static int c__1040 = 1040;
static int c__1 = 1;

/* ----------------------------------------------------------------------- */
/* Member functions */
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
/* 2004-11-08 Change some internal subroutines to use BLAS primitives */
/*            Change SCICOS block -> Add flag detection */
/* ----------------------------------------------------------------------- */
/* ************************************************** */
/* TRIANGULAR MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int trimf_(double *x, int *m, int *n, double 
	*par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;

    /* Local variables */
    static double a, b, c__;
    static int i__, j;
    static double tmp1, tmp2;
    extern /* Subroutine */ int flterr_(int *);

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
    c__ = par[3];
    tmp1 = b - a;
    tmp2 = c__ - b;
/* CHECK PARAMETERS */
    if (tmp1 < 0. || tmp2 < 0.) {
	flterr_(&c__1000);
	*ierr = 1;
	goto L9999;
    }
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    if (x[i__ + j * x_dim1] <= a || x[i__ + j * x_dim1] >= c__) {
		y[i__ + j * y_dim1] = 0.;
	    } else if (x[i__ + j * x_dim1] < b) {
/* 		y(i,j)=(x(i,j)-a+b)/tmp1 */
		y[i__ + j * y_dim1] = (x[i__ + j * x_dim1] - a) / tmp1;
	    } else if (x[i__ + j * x_dim1] == b) {
		y[i__ + j * y_dim1] = 1.;
	    } else {
/*          y(i,j)=(c-x(i,j)-b)/tmp2 */
		y[i__ + j * y_dim1] = (c__ - x[i__ + j * x_dim1]) / tmp2;
	    }
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
L9999:
    return 0;
} /* trimf_ */

/* ************************************************** */
/* TRAPEZOIDAL MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int trapmf_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;

    /* Local variables */
    static double a, b, c__, d__;
    static int i__, j;
    static double tmp1, tmp2;
    extern /* Subroutine */ int flterr_(int *);

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
    c__ = par[3];
    d__ = par[4];
    tmp1 = b - a;
    tmp2 = d__ - c__;
/* CHECK PARAMETERS */
/*       if ((tmp1.le.0.0D0).or.(tmp2.le.0.0D0).or.(c.lt.b)) then */
    if (tmp1 < 0. || tmp2 < 0. || c__ < b) {
	flterr_(&c__1010);
	*ierr = 1;
	goto L9999;
    }
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    if (x[i__ + j * x_dim1] <= a || x[i__ + j * x_dim1] >= d__) {
		y[i__ + j * y_dim1] = 0.;
	    } else if (x[i__ + j * x_dim1] < b) {
		y[i__ + j * y_dim1] = (x[i__ + j * x_dim1] - a) / tmp1;
	    } else if (x[i__ + j * x_dim1] >= b && x[i__ + j * x_dim1] <= c__)
		     {
		y[i__ + j * y_dim1] = 1.;
	    } else {
		y[i__ + j * y_dim1] = (d__ - x[i__ + j * x_dim1]) / tmp2;
	    }
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
L9999:
    return 0;
} /* trapmf_ */

/* ************************************************** */
/* GAUSSIAN MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int gaussmf_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;
    double d__1;

    /* Builtin functions */
    double exp(double);

    /* Local variables */
    static double c__;
    static int i__, j;
    static double sig, tmp1, tmp2;
    extern /* Subroutine */ int flterr_(int *);

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    sig = par[1];
    c__ = par[2];
    tmp1 = sig * 2. * sig;
/* CHECK PARAMETERS */
    if (sig == 0.) {
	flterr_(&c__1020);
	*ierr = 1;
	goto L9999;
    }
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
/* Computing 2nd power */
	    d__1 = x[i__ + j * x_dim1] - c__;
	    tmp2 = d__1 * d__1;
	    y[i__ + j * y_dim1] = exp(-tmp2 / tmp1);
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
L9999:
    return 0;
} /* gaussmf_ */

/* ************************************************** */
/* EXTENDED GAUSSIAN MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int gauss2mf_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;
    double d__1;

    /* Builtin functions */
    double exp(double);

    /* Local variables */
    static int i__, j;
    static double c1, c2, sig1, sig2, tmp1, tmp2, tmp3, tmp4;
    extern /* Subroutine */ int flterr_(int *);

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    sig1 = par[1];
    c1 = par[2];
    sig2 = par[3];
    c2 = par[4];
    tmp1 = sig1 * 2. * sig1;
    tmp2 = sig2 * 2. * sig2;
/* CHECK PARAMETERS */
    if (sig1 == 0. || sig2 == 0.) {
	flterr_(&c__1030);
	*ierr = 1;
	goto L9999;
    }
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    if (x[i__ + j * x_dim1] <= c1) {
/* Computing 2nd power */
		d__1 = x[i__ + j * x_dim1] - c1;
		tmp3 = d__1 * d__1;
		tmp3 = exp(-tmp3 / tmp1);
	    } else {
		tmp3 = 1.;
	    }
	    if (x[i__ + j * x_dim1] >= c2) {
/* Computing 2nd power */
		d__1 = x[i__ + j * x_dim1] - c2;
		tmp4 = d__1 * d__1;
		tmp4 = exp(-tmp4 / tmp2);
	    } else {
		tmp4 = 1.;
	    }
	    y[i__ + j * y_dim1] = tmp3 * tmp4;
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
L9999:
    return 0;
} /* gauss2mf_ */

/* ************************************************** */
/* SIGMOIDAL MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int sigmf_(double *x, int *m, int *n, double 
	*par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;

    /* Builtin functions */
    double exp(double);

    /* Local variables */
    static double a, b;
    static int i__, j;
    static double tmp1;

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    tmp1 = par[1] * (x[i__ + j * x_dim1] - par[2]);
	    y[i__ + j * y_dim1] = 1. / (exp(-tmp1) + 1.);
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
/* L9999: */
    return 0;
} /* sigmf_ */

/* ************************************************** */
/* PRODUCT OF TWO SIGMOIDAL MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int psigmf_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;

    /* Builtin functions */
    double exp(double);

    /* Local variables */
    static double a, b, c__, d__;
    static int i__, j;
    static double tmp1, tmp2;

/* INITIALIZE SOME INTERNAL */
    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
    c__ = par[3];
    d__ = par[4];
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    tmp1 = par[1] * (x[i__ + j * x_dim1] - par[2]);
	    tmp1 = 1. / (exp(-tmp1) + 1.);
	    tmp2 = par[3] * (x[i__ + j * x_dim1] - par[4]);
	    tmp2 = 1. / (exp(-tmp2) + 1.);
	    y[i__ + j * y_dim1] = tmp1 * tmp2;
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
/* L9999: */
    return 0;
} /* psigmf_ */

/* ************************************************** */
/* DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int dsigmf_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;
    double d__1;

    /* Builtin functions */
    double exp(double);

    /* Local variables */
    static double a, b, c__, d__;
    static int i__, j;
    static double tmp1, tmp2;

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
    c__ = par[3];
    d__ = par[4];
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    tmp1 = par[1] * (x[i__ + j * x_dim1] - par[2]);
	    tmp1 = 1. / (exp(-tmp1) + 1.);
	    tmp2 = par[3] * (x[i__ + j * x_dim1] - par[4]);
	    tmp2 = 1. / (exp(-tmp2) + 1.);
	    y[i__ + j * y_dim1] = (d__1 = tmp1 - tmp2, abs(d__1));
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
/* L9999: */
    return 0;
} /* dsigmf_ */

/* ************************************************** */
/* GENERALIZED BELL MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int gbellmf_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;
    double d__1;

    /* Builtin functions */
    double pow_dd(double *, double *);

    /* Local variables */
    static double a, b, c__;
    static int i__, j;
    static double tmp1;
    extern /* Subroutine */ int flterr_(int *);

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
    c__ = par[3];
/* CHECK PARAMETERS */
    if (b == 0.) {
	flterr_(&c__1040);
	*ierr = 1;
	goto L9999;
    }
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
/*         if (par(3).eq.0.D0) then */
/*          y(i,j)=0.5D0 */
/*         elseif (par(3).lt.0.0D0) then */
/* 	     y(i,j)=0.0D0 */
/*         else */
	    tmp1 = (x[i__ + j * x_dim1] - c__) / a;
	    if (tmp1 < 0.) {
		tmp1 = -tmp1;
	    }
	    d__1 = b * 2.;
	    tmp1 = pow_dd(&tmp1, &d__1);
	    y[i__ + j * y_dim1] = 1. / (tmp1 + 1.);
/*         end if */
/* L10: */
	}
/* L20: */
    }
    *ierr = 0;
L9999:
    return 0;
} /* gbellmf_ */

/* ************************************************** */
/* PI-SHAPED MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int pimf_(double *x, int *m, int *n, double *
	par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;

    /* Local variables */
    static double a[2], b[2];
    static int i__, j;
    extern /* Subroutine */ int smf_(double *, int *, int *, 
	    double *, double *, int *), zmf_(double *, 
	    int *, int *, double *, double *, int *);
    static double tmp1, tmp2;

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a[0] = par[1];
    a[1] = par[2];
    b[0] = par[3];
    b[1] = par[4];
/* COMPUTE MEMBER FUNCTION */
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
/*        TAKE MUCH TIME ¿ OPTMIZATION ? */
	    smf_(&x[i__ + j * x_dim1], &c__1, &c__1, a, &tmp1, ierr);
	    zmf_(&x[i__ + j * x_dim1], &c__1, &c__1, b, &tmp2, ierr);
	    y[i__ + j * y_dim1] = tmp1 * tmp2;
/* L10: */
	}
/* L20: */
    }
/* L9999: */
    return 0;
} /* pimf_ */

/* ************************************************** */
/* S-SHAPED MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int smf_(double *x, int *m, int *n, double *
	par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;
    double d__1;

    /* Local variables */
    static double a, b;
    static int i__, j;
    static double tmp1, tmp2;

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
    tmp1 = (a + b) / 2.;
    tmp2 = b - a;
/* COMPUTE MEMBER FUNCTION */
    if (a >= b) {
	i__1 = *n;
	for (j = 1; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		if (x[i__ + j * x_dim1] >= tmp1) {
		    y[i__ + j * y_dim1] = 1.;
		} else {
		    y[i__ + j * y_dim1] = 0.;
		}
/* L10: */
	    }
/* L20: */
	}
    } else {
	i__1 = *n;
	for (j = 1; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		if (x[i__ + j * x_dim1] <= a) {
		    y[i__ + j * y_dim1] = 0.;
		} else if (x[i__ + j * x_dim1] <= tmp1) {
/* Computing 2nd power */
		    d__1 = (x[i__ + j * x_dim1] - a) / tmp2;
		    y[i__ + j * y_dim1] = d__1 * d__1 * 2.;
		} else if (x[i__ + j * x_dim1] <= b) {
/* Computing 2nd power */
		    d__1 = (b - x[i__ + j * x_dim1]) / tmp2;
		    y[i__ + j * y_dim1] = 1. - d__1 * d__1 * 2.;
		} else {
		    y[i__ + j * y_dim1] = 1.;
		}
/* L30: */
	    }
/* L40: */
	}
    }
    *ierr = 0;
/* L9999: */
    return 0;
} /* smf_ */

/* ************************************************** */
/* Z-SHAPED MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int zmf_(double *x, int *m, int *n, double *
	par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset, i__1, i__2;
    double d__1;

    /* Local variables */
    static double a, b;
    static int i__, j;
    static double tmp1, tmp2;

    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    a = par[1];
    b = par[2];
    tmp1 = (a + b) / 2.;
    tmp2 = b - a;
/* COMPUTE MEMBER FUNCTION */
    if (a >= b) {
	i__1 = *n;
	for (j = 1; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		if (x[i__ + j * x_dim1] <= tmp1) {
		    y[i__ + j * y_dim1] = 1.;
		} else {
		    y[i__ + j * y_dim1] = 0.;
		}
/* L10: */
	    }
/* L20: */
	}
    } else {
	i__1 = *n;
	for (j = 1; j <= i__1; ++j) {
	    i__2 = *m;
	    for (i__ = 1; i__ <= i__2; ++i__) {
		if (x[i__ + j * x_dim1] <= a) {
		    y[i__ + j * y_dim1] = 1.;
		} else if (x[i__ + j * x_dim1] <= tmp1) {
/* Computing 2nd power */
		    d__1 = (x[i__ + j * x_dim1] - a) / tmp2;
		    y[i__ + j * y_dim1] = 1. - d__1 * d__1 * 2.;
		} else if (x[i__ + j * x_dim1] <= b) {
/* Computing 2nd power */
		    d__1 = (b - x[i__ + j * x_dim1]) / tmp2;
		    y[i__ + j * y_dim1] = d__1 * d__1 * 2.;
		} else {
		    y[i__ + j * y_dim1] = 0.;
		}
/* L30: */
	    }
/* L40: */
	}
    }
    *ierr = 0;
/* L9999: */
    return 0;
} /* zmf_ */

/* ************************************************** */
/* CONSTANT MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int constant_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset;

    /* Local variables */
    extern /* Subroutine */ int uinival_(double *, int *, double *
	    );

/* COMPUTE MEMBER FUNCTION */
    /* Parameter adjustments */
    --y;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    uinival_(&y[1], m, &par[1]);
    *ierr = 0;
/* L9999: */
    return 0;
} /* constant_ */

/* ************************************************** */
/* LINEAR MEMBER FUNCTION */
/* ************************************************** */
/* Subroutine */ int linear_(double *x, int *m, int *n, 
	double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, i__1;

    /* Local variables */
    static int j;
    extern /* Subroutine */ int daxpy_(int *, double *, double *, 
	    int *, double *, int *), uinival_(double *, 
	    int *, double *);

/* COMPUTE MEMBER FUNCTION */
    /* Parameter adjustments */
    --y;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    uinival_(&y[1], m, &par[*n + 1]);
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	if (par[j] != 0.) {
	    daxpy_(m, &par[j], &x[j * x_dim1 + 1], &c__1, &y[1], &c__1);
	}
/* L30: */
    }
    *ierr = 0;
/* L9999: */
    return 0;
} /* linear_ */

/* ************************************************** */
/* EVALUATE MEMBER FUNCTION */
/* ************************************************** */
// F2C(mfeval)(fname, lx, &mx, &nx, lp, &np, ly, &ierr);
/* Subroutine */ int mfeval_(char *mfname, double *x, int *m, int 
	*n, double *par, int *npar, double *y, int *ierr, 
	ftnlen mfname_len)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset;

    /* Builtin functions */
    int s_cmp(char *, char *, ftnlen, ftnlen);

    /* Local variables */
    extern /* Subroutine */ int gauss2mf_(double *, int *, int *, 
	    double *, double *, int *), constant_(double *, 
	    int *, int *, double *, double *, int *), 
	    smf_(double *, int *, int *, double *, double 
	    *, int *), zmf_(double *, int *, int *, 
	    double *, double *, int *), pimf_(double *, 
	    int *, int *, double *, double *, int *), 
	    erro_(char *, ftnlen), sigmf_(double *, int *, int *, 
	    double *, double *, int *), trimf_(double *, 
	    int *, int *, double *, double *, int *), 
	    dsigmf_(double *, int *, int *, double *, 
	    double *, int *), linear_(double *, int *, 
	    int *, double *, double *, int *), psigmf_(
	    double *, int *, int *, double *, double *, 
	    int *), trapmf_(double *, int *, int *, 
	    double *, double *, int *), gbellmf_(double *, 
	    int *, int *, double *, double *, int *), 
	    gaussmf_(double *, int *, int *, double *, 
	    double *, int *);

/* TRIANGULAR MEMBER FUNCTION */
    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;
	sciprint("%i\n", *npar);
    /* Function Body */
    if (s_cmp(mfname, "trimf", (ftnlen)5, (ftnlen)5) == 0) {
	if (*npar != 3) {
	    erro_("trimf need 3 parameters in a row vector.", (ftnlen)40);
	    *ierr = 1;
	} else {
	    trimf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* TRAPEZOIDAL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "trapmf", (ftnlen)6, (ftnlen)6) == 0) {
	if (*npar != 4) {
	    erro_("trapmf need 4 parameters in a row vector.", (ftnlen)41);
	    *ierr = 1;
	} else {
	    trapmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* GAUSSIAN MEMBER FUNCTION */
    } else if (s_cmp(mfname, "gaussmf", (ftnlen)7, (ftnlen)7) == 0) {
	if (*npar != 2) {
	    erro_("gaussmf need 2 parameters in a row vector.", (ftnlen)42);
	    *ierr = 1;
	} else {
	    gaussmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* EXTENDED GAUSSIAN MEMBER FUNCTION */
    } else if (s_cmp(mfname, "gauss2mf", (ftnlen)8, (ftnlen)8) == 0) {
	if (*npar != 4) {
	    erro_("gauss2mf need 4 parameters in a row vector.", (ftnlen)43);
	    *ierr = 1;
	} else {
	    gauss2mf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* SIGMOIDAL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "sigmf", (ftnlen)5, (ftnlen)5) == 0) {
	if (*npar != 2) {
	    erro_("sigmf need 2 parameters in a row vector.", (ftnlen)40);
	    *ierr = 1;
	} else {
	    sigmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* PRODUCT OF TWO SIGMOIDAL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "psigmf", (ftnlen)6, (ftnlen)6) == 0) {
	if (*npar != 4) {
	    erro_("psigmf need 4 parameters in a row vector.", (ftnlen)41);
	    *ierr = 1;
	} else {
	    psigmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "dsigmf", (ftnlen)6, (ftnlen)6) == 0) {
	if (*npar != 4) {
	    erro_("dsigmf need 4 parameters in a row vector.", (ftnlen)41);
	    *ierr = 1;
	} else {
	    dsigmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* GENERALIZED BELL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "gbellmf", (ftnlen)7, (ftnlen)7) == 0) {
	if (*npar != 3) {
	    erro_("gbellmf need 3 parameters in a row vector.", (ftnlen)42);
	    *ierr = 1;
	} else {
	    gbellmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* Pi-Shaped BELL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "pimf", (ftnlen)4, (ftnlen)4) == 0) {
	if (*npar != 4) {
	    erro_("pimf need 4 parameters in a row vector.", (ftnlen)39);
	    *ierr = 1;
	} else {
	    pimf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* S-Shaped BELL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "smf", (ftnlen)3, (ftnlen)3) == 0) {
	if (*npar != 2) {
	    erro_("smf need 2 parameters in a row vector.", (ftnlen)38);
	    *ierr = 1;
	} else {
	    smf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* Z-Shaped BELL MEMBER FUNCTION */
    } else if (s_cmp(mfname, "zmf", (ftnlen)3, (ftnlen)3) == 0) {
	if (*npar != 2) {
	    erro_("zmf need 2 parameters in a row vector.", (ftnlen)38);
	    *ierr = 1;
	} else {
	    zmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* CONSTANT MEMBER FUNCTION */
    } else if (s_cmp(mfname, "constant", (ftnlen)8, (ftnlen)8) == 0) {
	if (*npar != 1) {
	    erro_("constant need 1 parameters in a row vector.", (ftnlen)43);
	    *ierr = 1;
	} else {
	    constant_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* LINEAR MEMBER FUNCTION */
    } else if (s_cmp(mfname, "linear", (ftnlen)6, (ftnlen)6) == 0) {
	if (*npar != *n + 1) {
	    erro_("incorrect number of parameters.", (ftnlen)31);
	    *ierr = 1;
	} else {
	    linear_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
	}
/* UNKNOW MEMBER FUNCTION */
    } else {
	erro_("Unknow Member Function Type.", (ftnlen)28);
	*ierr = 1;
    }
/* L9999: */
    return 0;
} /* mfeval_ */

/* ************************************************** */
/* EVALUATE MEMBER FUNCTION USING ID */
/* ************************************************** */
/* Subroutine */ int mfeval2_(int *mfid, double *x, int *m, 
	int *n, double *par, double *y, int *ierr)
{
    /* System generated locals */
    int x_dim1, x_offset, y_dim1, y_offset;

    /* Local variables */
    extern /* Subroutine */ int gauss2mf_(double *, int *, int *, 
	    double *, double *, int *), constant_(double *, 
	    int *, int *, double *, double *, int *), 
	    smf_(double *, int *, int *, double *, double 
	    *, int *), zmf_(double *, int *, int *, 
	    double *, double *, int *), pimf_(double *, 
	    int *, int *, double *, double *, int *), 
	    erro_(char *, ftnlen), sigmf_(double *, int *, int *, 
	    double *, double *, int *), trimf_(double *, 
	    int *, int *, double *, double *, int *), 
	    dsigmf_(double *, int *, int *, double *, 
	    double *, int *), linear_(double *, int *, 
	    int *, double *, double *, int *), psigmf_(
	    double *, int *, int *, double *, double *, 
	    int *), trapmf_(double *, int *, int *, 
	    double *, double *, int *), gbellmf_(double *, 
	    int *, int *, double *, double *, int *), 
	    gaussmf_(double *, int *, int *, double *, 
	    double *, int *);

/* TRIANGULAR MEMBER FUNCTION */
    /* Parameter adjustments */
    y_dim1 = *m;
    y_offset = 1 + y_dim1;
    y -= y_offset;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;
    --par;

    /* Function Body */
    if (*mfid == 1) {
	trimf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* TRAPEZOIDAL MEMBER FUNCTION */
    } else if (*mfid == 2) {
	trapmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* GAUSSIAN MEMBER FUNCTION */
    } else if (*mfid == 3) {
	gaussmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* EXTENDED GAUSSIAN MEMBER FUNCTION */
    } else if (*mfid == 4) {
	gauss2mf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* SIGMOIDAL MEMBER FUNCTION */
    } else if (*mfid == 5) {
	sigmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* PRODUCT OF TWO SIGMOIDAL MEMBER FUNCTION */
    } else if (*mfid == 6) {
	psigmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* DIFFERENCE OF TWO SIGMOIDAL MEMBER FUNCTION */
    } else if (*mfid == 7) {
	dsigmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* GENERALIZED BELL MEMBER FUNCTION */
    } else if (*mfid == 8) {
	gbellmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* Pi-Shaped BELL MEMBER FUNCTION */
    } else if (*mfid == 9) {
	pimf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* S-Shaped BELL MEMBER FUNCTION */
    } else if (*mfid == 10) {
	smf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* Z-Shaped BELL MEMBER FUNCTION */
    } else if (*mfid == 11) {
	zmf_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* CONSTANT */
    } else if (*mfid == 12) {
	constant_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* LINEAR */
    } else if (*mfid == 13) {
	linear_(&x[x_offset], m, n, &par[1], &y[y_offset], ierr);
/* UNKNOW MEMBER FUNCTION */
    } else {
	erro_("Unknow Member Function Type.", (ftnlen)28);
	*ierr = 1;
    }
/* L9999: */
    return 0;
} /* mfeval2_ */

/* ************************************************** */
/* USED WITH SCICOS */
/* ************************************************** */
/* Subroutine */ int smfeval_(int *flag__, int *nevprt, double *t,
	 double *xd, double *x, int *nx, double *z__, int 
	*nz, double *tvec, int *ntvec, double *rpar, int *
	nrpar, int *ipar, int *nipar, double *u, int *nu, 
	double *y, int *ny)
{
    static int ierr;
    extern /* Subroutine */ int mfeval2_(int *, double *, int *, 
	    int *, double *, double *, int *);

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
	mfeval2_(&ipar[1], &u[1], nu, &c__1, &rpar[1], &y[1], &ierr);
    }
    return 0;
} /* smfeval_ */

/* ************************************************** */
/* error */
/* ************************************************** */
/* Subroutine */ int flterr_(int *nerr)
{
    extern /* Subroutine */ int erro_(char *, ftnlen);

    if (*nerr == 0) {
	erro_("INTERNAL ERROR  PLEASE REPORT.", (ftnlen)30);
    } else if (*nerr == 1) {
	erro_("Incorrect fls internal structure.", (ftnlen)33);
    } else if (*nerr == 10) {
	erro_("Unknow fls type.", (ftnlen)16);
    } else if (*nerr == 20) {
	erro_("Invalid type of type, must be string.", (ftnlen)37);
    } else if (*nerr == 21) {
	erro_("Invalid type of SNorm class, must be string.", (ftnlen)44);
    } else if (*nerr == 30) {
	erro_("Invalid type of SnormPar, must be sacalar.", (ftnlen)42);
    } else if (*nerr == 40) {
	erro_("Unknow TNorm class.", (ftnlen)19);
    } else if (*nerr == 41) {
	erro_("Invalid type of TNorm class, must be string.", (ftnlen)44);
    } else if (*nerr == 50) {
	erro_("Invalid type of TNormPar, must be scalar.", (ftnlen)41);
    } else if (*nerr == 60) {
	erro_("Unknow Complement class.", (ftnlen)24);
    } else if (*nerr == 61) {
	erro_("Invalid type of Complement, must be string.", (ftnlen)43);
    } else if (*nerr == 70) {
	erro_("Invalid type of CompPar must, be scalar.", (ftnlen)40);
    } else if (*nerr == 80) {
	erro_("Unknow Implication method.", (ftnlen)26);
    } else if (*nerr == 81) {
	erro_("Invalid type of ImpMethod, must be string.", (ftnlen)42);
    } else if (*nerr == 90) {
	erro_("Unknow Aggregation method.", (ftnlen)26);
    } else if (*nerr == 91) {
	erro_("Invalid type of AggMethod, must be string.", (ftnlen)42);
    } else if (*nerr == 100) {
	erro_("Unknow Defuzzification method.", (ftnlen)30);
    } else if (*nerr == 101) {
	erro_("Invalid defuzzMethod, must be string.", (ftnlen)37);
    } else if (*nerr == 102) {
	erro_("Invalid Defuzzification due the fls type.", (ftnlen)41);
    } else if (*nerr == 110) {
	erro_("Invalid rule type, must be a real matrix.", (ftnlen)41);
    } else if (*nerr == 111) {
	erro_("Invalid size of rules.", (ftnlen)22);
    } else if (*nerr == 112) {
	erro_("Invalid index in rule.", (ftnlen)22);
    } else if (*nerr == 120) {
	erro_("Invalid range, must be a row vector with 2 elements.", (ftnlen)
		52);
    } else if (*nerr == 130) {
	erro_("Invalid member function type, must be a string.", (ftnlen)47);
    } else if (*nerr == 131) {
	erro_("Unknow member function type.", (ftnlen)28);
    } else if (*nerr == 132) {
	erro_("Invalid member function in the IF or THEN part.", (ftnlen)47);
    } else if (*nerr == 140) {
	erro_("Invalid  parameter, must be a row vector.", (ftnlen)41);
    } else if (*nerr == 141) {
	erro_("Invalid parameter, the size is incorrect.", (ftnlen)41);
    } else if (*nerr == 200) {
	erro_("Invalid size of input.", (ftnlen)22);
    } else if (*nerr == 210) {
	erro_("The third par must have the same size as outputs.", (ftnlen)49)
		;
    } else if (*nerr == 211) {
	erro_("The third parameter must be a vector with ints.", (ftnlen)
		51);
    } else if (*nerr == 999) {
	erro_("No more memory!", (ftnlen)15);
    } else if (*nerr == 1000) {
	erro_("Invalid par, trimf need [a,b,c] with a<=b<=c.", (ftnlen)45);
    } else if (*nerr == 1010) {
	erro_("Invalid par, trapmf need [a,b,c,d] with a<b<=c<d.", (ftnlen)49)
		;
    } else if (*nerr == 1020) {
	erro_("Invalid para, gaussmf need [sig,c] with a~=0.", (ftnlen)43);
    } else if (*nerr == 1030) {
	erro_("Invalid par, gaussmf need [a,b,c,d] with b<>0, d<>0.", (ftnlen)
		52);
    } else if (*nerr == 1040) {
	erro_("Invalid parameters, gbellmf need [a,b,c] with b<>0.", (ftnlen)
		51);
    } else if (*nerr == 2000) {
	erro_("Please choose a fls structure from a file.", (ftnlen)42);
    } else if (*nerr == 2001) {
	erro_("The fls have  0 inputs or 0 outputs or 0 rules.", (ftnlen)47);
    } else if (*nerr == 2002) {
	erro_("Incorrect number of inputs.", (ftnlen)27);
    } else {
	erro_("UNKNOW ERROR", (ftnlen)12);
    }
/* L9999: */
    return 0;
} /* flterr_ */

