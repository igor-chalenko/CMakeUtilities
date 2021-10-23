Logging
=======

This module implements a set of functions for logging messages either to
a console or to a file. Every message has a category that acts as a searchable
hierarchical tag, and optional parameters that will be substituted into
the message by replacing placeholders `{1}`, `{2}`, etc. Output have
the following format:

.. code-block::

  [<timestamp>][<category>][<level>] <message after substitutions>

For example,

.. code-block:: cmake

   # [2021-10-05T23:15:08][test][INFO] The path 'examples' will be used
   log_info(test "The path '{1}' will be used" examples)
   # send log messages in `test` to the file `test.log`
   log_to_file(test test.log)
   # message appended to test.log
   log_warn(test "ICU not found")
   # enable debug messages
   log_level(test DEBUG)
   # printed as well - categories maintain parent-child relation
   log_info(test.nested "This message should be logged, too.")


Notice the parameter `examples` after the main message in the example above.
Use of parameters is entirely optional; they are only for readability.

===========
When to use
===========

Controlled logging is useful in debugging, when it's easy to add a lot of
calls to `message` and it's hard to remove them afterwards. This is not
needed with this module - just raise the logging level of the corresponding
category with either a call to ``log_level`` or via

.. code-block::

   -Dlog.context.<<context name>>.level=ERROR

=========
Functions
=========

.. cmake-module:: ../../cmake/Logging.cmake

