Dynamic functions
-----------------

This module implements several meta-functions that could be useful during
development. They are different in purpose, and belong to the same module
because they all create new functions dynamically by wrapping existing ones.

The function ``parameter_to_function_prefix`` wraps a function
`f(x1 x2 ...)` into a new function `${x1}_f(x2 ...)`, that is, fixing one
argument to some predefined value.

The function ``trace_functions`` wraps a function `fn` into a new function
`_trace_fn` that prints a trace message `called fn(${ARGN})` into the log
context `fn` and then calls the original function with unchanged arguments.

===========
When to use
===========
With the help of ``trace_functions``, it's easy to single-out call to
a specific function without changing the source of that function.
``parameter_to_function_prefix`` is written specifically to wrap the
`GlobalMap` module, but it could be useful in other contexts as well.

=========
Functions
=========

.. cmake-module:: ../../cmake/DynamicFunctions.cmake