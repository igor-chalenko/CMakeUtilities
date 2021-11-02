cmake_minimum_required(VERSION 3.18)

include(${cmake.utilities.path}/Dependency.cmake)

add_to_registry(self "${cmake.utilities.path}")

import(self::Testing)
import(self::Logging)
import(self::DynamicFunctions)

function(test_function_1 param1)
    assert_same(${param1} "parameter #1")
endfunction()

function(test_function_2 param1 param2)
    assert_same(${param1} "parameter #1")
    assert_same(${param2} "parameter #2")
endfunction()

function(test_function_3 param1 param2 param3)
    assert_same(${param1} "parameter #1")
    assert_same(${param2} "parameter #2")
    assert_same(${param3} "parameter #3")
endfunction()

function(test_function_4 param1 param2 param3 param4)
    assert_same(${param1} "parameter #1")
    assert_same(${param2} "parameter #2")
    assert_same(${param3} "parameter #3")
    assert_same(${param4} "parameter #4")
endfunction()

function(test_function_11 param1 param2 param3 param4 param5 param6 param7 param8 param9 param10 param11)
    assert_same(${param1} "parameter #1")
    assert_same(${param2} "parameter #2")
    assert_same(${param3} "parameter #3")
    assert_same(${param4} "parameter #4")
    assert_same(${param5} "parameter #5")
    assert_same(${param6} "parameter #6")
    assert_same(${param7} "parameter #7")
    assert_same(${param8} "parameter #8")
    assert_same(${param9} "parameter #9")
    assert_same(${param10} "parameter #10")
    assert_same(${param11} "parameter #11")
endfunction()

function(test_function_12 param1 param2 param3 param4 param5 param6 param7 param8 param9 param10 param11 param12)
    assert_same(${param1} "parameter #1")
    assert_same(${param2} "parameter #2")
    assert_same(${param3} "parameter #3")
    assert_same(${param4} "parameter #4")
    assert_same(${param5} "parameter #5")
    assert_same(${param6} "parameter #6")
    assert_same(${param7} "parameter #7")
    assert_same(${param8} "parameter #8")
    assert_same(${param9} "parameter #9")
    assert_same(${param10} "parameter #10")
    assert_same(${param11} "parameter #11")
    assert_same(${param12} "parameter #12")
endfunction()

function(test_function_x param1 param2)
    assert_empty("${param1}")
    assert_same(${param2} "param2")
endfunction()

function(parameter_to_function_prefix_test)
    parameter_to_function_prefix(doxygen
            global_set
            global_get
            test_fn
            )

    global_set(doxygen a b)
    doxygen_global_set(a b)
    doxygen_global_get(a _var)
    assert_same(${_var} b)

    # test for https://github.com/igor-chalenko/cmake-utilities/issues/9
    doxygen_global_set(key "")
    doxygen_global_get(key _var)
    assert_empty("${_var}")
endfunction()

function(trace_functions_test)
    trace_functions(global_set)
    log_level(global_set TRACE)
    log_to_file(global_set global_set.log)
    _trace_global_set(test a bcd)
    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/global_set.log _messages)
    assert_ends_with("${_messages}" "global_set(\"test\" \"a\" \"bcd\")")

    log_level(test_function_1 TRACE)
    log_to_file(test_function_1 test_function_1.log)
    log_level(test_function_2 TRACE)
    log_to_file(test_function_2 test_function_2.log)
    log_level(test_function_3 TRACE)
    log_to_file(test_function_3 test_function_3.log)
    log_level(test_function_4 TRACE)
    log_to_file(test_function_4 test_function_4.log)

    _trace_test_function_1("parameter #1")
    _trace_test_function_2("parameter #1" "parameter #2")
    _trace_test_function_3("parameter #1" "parameter #2" "parameter #3")
    _trace_test_function_4("parameter #1" "parameter #2" "parameter #3" "parameter #4")

    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test_function_1.log _messages)
    assert_ends_with("${_messages}" "test_function_1(\"parameter #1\")")
    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test_function_2.log _messages)
    assert_ends_with("${_messages}" "test_function_2(\"parameter #1\" \"parameter #2\")")
    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test_function_3.log _messages)
    assert_ends_with("${_messages}" "test_function_3(\"parameter #1\" \"parameter #2\" \"parameter #3\")")
    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test_function_4.log _messages)
    assert_ends_with("${_messages}" "test_function_4(\"parameter #1\" \"parameter #2\" \"parameter #3\" \"parameter #4\")")
endfunction()

function(dynamic_call_test)
    set(_var log_info)
    log_level(dynamic_call TRACE)
    log_to_file(dynamic_call dynamic_call.log)
    dynamic_call(${_var} dynamic_call "cool message")
    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/dynamic_call.log _messages)
    assert_ends_with("${_messages}" "cool message")

    dynamic_call(test_function_1 "parameter #1")
    dynamic_call(test_function_2 "parameter #1" "parameter #2")
    dynamic_call(test_function_3 "parameter #1" "parameter #2" "parameter #3")
    dynamic_call(test_function_4 "parameter #1" "parameter #2" "parameter #3" "parameter #4")
    dynamic_call(test_function_11 "parameter #1" "parameter #2" "parameter #3" "parameter #4"
            "parameter #5" "parameter #6" "parameter #7" "parameter #8"
            "parameter #9" "parameter #10" "parameter #11"
            )
    dynamic_call(test_function_12 "parameter #1" "parameter #2" "parameter #3" "parameter #4"
            "parameter #5" "parameter #6" "parameter #7" "parameter #8"
            "parameter #9" "parameter #10" "parameter #11" "parameter #12"
            )
    dynamic_call(test_function_x "" "param2")
endfunction()

function(function_with_result _param1 _param2)
    result_expr(${_param1} + ${_param2})
endfunction()

function(function_with_result_2 _param1 _param2)
    result_is("${_param1}_${_param2}")
endfunction()

macro(macro_with_result _param1 _param2)
    result_is("${_param1}_${_param2}")
endmacro()

function(eval_test)
    eval("a = function_with_result(3 4)")
    assert_same(${a} 7)
    eval(b = function_with_result_2(cmake language))
    assert_same(${b} cmake_language)
    set(_ind 2)
    eval(EXPR a = ${_ind} + 3)
    assert_same(${a} 5)
    eval(a = macro_with_result(1 2))
    assert_same(${a} 1_2)
endfunction()

parameter_to_function_prefix_test()
trace_functions(test_function_1 test_function_2 test_function_3 test_function_4
        test_function_11 test_function_12 test_function_x)
trace_functions_test()
dynamic_call_test()
eval_test()