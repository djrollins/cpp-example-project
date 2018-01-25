cmake_minimum_required(VERSION 3.3)

project(super-project LANGUAGES CXX)

include(cmake/find_package_subproject.cmake)

find_as_subproject(foo)

add_subdirectory(app)
add_subdirectory(lib) # foo
