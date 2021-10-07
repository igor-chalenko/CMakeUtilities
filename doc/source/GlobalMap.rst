Global maps
===========

A global map models an association between a name and one or more
[`key`, `value`] pairs. In the implementation, these pairs are
saved by the calls to

.. code-block:: cmake

  set_property(GLOBAL PROPERTY ${prefix}${key} ${value})

A prefix usually identifies a program context, so that different global maps
separate different contexts. A global map maintains an index of the keys
it stores, which can be used to find out whether a property is in the map or
not. A map can also be cleared with the help of its index. It's possible
to set, unset, or append to a property using syntax similar to that of usual
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
name, although in implementation it's just a prefix of the stored keys.

===========
When to use
===========
Sometimes, a CMake function or a module can have a complex state. In such cases,
writing something like

.. code-block:: cmake

  get_property(value GLOBAL PROPERTY property)
  set_property(GLOBAL PROPERTY property ${value} ${additional_value})

just to append a value to an existing property becomes a tedious,
error-prone task.

=========
Functions
=========

.. cmake-module:: ../../cmake/GlobalMap.cmake

