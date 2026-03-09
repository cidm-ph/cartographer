promise_was_forced <- function(name, env = cartographer_global) {
  .Call(C_promise_was_forced, name, env)
}
