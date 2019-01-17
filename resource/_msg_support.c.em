// generated from rosidl_generator_cs/resource/_msg_support.c.em
// generated code does not contain a copyright notice

@#######################################################################
@# EmPy template for generating _<msg>_s.c files
@#
@# Context:
@#  - module_name
@#  - spec (rosidl_parser.MessageSpecification)
@#    Parsed specification of the .msg file
@#  - convert_camel_case_to_lower_case_underscore (function)
@#  - primitive_msg_type_to_c (function)
@#######################################################################
@
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <stdint.h>

#include <rosidl_generator_c/visibility_control.h>

#include <@(spec.base_type.pkg_name)/@(subfolder)/@(module_name)__struct.h>
#include <@(spec.base_type.pkg_name)/@(subfolder)/@(module_name)__functions.h>

#include <rosidl_generator_c/string.h>
#include <rosidl_generator_c/string_functions.h>

@{
msg_typename = '%s__%s__%s' % (spec.base_type.pkg_name, subfolder, spec.base_type.type)
}@


@[for field in spec.fields]@
@[if field.type.is_array]@
// TODO(samiam): add support for arrays
@[elif field.type.is_primitive_type()]@
@[  if field.type.type == 'string']@
const char * @(module_name)_native_read_field_@(field.name)(void * message_handle)
@[  else]
@(primitive_msg_type_to_c(field.type.type)) @(module_name)_native_read_field_@(field.name)(void * message_handle)
@[  end if]
{
@[  if field.type.is_primitive_type()]@
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
@[    if field.type.type == 'string']@
  return ros_message->@(field.name).data;
@[    else]@
  return ros_message->@(field.name);
@[    end if]@
@[  end if]@
}
@[end if]@
@[end for]@

@[for field in spec.fields]@
@[if field.type.is_array]@
// TODO(samiam): add support for arrays
@[elif field.type.is_primitive_type()]@
@[  if field.type.type == 'string']@
void @(module_name)_native_write_field_@(field.name)(void * message_handle, const char * value)
@[  else]
void @(module_name)_native_write_field_@(field.name)(void * message_handle, @(primitive_msg_type_to_c(field.type.type)) value)
@[  end if]
{
@[  if field.type.is_primitive_type()]@
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
@[    if field.type.type == 'string']
  rosidl_generator_c__String__assign(&ros_message->@(field.name), value);
@[    else]@
  ros_message->@(field.name) = value;
@[    end if]@
@[  end if]@
}
@[end if]@
@[end for]@
