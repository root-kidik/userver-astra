cmake_minimum_required(VERSION 3.12)
project(greeter_service CXX)

include(third_party/userver/cmake/SetupEnvironment.cmake)
include(GNUInstallDirs)

add_subdirectory(third_party/userver)

# Common sources
add_library(${PROJECT_NAME}_objs OBJECT src/greeter_service.hpp
                                        src/greeter_service.cpp)

# Grpc enable
include(GrpcTargets)
add_grpc_library(${PROJECT_NAME}_proto PROTOS api/greeter_service.proto)

target_link_libraries(${PROJECT_NAME}_objs PUBLIC ${PROJECT_NAME}_proto)

# The Service
add_executable(${PROJECT_NAME} src/main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_objs)

# Functional Tests
include(UserverTestsuite)

set(testsuite_requirements "${CMAKE_CURRENT_SOURCE_DIR}/tests/requirements.txt")
if(Protobuf_VERSION VERSION_GREATER 3.20.0)
  list(APPEND testsuite_requirements
       "${USERVER_DIR}/testsuite/requirements-grpc.txt")
else()
  list(APPEND testsuite_requirements
       "${USERVER_DIR}/testsuite/requirements-grpc-old.txt")
  message(STATUS "Forcing old protobuf version for testsuite")
endif()

userver_testsuite_add_simple(REQUIREMENTS ${testsuite_requirements})

# Install
if(DEFINED ENV{PREFIX})
  message(STATUS "Set install prefix: $ENV{PREFIX}")
  file(TO_CMAKE_PATH "$ENV{PREFIX}" PREFIX_PATH)
  set(CMAKE_INSTALL_PREFIX "${PREFIX_PATH}")
endif()

file(GLOB CONFIGS_FILES ${CMAKE_CURRENT_SOURCE_DIR}/configs/*.yaml
     ${CMAKE_CURRENT_SOURCE_DIR}/configs/*.json)

install(
  TARGETS ${PROJECT_NAME}
  DESTINATION ${CMAKE_INSTALL_BINDIR}
  COMPONENT ${PROJECT_NAME})
install(
  FILES ${CONFIGS_FILES}
  DESTINATION ${CMAKE_INSTALL_SYSCONFDIR}/${PROJECT_NAME}
  COMPONENT ${PROJECT_NAME})
