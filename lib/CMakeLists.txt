cmake_minimum_required(VERSION 3.9)

project(foo VERSION 0.0.2 LANGUAGES CXX)

add_library(foo src/bar.cpp)
add_library(foo::foo ALIAS foo)

include(cmake/compile_flags.cmake)
target_add_compile_flags(foo)

target_include_directories(foo
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

install(TARGETS foo EXPORT foo-exports DESTINATION lib)

include(CMakePackageConfigHelpers)

configure_package_config_file(
	"${CMAKE_CURRENT_LIST_DIR}/cmake/foo-config.cmake.in"
	"${CMAKE_BINARY_DIR}/foo-config.cmake"
	INSTALL_DESTINATION lib/cmake/foo)

write_basic_package_version_file(foo-config-version.cmake
	COMPATIBILITY SameMajorVersion)

install(FILES
	"${CMAKE_BINARY_DIR}/foo-config-version.cmake"
	"${CMAKE_BINARY_DIR}/foo-config.cmake"
	DESTINATION lib/cmake/foo)

install(EXPORT foo-exports
	FILE foo-exports.cmake
	NAMESPACE foo::
	DESTINATION lib/cmake/foo)

# install(TARGETS ... INCLUDES DESTINATION include) only sets sets the include
# directory as a dependency on the imported target
install(DIRECTORY include/foo DESTINATION include)

# cmake -DCMAKE_INSTALL_PREFIX=../export -H. -Bbuild
# cmake --build build --target install
