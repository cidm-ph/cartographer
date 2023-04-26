#include <R.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>
#include "cartographer.h"

SEXP nameEnv(SEXP name, SEXP env) {
  if(!isSymbol(name) || length(name) != 1)
    error("name is not a single symbol");
  if(!isEnvironment(env))
    error("env should be an environment");

  return findVar(name, env);
}

SEXP is_promise(SEXP name, SEXP env) {
  SEXP result = PROTECT(allocVector(LGLSXP, 1));
  LOGICAL(result)[0] = TYPEOF(nameEnv(name, env)) == PROMSXP;
  UNPROTECT(1);
  return result;
}

SEXP promise_was_forced(SEXP name, SEXP env) {
  SEXP result = PROTECT(allocVector(LGLSXP, 1));
  LOGICAL(result)[0] = PRVALUE(nameEnv(name, env)) != R_UnboundValue;
  UNPROTECT(1);
  return result;
}

static const R_CallMethodDef callMethods[] = {
  {"is_promise", (DL_FUNC) &is_promise, 2},
  {"promise_was_forced", (DL_FUNC) &promise_was_forced, 2},
  {NULL, NULL, 0}
};

void attribute_visible
R_init_cartographer(DllInfo *dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}

