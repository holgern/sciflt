/* defuzzm.f -- translated by f2c (version 20060506).
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

/* ----------------------------------------------------------------------- */
/* Defuzzification */
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
/* Subroutine */ int defuzzm_(char *method, double *x, int *m, 
	double *y2, double *ou, int *ierr, ftnlen method_len)
{
    /* System generated locals */
    int i__1;

    /* Builtin functions */
    int s_cmp(char *, char *, ftnlen, ftnlen);

    /* Local variables */
    static int i__;
    static double tmp1, tmp2;
    extern /* Subroutine */ int erro_(char *, ftnlen);


	//sciprint("=================\n");
	////sciprint("%s\n", *method);
	//sciprint("%f\n", *x);
	//sciprint("%i\n", *m);
	//sciprint("%f\n", *y2);
	//sciprint("%f\n", *ou);
	//sciprint("=================\n");

/* CENTROIDE */
    /* Parameter adjustments */
    --y2;
    --x;
	//sciprint("xxxxxxxxxxxxxxxxxxxxxx\n");
	//sciprint("%f\n", x[0]);
	//sciprint("%f\n", x[1]);
	//sciprint("xxxxxxxxxxxxxxxxxxxxxx\n");
    /* Function Body */
    if (s_cmp(method, "centroide", (ftnlen)9, (ftnlen)9) == 0) {
	tmp1 = 0.;
	*ou = 0.;
	i__1 = *m;
	for (i__ = 1; i__ <= i__1; ++i__) {
	    tmp1 += y2[i__];
		//sciprint("%f\n", y2[i__]);
	    *ou += x[i__] * y2[i__];
/* L100: */
	}
	if (tmp1 == 0.) {
/*        call erro("Total area is cero.") */
		//sciprint("Total area is cero.\n");
		*ierr = 1;
	} else {
	    *ou /= tmp1;
	    *ierr = 0;
	}
	//sciprint("here i am!\n");
	//sciprint("%f\n", *ou);
/* BISECTOR */
    } else if (s_cmp(method, "bisector", (ftnlen)8, (ftnlen)8) == 0) {
	tmp1 = 0.;
	i__1 = *m;
	for (i__ = 1; i__ <= i__1; ++i__) {
	    tmp1 += y2[i__];
/* L200: */
	}
	if (tmp1 == 0.) {
/*        call erro("Total area is cero.") */
	    *ierr = 1;
	} else {
	    tmp1 /= 2.;
	    tmp2 = 0.;
	    i__1 = *m;
	    for (i__ = 1; i__ <= i__1; ++i__) {
		tmp2 += y2[i__];
		if (tmp2 >= tmp1) {
		    goto L220;
		}
/* L210: */
	    }
	    i__ = *m;
L220:
	    *ou = x[i__];
	    *ierr = 0;
	}
/* MEAN OF MAXIMUM */
    } else if (s_cmp(method, "mom", (ftnlen)3, (ftnlen)3) == 0) {
	*ou = x[1];
	tmp1 = y2[1];
	tmp2 = 1.;
	i__1 = *m;
	for (i__ = 2; i__ <= i__1; ++i__) {
	    if (y2[i__] == tmp1) {
		*ou += x[i__];
		tmp2 += 1.;
	    } else if (y2[i__] > tmp1) {
		tmp1 = y2[i__];
		*ou = x[i__];
		tmp2 = 1.;
	    }
/* L300: */
	}
	*ou /= tmp2;
	*ierr = 0;
/* SHORTEST OF MAXIMUM */
    } else if (s_cmp(method, "som", (ftnlen)3, (ftnlen)3) == 0) {
	*ou = x[1];
	tmp1 = y2[1];
	i__1 = *m;
	for (i__ = 2; i__ <= i__1; ++i__) {
	    if (y2[i__] == tmp1) {
		if (x[i__] < *ou) {
		    *ou = x[i__];
		}
	    } else if (y2[i__] > tmp1) {
		tmp1 = y2[i__];
		*ou = x[i__];
	    }
/* L400: */
	}
	*ierr = 0;
/* LARGEST OF MAXIMUM */
    } else if (s_cmp(method, "lom", (ftnlen)3, (ftnlen)3) == 0) {
	*ou = x[1];
	tmp1 = y2[1];
	i__1 = *m;
	for (i__ = 2; i__ <= i__1; ++i__) {
	    if (y2[i__] == tmp1) {
		if (x[i__] > *ou) {
		    *ou = x[i__];
		}
	    } else if (y2[i__] > tmp1) {
		tmp1 = y2[i__];
		*ou = x[i__];
	    }
/* L500: */
	}
	*ierr = 0;
/* UNKNOW METHOD */
    } else {
	erro_("Unknow method.", (ftnlen)14);
	*ierr = 1;
    }
/* L9999: */
    return 0;
} /* defuzzm_ */

/* ************************************************** */
/* CALL BY ID */
/* ************************************************** */
/* Subroutine */ int defuzzm2_(int *methodid, double *x, int *m, 
	double *y2, double *ou, int *ierr)
{
    extern /* Subroutine */ int erro_(char *, ftnlen), defuzzm_(char *, 
	    double *, int *, double *, double *, int *, 
	    ftnlen);

    /* Parameter adjustments */
    --y2;
    --x;

    /* Function Body */
    if (*methodid == 0) {
		//sciprint("=================\n");
		//sciprint("%i\n", *methodid);
		//sciprint("%f\n", x[1]);
		//sciprint("%i\n", *m);
		//sciprint("%f\n", y2[1]);
		//sciprint("%f\n", *ou);
		//sciprint("=================\n");
	defuzzm_("centroide", &x[1], m, &y2[1], ou, ierr, (ftnlen)9);
    } else if (*methodid == 1) {
	defuzzm_("bisector", &x[1], m, &y2[1], ou, ierr, (ftnlen)8);
    } else if (*methodid == 2) {
	defuzzm_("mom", &x[1], m, &y2[1], ou, ierr, (ftnlen)3);
    } else if (*methodid == 3) {
	defuzzm_("som", &x[1], m, &y2[1], ou, ierr, (ftnlen)3);
    } else if (*methodid == 4) {
	defuzzm_("lom", &x[1], m, &y2[1], ou, ierr, (ftnlen)3);
    } else {
	erro_("Unknow method.", (ftnlen)14);
	*ierr = 1;
    }
/* L9999: */
    return 0;
} /* defuzzm2_ */

