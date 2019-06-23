// generated from rosidl_generator_cs/resource/_idl_pkg_typesupport_entry_point.c.em
// generated code does not contain a copyright notice
@
@#######################################################################
@# EmPy template for generating _<pkg>_s.ep.<ts>.c files
@#
@# Context:
@#  - package_name (string)
@#  - content (IdlContent, combined list of elements across all interface files
@#  - typesupport_impl (string identifying the typesupport used)
@#######################################################################
@
@#######################################################################
@# Handle messages
@#######################################################################

@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore
from rosidl_parser.definition import Message

include_directives = set()
register_functions = []
}@

@
@[for message in content.get_elements_of_type(Message)]@

@{
TEMPLATE(
    '_msg_pkg_typesupport_entry_point.c.em',
    package_name=package_name, idl_type=message.structure.namespaced_type, message=message,
    typesupport_impl=typesupport_impl, include_directives=include_directives,
    register_functions=register_functions)
}@
@[end for]@
@
@#######################################################################
@# Handle services
@#######################################################################
@{
from rosidl_parser.definition import Service
}@
@[for service in content.get_elements_of_type(Service)]@

@{
TEMPLATE(
    '_srv_pkg_typesupport_entry_point.c.em',
    package_name=package_name, idl_type=service.namespaced_type,
    service=service, typesupport_impl=typesupport_impl,
    include_directives=include_directives,
    register_functions=register_functions)
}@
@[end for]@
@
@#######################################################################
@# Handle actions
@#######################################################################
@{
from rosidl_parser.definition import Action
}@
@[for action in content.get_elements_of_type(Action)]@

@{
TEMPLATE(
    '_action_pkg_typesupport_entry_point.c.em',
    package_name=package_name, idl_type=action.namespaced_type,
    action=action, typesupport_impl=typesupport_impl,
    include_directives=include_directives,
    register_functions=register_functions)
}@
@[end for]@
