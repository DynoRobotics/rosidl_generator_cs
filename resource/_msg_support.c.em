@# Included from rosidl_generator_cs/resource/_idl.cs.em
@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore
from rosidl_generator_py.generate_py_impl import SPECIAL_NESTED_BASIC_TYPES
from rosidl_parser.definition import AbstractNestedType
from rosidl_parser.definition import AbstractSequence
from rosidl_parser.definition import AbstractString
from rosidl_parser.definition import AbstractWString
from rosidl_parser.definition import Array
from rosidl_parser.definition import BasicType
from rosidl_parser.definition import NamespacedType

def primitive_msg_type_to_c(type_):
    from rosidl_generator_c import BASIC_IDL_TYPES_TO_C
    from rosidl_parser.definition import AbstractString
    from rosidl_parser.definition import AbstractWString
    from rosidl_parser.definition import BasicType
    if isinstance(type_, AbstractString):
        return 'rosidl_generator_c__String'
    if isinstance(type_, AbstractWString):
        return 'rosidl_generator_c__U16String'
    assert isinstance(type_, BasicType)
    return BASIC_IDL_TYPES_TO_C[type_.typename]

include_parts = [package_name] + list(interface_path.parents[0].parts) + \
    [convert_camel_case_to_lower_case_underscore(interface_path.stem)]
include_base = '/'.join(include_parts)

header_files = [
  'stdlib.h',
  'stdio.h',
  'assert.h',
  'stdint.h',
  'string.h',
  'rosidl_generator_c/visibility_control.h',
  include_base + '__struct.h',
  include_base + '__functions.h',
]
}@
@[for header_file in header_files]@
@{
repeated_header_file = header_file in include_directives
}@
@[    if repeated_header_file]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
@[    if '/' not in header_file]@
#include <@(header_file)>
@[    else]@
#include "@(header_file)"
@[    end if]@
@[end for]@
@{
have_not_included_primitive_arrays = True
have_not_included_string = True
have_not_included_wstring = True
nested_types = set()
}@
@[for member in message.structure.members]@
@{
type_ = member.type
if isinstance(type_, AbstractNestedType):
    type_ = type_.value_type
header_files = []
if isinstance(member.type, AbstractNestedType) and have_not_included_primitive_arrays:
    have_not_included_primitive_arrays = False
    header_files += [
        'rosidl_generator_c/primitives_sequence.h',
        'rosidl_generator_c/primitives_sequence_functions.h']
if isinstance(type_, AbstractString) and have_not_included_string:
    have_not_included_string = False
    header_files += [
        'rosidl_generator_c/string.h',
        'rosidl_generator_c/string_functions.h']
if isinstance(type_, AbstractWString) and have_not_included_wstring:
    have_not_included_wstring = False
    header_files += [
        'rosidl_generator_c/u16string.h',
        'rosidl_generator_c/u16string_functions.h']
}@
@[if header_files]@
@[  for header_file in header_files]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
#include "@(header_file)"
@[  end for]@
@[end if]@
@{
if isinstance(member.type, AbstractNestedType) and isinstance(member.type.value_type, NamespacedType):
    nested_types.add((*member.type.value_type.namespaces, member.type.value_type.name))
}@
@[end for]@
@[if nested_types]@
// Nested array functions includes
@[  for type_ in sorted(nested_types)]@
#include "@('/'.join(type_[:-1]))/@(convert_camel_case_to_lower_case_underscore(type_[-1]))__functions.h"
// End nested array functions include
@[  end for]@
@[end if]@
@{
msg_typename = '__'.join(message.structure.namespaced_type.namespaced_name())
}@
@
@[for member in message.structure.members]@
@{
msg_full_name = '__'.join(
  message.structure.namespaced_type.namespaces +
  [convert_camel_case_to_lower_case_underscore(message.structure.namespaced_type.name)] +
  [member.name]
)
}@
@[ if isinstance(member.type, BasicType)]
// --- Read and write functions for basic type ---
ROSIDL_GENERATOR_C_EXPORT
@(primitive_msg_type_to_c(member.type)) @(msg_full_name)__native_read(void * message_handle)
{
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
  return ros_message->@(member.name);
  }

ROSIDL_GENERATOR_C_EXPORT
void @(msg_full_name)__native_write(void * message_handle, @(primitive_msg_type_to_c(member.type)) value)
{
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
  ros_message->@(member.name) = value;
}
// --- End read and write functions for basic type ---
@[  elif isinstance(member.type, AbstractString)]
// --- Read and write functions for string type ---
ROSIDL_GENERATOR_C_EXPORT
const char * @(msg_full_name)__native_read(void * message_handle)
{
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
  return ros_message->@(member.name).data;
}

ROSIDL_GENERATOR_C_EXPORT
void @(msg_full_name)__native_write(void * message_handle, const char * value)
{
  @(msg_typename) * ros_message = (@(msg_typename) *)message_handle;
  rosidl_generator_c__String__assign(&ros_message->@(member.name), value);
}
// --- End read and write functions for string type ---
@[  end if]
@[end for]@
