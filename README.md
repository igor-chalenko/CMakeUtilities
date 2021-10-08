# cmake-utilities

What is it
----------

This is a [CMake](https://cmake.org/) package that provides functionality of 
general interest, such as logging, test assertions, and key to value mapping.
Read the
[documentation](https://cmake-utilities.readthedocs.io/en/latest/index.html)
at [Read the Docs](https://readthedocs.io/).

Files
-----
* `DynamicFunctions.cmake`

  Dynamically wraps a given list of functions into a new list where every
  function has an optional prologue/epilogue and calls the original function
  with the possibly amended arguments. Uses
  [cmake_language](https://cmake.org/cmake/help/latest/command/cmake_language.html).

* `GlobalMap.cmake`

  Implements global maps ([key, value] associations) using `GLOBAL` properties.

* `Logging.cmake`

  Makes logging a little easier and more orderly.

* `Testing.cmake`

  Implements test assertions, such as `assert_empty`, `assert_same`, etc.
  For use in tests.

* `InstallBasicPackageFiles.cmake`

  A helper module that generates CMake's config and config version files.
  It's taken from the project [YCM](https://github.com/robotology/ycm),
  which is
  [copyrighted](https://github.com/robotology/ycm/blob/master/LICENSE)
  by Istituto Italiano di Tecnologia (IIT):

    ```
    Copyright 2014 Istituto Italiano di Tecnologia (IIT)
      Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>

    Distributed under the OSI-approved BSD License (the "License");
    see accompanying file Copyright.txt for details.

    This software is distributed WITHOUT ANY WARRANTY; without even the
    implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the License for more information.
    ```

  Follow the
  [link](https://github.com/robotology/ycm/blob/master/modules/InstallBasicPackageFiles.cmake)
  to view the original source. It's not a part of the installation package.

Dependencies
------------
 - `CMake` 3.18 or greater

Installation
------------
Use `make install` command:

```bash
git clone https://github.com/igor-chalenko/cmake-utilities.git
cd cmake-utilities && mkdir build && cd build
cmake ..
make
# if the above succeeded, run this:
sudo make install
```

Usage
-----

After the installation, the package becomes available to CMake via
```cmake
find_package(cmake-utilities)

include(GlobalMap)
include(Logging)
include(Testing)
```

There are a few examples in the `test` sub-directory.

License
-------

This package is under the MIT license. See the 