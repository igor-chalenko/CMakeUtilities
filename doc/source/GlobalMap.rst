Global map functions
====================

Sometimes, a CMake function can have a complex state. In such cases, writing
something like

.. code-block:: cmake

  get_property(value GLOBAL PROPERTY property)
  set_property(GLOBAL PROPERTY property ${value} ${additional_value})

just to append a value to an existing property becomes a tedious,
error-prone task. This module implements functions that manipulate global
contexts to make the task of state management easier. It's possible to set,
unset, or append to a target property using syntax similar to that of usual
variables:

.. code-block:: cmake

  # set(variable value)
  global_set(context variable value)
  # get_property(GLOBAL PROPERTY variable value)
  global_set(context variable value)
  # unset(variable)
  global_unset(context variable)
  # list(APPEND variable value)
  global_append(context variable value)

The first argument is always a map name; it limits the scope of the operation
to a certain context. It's convenient to think of this argument as of a map
name, although in implementation it's just a prefix to the stored property
names.

.. cmake-module:: ../../cmake/GlobalMap.cmake

