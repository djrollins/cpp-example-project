cmake_minimum_required(VERSION 3.9)

project(app LANGUAGES CXX)

add_executable(exe src/main.cpp)

include(cmake/compile_flags.cmake)
target_add_compile_flags(exe)

find_package(foo 0.0.1 REQUIRED)

target_link_libraries(exe PUBLIC foo::foo)

# cmake -DCMAKE_PREFIX_PATH=../export -H. -Bbuild
#			`- adds ../export to the locations where find_package(foo) will look
