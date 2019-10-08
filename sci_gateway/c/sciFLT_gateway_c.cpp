#include <wchar.h>
#include "sciFLT_gateway_c.hxx"
extern "C"
{
#include "sciFLT_gateway_c.h"
#include "addfunction.h"
}

#define MODULE_NAME L"sciFLT_gateway_c"

int sciFLT_gateway_c(wchar_t* _pwstFuncName)
{
    if(wcscmp(_pwstFuncName, L"trimf") == 0){ addCStackFunction(L"trimf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"trapmf") == 0){ addCStackFunction(L"trapmf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"gaussmf") == 0){ addCStackFunction(L"gaussmf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"gauss2mf") == 0){ addCStackFunction(L"gauss2mf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"sigmf") == 0){ addCStackFunction(L"sigmf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"psigmf") == 0){ addCStackFunction(L"psigmf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"dsigmf") == 0){ addCStackFunction(L"dsigmf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"gbellmf") == 0){ addCStackFunction(L"gbellmf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"smf") == 0){ addCStackFunction(L"smf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"zmf") == 0){ addCStackFunction(L"zmf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"pimf") == 0){ addCStackFunction(L"pimf", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"constant") == 0){ addCStackFunction(L"constant", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"linear") == 0){ addCStackFunction(L"linear", &inter_anymf, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"mfeval") == 0){ addCStackFunction(L"mfeval", &inter_mfeval, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"complement") == 0){ addCStackFunction(L"complement", &inter_complement, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"snorm") == 0){ addCStackFunction(L"snorm", &inter_snorm, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"tnorm") == 0){ addCStackFunction(L"tnorm", &inter_tnorm, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"defuzzm") == 0){ addCStackFunction(L"defuzzm", &inter_defuzzm, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"flsencode") == 0){ addCStackFunction(L"flsencode", &inter_flsencode, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"evalfls") == 0){ addCStackFunction(L"evalfls", &inter_evalfls, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"repvec") == 0){ addCStackFunction(L"repvec", &inter_repvec, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"fltmulnor") == 0){ addCStackFunction(L"fltmulnor", &inter_fltmulnor, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"fltsumnor") == 0){ addCStackFunction(L"fltsumnor", &inter_fltsumnor, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"repvecc") == 0){ addCStackFunction(L"repvecc", &inter_repvecc, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"sp01") == 0){ addCStackFunction(L"sp01", &inter_sp01, MODULE_NAME); }

    return 1;
}
