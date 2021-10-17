cmake_minimum_required(VERSION 3.12)
project(CMakeHello VERSION 1.0.0)
# set(CMAKE_CXX_STANDARD 14)
# or use MATCHES to see if actual system name 
# Darwin is Apple's system name
# if(${CMAKE_SYSTEM_NAME} MATCHES Darwin)
#     add_definitions(-DCMAKEMACROSAMPLE="Apple MacOS")
# elseif(${CMAKE_SYSTEM_NAME} MATCHES Windows)
#     add_definitions(-DCMAKEMACROSAMPLE="Windows PC")
# endif()
add_executable(cmake_hello main.cpp)