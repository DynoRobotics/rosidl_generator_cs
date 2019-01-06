# Copyright 2015 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

find_package(rmw_implementation_cmake REQUIRED)
find_package(rmw REQUIRED)
find_package(rosidl_generator_c REQUIRED)

# find_package(dotnet_cmake_module REQUIRED)
# find_package(DotNETExtra REQUIRED)

# Get a list of typesupport implementations from valid rmw implementations.
rosidl_generator_cs_get_typesupports(_typesupport_impls)

if(_typesupport_impls STREQUAL "")
  message(WARNING "No valid typesupport for .NET generator. .NET messages will not be generated.")
  return()
endif()

set(_output_path "${CMAKE_CURRENT_BINARY_DIR}/rosidl_generator_cs/${PROJECT_NAME}")

set(EXE_COMMAND "mono")
set(_generated_msg_cs_files "")

foreach(_idl_file ${rosidl_generate_interfaces_IDL_FILES})
  message("Generating C# interface or something...: ${_idl_file}")

  get_filename_component(_parent_folder "${_idl_file}" DIRECTORY)
  get_filename_component(_parent_folder "${_parent_folder}" NAME)
  get_filename_component(_msg_name1 "${_idl_file}" NAME_WE)
  get_filename_component(_extension "${_idl_file}" EXT)
  string_camel_case_to_lower_case_underscore("${_msg_name1}" _mgs_name)

  if(_parent_folder STREQUAL "msg")
    # list(APPEND _generated_msg_cs_files
    #   "${_output_path}/${_parent_folder}/${_msg_name}.cs"
    # )

    if(_extension STREQUAL ".msg")
      string(RANDOM RND_VAL)
  	  add_custom_target(
  	    "generate_cs_messages_${_msg_name}_${RND_VAL}" ALL
  	    COMMAND ${EXE_COMMAND} ${rosidl_generator_cs_BIN} -m ${_idl_file} ${PROJECT_NAME} ${_output_path}
  	    COMMENT "Generating CS code for ${_msg_name}"
  	    DEPENDS ros2cs_message_generator
  	    VERBATIM
  	  )
    endif()
  else()
    message(FATAL_ERROR "Interface file with unknown parent folder: ${_idl_file}")
  endif()

endforeach()

set(target_dependencies
  "${rosidl_generator_cs_BIN}"
)

foreach(dep ${target_dependencies})
  if(NOT EXISTS "${dep}")
    message(FATAL_ERROR "Target dependency '${dep}' does not exist")
  endif()
endforeach()

# set_property(
#   SOURCE
#   ${_generated_msg_cs_files}
#   PROPERTY GENERATED 1
# )
#
# add_custom_command(
#   OUTPUT ${_generated_msg_cs_files}
#
#   COMMAND ${EXE_COMMAND} ${rosidl_generator_cs_BIN} -m ${_idl_file} ${PROJECT_NAME} ${_output_path}
#
#   # DEPENDS ${target_dependencies}
#   COMMENT "Generating C# code for ROS interfaces"
#   VERBATIM
# )
