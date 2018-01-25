# This script overloads find_package to be a no-op if the dependency is to be
# built as a subdirectory. This allows projects to use find_package and have an
# external CMakeLists.txt decided whether it should link to a pre-built package
# or a target in subproject.
#
# Thanks to Daniel Pfieffer for the idea in his Effective CMake talks.
#
# lib/CMakeLists.txt:
#	add_library(lib ...)
#	add_library(lib::lib ALIAS lib)
#	install(TARGET lib EXPORT lib-export DESTIATION lib ...)
#	install(EXPORT lib-export NAMESPACE lib:: ...)
#
# app/CMakeLists.txt:
#	add_executable(app ...)
#	find_package(lib REQUIRED)
#	target_link_libraries(app PRIVATE lib::lib)
#
# CMakeLists.txt
#	include(cmake/find_package_subproject.cmake)
#	find_as_subproject(lib)
#	add_subdirectory(app)
#	add_subdirectory(lib)
#
# When build from the root, the find_package(lib) in app will be a no-op and app
# will link against the lib::lib alias target that is created from
# add_subdirectory(lib).
#
# However, app can also be build standalone in it's own directory and link
# against an installed version of lib that will be found by find_package.


# Register a target to be a subproject so that any future call to find_package
# should not bother trying to find it.
function(find_as_subproject target)
	set(__subprojects ${__subprojects};${target} PARENT_SCOPE)
endfunction()

# A find_package wrapper that will foward all arguments to the real find_package
# function if the first argument (the target) has not been previously registered
# with find_as_subproject.
macro(find_package)
	if (NOT ${ARGV0} IN_LIST __subprojects)
		_find_package(${ARGV})
	endif()
endmacro()
