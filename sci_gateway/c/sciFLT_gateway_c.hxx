#ifndef __SCIFLT_GATEWAY_C_GW_HXX__
#define __SCIFLT_GATEWAY_C_GW_HXX__

#ifdef _MSC_VER
#ifdef SCIFLT_GATEWAY_C_GW_EXPORTS
#define SCIFLT_GATEWAY_C_GW_IMPEXP __declspec(dllexport)
#else
#define SCIFLT_GATEWAY_C_GW_IMPEXP __declspec(dllimport)
#endif
#else
#define SCIFLT_GATEWAY_C_GW_IMPEXP
#endif

extern "C" SCIFLT_GATEWAY_C_GW_IMPEXP int sciFLT_gateway_c(wchar_t* _pwstFuncName);



#endif /* __SCIFLT_GATEWAY_C_GW_HXX__ */
