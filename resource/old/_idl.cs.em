# generated from rosidl_generator_cs/resource/_idl.cs.em
# with input from @(package_name):@(interface_path)
# generated code does not contain a copyright notice
@
@#######################################################################
@# EmPy template for generating _<idl>.cs files
@#
@# Context:
@#  - package_name (string)
@#  - interface_path (Path relative to the directory named after the package)
@#  - content (IdlContent, list of elements, e.g. Messages or Services)
@#######################################################################
@{
import_statements = set()
}@
@
@#######################################################################
@# Handle messages
@#######################################################################
@{
from rosidl_parser.definition import Message
}@
@[for message in content.get_elements_of_type(Message)]@
@{
TEMPLATE(
    '_msg.cs.em',
    package_name=package_name, interface_path=interface_path, message=message,
    import_statements=import_statements)
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
    '_srv.cs.em',
    package_name=package_name, interface_path=interface_path, service=service,
    import_statements=import_statements)
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
    '_action.cs.em',
    package_name=package_name, interface_path=interface_path, action=action,
    import_statements=import_statements)
}@
@[end for]@