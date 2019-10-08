/* -----------------------------------------------------------------------
 * UTIL 2
 * ----------------------------------------------------------------------
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
 * 2004-11-04 Add header, spell check, add flterr, add more error message
 * 2006-09-06 Add fltcd -> Copy a doublesh
 * -----------------------------------------------------------------------
 */
#include "api_scilab.h"
#include <Scierror.h>
//#include "stack-c.h"
//#include "string.h"

/* -------------------------------------------------------------------------------------------------------- */
/* GENERATE ERROR                                                                                           */
/* -------------------------------------------------------------------------------------------------------- */
int sciFLT_doerror(int nerr)
{

	switch (nerr) {
		case 0:	Scierror(999,"INTERNAL ERROR -> PLEASE REPORT mailto:jaime_urzua@yahoo.com"); break;
		case 1: Scierror(999,"Incorrect fls internal structure."); break;			
		case 10: Scierror(999,"Unknow fls type."); break;
		case 11: Scierror(999,"Invalid type of type, must be string."); break;			 
		case 20: Scierror(999,"Unknow SNorm class."); break;
		case 21: Scierror(999,"Invalid type of SNorm class, must be string."); break;			 
		case 30: Scierror(999,"Invalid type of SnormPar, must be sacalar."); break;			 
		case 40: Scierror(999,"Unknow TNorm class."); break;
		case 41: Scierror(999,"Invalid type of TNorm class, must be string."); break;
		case 50: Scierror(999,"Invalid type of TNormPar, must be scalar."); break;			 
		case 60: Scierror(999,"Unknow Complement class."); break;
		case 61: Scierror(999,"Invalid type of Complement, must be string."); break;			 
		case 70: Scierror(999,"Invalid type of CompPar must, be scalar."); break;			 
		case 80: Scierror(999,"Unknow Implication method."); break;
		case 81: Scierror(999,"Invalid type of ImpMethod, must be string."); break;			 
		case 90: Scierror(999,"Unknow Aggregation method."); break;
		case 91: Scierror(999,"Invalid type of AggMethod, must be string."); break;			 
		case 100: Scierror(999,"Unknow Defuzzification method."); break;
		case 101: Scierror(999,"Invalid defuzzMethod, must be string."); break;
		case 102: Scierror(999,"Invalid Defuzzification due the fls type."); break;
		case 110: Scierror(999,"Invalid rule type, must be a real matrix."); break;
		case 111: Scierror(999,"Invalid size of rules."); break;
		case 112: Scierror(999,"Invalid index in rule."); break;
		case 120: Scierror(999,"Invalid type in range in variable, must be a row vector with 2 elements."); break;  
		case 130: Scierror(999,"Invalid type of member function type, must be a string.");break;
		case 131: Scierror(999,"Unknow member function type."); break;			  
		case 132: Scierror(999,"Invalid member function in the IF or THEN part."); break;
		case 140: Scierror(999,"Invalid type of member function parameter, must be a row vector."); break;
		case 141: Scierror(999,"Invalid member function parameter, the size is incorrect."); break;		  
		case 200: Scierror(999,"Invalid size of input."); break;
		case 210: Scierror(999,"The third parameter must have the same size of the number of outputs."); break;
		case 211: Scierror(999,"The third parameter must be a vector with integers."); break;
		case 999: Scierror(999,"No more memory!"); break;
		case 1000: Scierror(999,"Invalid parameters, trimf need [a,b,c] with a<=b<=c.");break;
		case 1010: Scierror(999,"Invalid parameters, trapmf need [a,b,c,d] with a<b<=c<d.");break;
		case 1020: Scierror(999,"Invalid parameters, gaussmf need [a,b] with b<>0."); break;
		case 1030: Scierror(999,"Invalid parameters, gaussmf need [a,b,c,d] with b<>0, d<>0."); break;
		case 1040: Scierror(999,"Invalid parameters, gbellmf need [a,b,c] with b<>0."); break;
		case 2000: Scierror(999,"Please choose a fls structure from a file."); break;
		case 2001: Scierror(999,"The fls structure have 0 inputs or 0 outputs or 0 rules to evaluate."); break;
		case 2002: Scierror(999,"Incorrect number of inputs."); break;		
		default : Scierror(999,"UNKNOW ERROR -> PLEASE REPORT mailto:jaime_urzua@yahoo.com"); break;
	}
	return 0;		
}

/* -------------------------------------------------------------------------------------------------------- */
/* GENERATE ERROR                                                                                           */
/* -------------------------------------------------------------------------------------------------------- */
// int C2F(flterr)(nerr)
// 	int *nerr;
// {
// 	sciFLT_doerror((int)*nerr);
// 	return 0;
// }


/* -------------------------------------------------------------------------------------------------------- */
/* USE THE SYSTEM MEMORY COPY ROUTINE INSTEAD OTHER                                                         */
/* -------------------------------------------------------------------------------------------------------- */
int C2F(fltcd)(destin, source, length)
	double *destin, *source;
       	int *length;
{
	memcpy(destin,source,sizeof(double)*(int)*length);
	return 0;
}
