include(${cmake.utilities.path}/Dependency.cmake)

add_to_registry(self "${cmake.utilities.path}")

import(self::Testing)

global_set(prefix a b)
global_get(prefix a _var)
assert_same(${_var} b)
global_set(prefix a c)
global_get(prefix a _var)
assert_same(${_var} c)

# get a non-existing property
global_get(prefix non_existing _var)
assert_empty("${_var}")

global_append(prefix a d)
global_get(prefix a _var)
assert_same("${_var}" "c;d")
global_clear(prefix)
global_get(prefix a _var)
assert_empty("${_var}")

global_append(prefix1 a a)
global_append(prefix2 a b)
global_unset(prefix1 a)
global_get_or_fail(prefix2 a _var)
assert_same("${_var}" b)
