# This module provides functions that add compiler flags to a target based on
# the detected compiler vendor.

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
			-Wsequence-point
			-Wnull-dereference
			-Wshift-negative-value)
endfunction()

function(target_add_clang_compile_flags target)
	message(STATUS "adding clang-specific flags for ${target}")
	target_compile_options(${target} PRIVATE -Weverything)
endfunction()

function(target_add_gcc_compile_flags target)
	message(STATUS "adding gcc-specific flags for ${target}")
	target_compile_options(${target}
		PRIVATE
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

