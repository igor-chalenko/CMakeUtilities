Logging
=======

This module implements a set of functions for logging messages either to
a console or to a file. The messages have the following format:

.. code-block::

  [<timestamp>][<context>][<level>] <message after substitutions>

All logging functions accept an additional argument `context`, which acts as
a tag in the message being logged. Here's a few examples:

.. code-block:: cmake

   # [2021-10-05T23:15:08][test][INFO] The path 'examples' will be used
   log_info(test "The path '{1}' will be used" examples)
   # send log messages in `test` to the file `test.log`
   log_to_file(test test.log)
   # message appended to test.log
   log_warn(test "ICU not found")

If enabled by the CMake option `CMAKE_COLORIZED_OUTPUT`, and if supported by
the terminal, messages of different level will have a different color.
Additionally, any parameters substituted into the message via `{1}`, `{2}`,
... marks, will have their own color as well.

===========
When to use
===========

Controlled logging is useful in debugging, when it's easy to add a lot of
calls to `message` and it's hard to remove them afterwards. This is not
needed with this module - just raise the logging level of the corresponding
context with either a call to ``log_level`` or via

.. code-block::

   -Dlog.context.<<context name>>.level=ERROR

=========
Functions
=========

.. cmake-module:: ../../cmake/Logging.cmake

