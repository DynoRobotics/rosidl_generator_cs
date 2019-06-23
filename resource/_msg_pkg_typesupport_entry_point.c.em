@# Included from rosidl_generator_cs/resource/_idl_pkg_typesupport_entry_point.c.em
@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore

include_parts = idl_type.namespaces + [
    convert_camel_case_to_lower_case_underscore(idl_type.name)]
include_base = '/'.join(include_parts)

header_files = [
    'stdbool.h',
    'stdint.h',
    'rosidl_generator_c/visibility_control.h',
    'rosidl_generator_c/message_type_support_struct.h',
    'rosidl_generator_c/service_type_support_struct.h',
    'rosidl_generator_c/action_type_support_struct.h',
    include_base + '__type_support.h',
    include_base + '__struct.h',
    include_base + '__functions.h',
]
}@
@[for header_file in header_files]@
@[    if header_file in include_directives]@
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
@
@{
module_name = convert_camel_case_to_lower_case_underscore(message.structure.namespaced_type.name)
msg_typename = '__'.join(message.structure.namespaced_type.namespaced_name())
}@

// NOTE(sam): Add create, destroy (and convert) functions?

// NOTE(sam): Is this macro needed?
ROSIDL_GENERATOR_C_EXPORT
void * @('__'.join(message.structure.namespaced_type.namespaces + [module_name]))__get_type_support()
{
    return (void *)ROSIDL_GET_MSG_TYPE_SUPPORT(@(', '.join(message.structure.namespaced_type.namespaced_name())));
}
