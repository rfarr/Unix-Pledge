#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <unistd.h>

MODULE = Unix::Pledge		PACKAGE = Unix::Pledge		
PROTOTYPES: ENABLE

SV *
_pledge(promises, paths)
    const char *promises
    SV *paths
INIT:
    AV *results;
    SSize_t numpaths = 0, n;
    int ret;
    SvGETMAGIC(paths);
    if ((!SvROK(paths))
        || (SvTYPE(SvRV(paths)) != SVt_PVAV))
    {
        XSRETURN_UNDEF;
    }
    results = (AV *) sv_2mortal ((SV *) newAV ());
CODE:
    numpaths = av_top_index((AV *)SvRV(paths));
    if (numpaths > 0) {
        const char *wpaths[numpaths+1];
        for (n = 0; n < numpaths; n++) {
            STRLEN l;
            wpaths[n] = SvPV(*av_fetch((AV *)SvRV(paths), n, 0), l);
        }
        wpaths[numpaths] = NULL;
        ret = pledge(promises, wpaths);
    }
    else {
        ret = pledge(promises, NULL);
    }
    av_push(results, newSVnv(ret));
    if (ret == -1) {
        av_push(results, newSVnv(errno));
    }
    RETVAL = newRV((SV *)results);
OUTPUT:
    RETVAL
