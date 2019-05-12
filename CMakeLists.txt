cmake_minimum_required(VERSION 3.1)
project(cpp-sample-microservice CXX)

#set(CMAKE_CXX_STANDARD 17)

#include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
#conan_basic_setup()

# if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
#   message(STATUS "Downloading conan.cmake from https://github.com/memsharded/cmake-conan")
#   file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/master/conan.cmake"
#                 "${CMAKE_BINARY_DIR}/conan.cmake")
# endif()

# include(${CMAKE_BINARY_DIR}/conan.cmake)
include(conan.cmake)

#conan_add_remote(NAME bincrafters INDEX 1
#        URL https://api.bintray.com/conan/bincrafters/public-conan)

conan_add_remote(NAME andreybronin URL https://api.bintray.com/conan/andreybronin/conan)

conan_cmake_run(REQUIRES boost/1.70.0@andreybronin/stable
        solidity/develop@andreybronin/testing
        BASIC_SETUP CMAKE_TARGETS
                BUILD missing)


conan_basic_setup()

add_executable(main main.cpp)
target_link_libraries(main ${CONAN_LIBS})
