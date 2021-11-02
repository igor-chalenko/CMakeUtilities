Dynamic functions
-----------------

This module implements several meta-functions that create new functions
dynamically by wrapping the existing ones.

The function ``parameter_to_function_prefix`` wraps a function
`f(x1 x2 ...)` into a new function `${x1}_f(x2 ...)`, that is, fixes one
argument to some predefined value so that the wrapped function could be
called with one argument less.

The function ``trace_functions`` wraps a function `f` into a new function
`_trace_f` that prints a trace message `f(${ARGN})` into the log context
with the same name `f`, and then calls the original function with unchanged
arguments.

The function ``dynamic_call`` forwards given arguments to a given function
without any changes.

The function ``eval`` emulates return values for functions and macros:
```cmake
    function(concat_function _param1 _param2)
        result_is("${_param1}_${_param2}")
    endfunction()

    set(_ind 2)
    eval(EXPR a = ${_ind} + 3)
    message(STATUS "a = ${a}") # prints a = 5

    eval(b = concat_function(cmake language))
    message(STATUS "b = ${b}") # prints b = cmake_language
```


===========
When to use
===========
With the help of ``trace_functions``, it's easy to single-out calls to
a specific function without changing the source of that function.
``parameter_to_function_prefix`` is written specifically to wrap the
`GlobalMap` module, but it could be useful in other contexts as well.

=========
Functions
=========

.. cmake-module:: ../../cmake/DynamicFunctions.cmake