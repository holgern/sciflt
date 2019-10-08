/* optfls.f -- translated by f2c (version 20060506).
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

static double c_b2 = 1.;
static int c__1 = 1;
static double c_b8 = 0.;

/* ----------------------------------------------------------------------- */
/* OPTIMIZATION FLS STRUCTURES */
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
/* NOTES */
/* Experimental stage */
/* ----------------------------------------------------------------------- */
/* -------------------------------------------------- */
/* Compute the following */
/* y=prod(x,'c')/sum(prod(x,'c')) */
/* -------------------------------------------------- */
/* Subroutine */ int fltmulnor_(double *x, int *m, int *n, 
	double *y)
{
    /* System generated locals */
    int x_dim1, x_offset, i__1, i__2;
    double d__1;

    /* Local variables */
    static int i__, j;
    static double ys;
    extern /* Subroutine */ int dscal_(int *, double *, double *, 
	    int *), uinival_(double *, int *, double *);

    /* Parameter adjustments */
    --y;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;

    /* Function Body */
    uinival_(&y[1], m, &c_b2);
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    y[i__] *= x[i__ + j * x_dim1];
/* L10: */
	}
/* L20: */
    }
    ys = 0.;
    i__1 = *m;
    for (i__ = 1; i__ <= i__1; ++i__) {
	ys += y[i__];
/* L30: */
    }
    d__1 = 1. / ys;
    dscal_(m, &d__1, &y[1], &c__1);
    return 0;
} /* fltmulnor_ */

/* -------------------------------------------------- */
/* Compute the following */
/* y=sum(x,'c')/sum(sum(x,'c')) */
/* -------------------------------------------------- */
/* Subroutine */ int fltsumnor_(double *x, int *m, int *n, 
	double *y)
{
    /* System generated locals */
    int x_dim1, x_offset, i__1, i__2;
    double d__1;

    /* Local variables */
    static int i__, j;
    static double ys;
    extern /* Subroutine */ int dscal_(int *, double *, double *, 
	    int *), uinival_(double *, int *, double *);

    /* Parameter adjustments */
    --y;
    x_dim1 = *m;
    x_offset = 1 + x_dim1;
    x -= x_offset;

    /* Function Body */
    uinival_(&y[1], m, &c_b8);
    ys = 0.;
    i__1 = *n;
    for (j = 1; j <= i__1; ++j) {
	i__2 = *m;
	for (i__ = 1; i__ <= i__2; ++i__) {
	    y[i__] += x[i__ + j * x_dim1];
	    ys += x[i__ + j * x_dim1];
/* L10: */
	}
/* L20: */
    }
    d__1 = 1. / ys;
    dscal_(m, &d__1, &y[1], &c__1);
    return 0;
} /* fltsumnor_ */

