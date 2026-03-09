#include <R.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>
#include "cartographer.h"

SEXP promise_was_forced(SEXP name, SEXP env) {
  if (!Rf_isString(name) || Rf_length(name) != 1)
      Rf_error("name is not a single string");
  if (!Rf_isEnvironment(env))
      Rf_error("env should be an environment");
  SEXP val;
  val = Rf_findVar(Rf_installChar(STRING_ELT(name, 0)), env);

  SEXP result = PROTECT(allocVector(LGLSXP, 1));
  LOGICAL(result)[0] = PRVALUE(val) != R_UnboundValue;
  UNPROTECT(1);
  return result;
}

static const R_CallMethodDef callMethods[] = {
  {"promise_was_forced", (DL_FUNC) &promise_was_forced, 2},
  {NULL, NULL, 0}
};

void attribute_visible
R_init_cartographer(DllInfo *dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}

