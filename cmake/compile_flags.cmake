# This module provides functions that add compiler flags to a target based on
# the detected compiler vendor.

include(CheckCXXCompilerFlag)

macro(strip_and_upper_case flag name)
	string(SUBSTRING ${flag} 1 -1 flag_0)
    string(TOUPPER ${flag_0} flag_1)
    string(REPLACE "-" "_" flag_2 ${flag_1})
    string(REPLACE "+" "X" flag_3 ${flag_2})
	string(REPLACE "=" "" flag_4 ${flag_3})
	set(${name} ${flag_4})
endmacro()

function(target_add_compile_options_checked target)
	foreach(flag IN LISTS ARGN)
		strip_and_upper_case(${flag} flag_name)
		set(has_flag "${CMAKE_CXX_COMPILER_ID}_HAS_${flag_name}")
		check_cxx_compiler_flag(${flag} ${has_flag})
		if(${has_flag})
			target_compile_options(${target} PRIVATE ${flag})
		endif()
	endforeach()
endfunction()

# compiler flags common to gcc and clang
function(target_add_common_nix_compile_flags target)
	message(STATUS "adding *nix flags for ${target}")
	target_compile_options(${target}
		PRIVATE
			-W
			-Wall
			-Wextra
			-pedantic
			-Wwrite-strings
			-Wundef
			-Wpointer-arith
			-Wcast-align
			-Wnon-virtual-dtor
			-Woverloaded-virtual
			-Wsequence-point)

	target_add_compile_options_checked(${target}
		-Wshift-negative-value
		-Wnull-dereference)
endfunction()

function(target_add_clang_compile_flags target)
	message(STATUS "adding clang-specific flags for ${target}")
	target_compile_options(${target} PRIVATE -Weverything)
endfunction()

function(target_add_gcc_compile_flags target)
	message(STATUS "adding gcc-specific flags for ${target}")
	target_add_compile_options_checked(${target}
			-Wmisleading-indentation
			-Wtautological-compare
			-Wlogical-op
			-Wshift-overflow=2
			-Wduplicated-cond
			-Wsuggest-final-types
			-Wsuggest-final-methods
			-Wsuggest-override)
endfunction()

function(target_add_compile_flags target)
	target_add_common_nix_compile_flags(${target})
	if (${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
		target_add_clang_compile_flags(${target})
	elseif(${CMAKE_CXX_COMPILER_ID} MATCHES "GNU")
		target_add_gcc_compile_flags(${target})
	endif()
endfunction()

