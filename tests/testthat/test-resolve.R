test_that("detects promise forced", {
  e <- rlang::new_environment()
  rlang::env_bind_lazy(e, x = 1 + 1)
  expect_false(promise_was_forced("x", e))
  e$x
  expect_true(promise_was_forced("x", e))
})
