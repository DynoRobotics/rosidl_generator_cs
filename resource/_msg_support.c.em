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
#include <string.h>

#include <rosidl_generator_c/visibility_control.h>

#include <@(spec.base_type.pkg_name)/@(subfolder)/@(module_name)__struct.h>
#include <@(spec.base_type.pkg_name)/@(subfolder)/@(module_name)__functions.h>

@{
have_not_included_primitive_arrays = True
have_not_included_string = True
nested_array_dict = {}
}@

@[for field in spec.fields]@
@[  if field.type.is_array and have_not_included_primitive_arrays]@
@{have_not_included_primitive_arrays = False}@
#include <rosidl_generator_c/primitives_sequence.h>
#include <rosidl_generator_c/primitives_sequence_functions.h>

@[  end if]@
@[  if field.type.type == 'string' and have_not_included_string]@
@{have_not_included_string = False}@
#include <rosidl_generator_c/string.h>
#include <rosidl_generator_c/string_functions.h>

@[  end if]@
@{
if not field.type.is_primitive_type() and field.type.is_array:
    if field.type.type not in nested_array_dict:
        nested_array_dict[field.type.type] = field.type.pkg_name
}@
@[end for]@

@{
msg_typename = '%s__%s__%s' % (spec.base_type.pkg_name, subfolder, spec.base_type.type)
}@

@[for field in spec.fields]@
@[if field.type.is_array]@
// Get array
int @(module_name)_native_get_size_@(field.name)(void * message_handle)
{
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
  size_t size = ros_message->@(field.name).size;
  return (int)size;
}

@(primitive_msg_type_to_c(field.type.type)) * @(module_name)_native_get_array_ptr_@(field.name)(void * message_handle)
{
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
  @(primitive_msg_type_to_c(field.type.type)) * data_ptr = ros_message->@(field.name).data;
  return data_ptr;
}
@[elif field.type.is_primitive_type()]@
// Get primitive type
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
// Set array
bool @(module_name)_native_set_array_@(field.name)(void * message_handle, const @(primitive_msg_type_to_c(field.type.type)) * data, int size)
{
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
@[  if field.type.type == 'string']@
  if(!rosidl_generator_c__String__Sequence__init(&(ros_message->@(field.name)), size))
@[  else]@
  if(!rosidl_generator_c__@(field.type.type)__Sequence__init(&(ros_message->@(field.name)), size))
@[  end if]@
  {
    return false;
  }
  @(primitive_msg_type_to_c(field.type.type)) * dest = ros_message->@(field.name).data;
  memcpy(dest, data, sizeof(@(primitive_msg_type_to_c(field.type.type)))*size);
  return true;
}
@[elif field.type.is_primitive_type()]@
// Set primitive type
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
