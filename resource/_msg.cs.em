@# Included from rosidl_generator_cs/resource/_idl.cs.em

// msg.cs
@{
from rosidl_generator_cs.generate_cs_impl import get_dotnet_type
from rosidl_parser.definition import AbstractGenericString
from rosidl_parser.definition import AbstractNestedType
from rosidl_parser.definition import AbstractSequence
from rosidl_parser.definition import AbstractWString
from rosidl_parser.definition import ACTION_FEEDBACK_SUFFIX
from rosidl_parser.definition import ACTION_GOAL_SUFFIX
from rosidl_parser.definition import ACTION_RESULT_SUFFIX
from rosidl_parser.definition import Array
from rosidl_parser.definition import BasicType
from rosidl_parser.definition import BOOLEAN_TYPE
from rosidl_parser.definition import BoundedSequence
from rosidl_parser.definition import CHARACTER_TYPES
from rosidl_parser.definition import FLOATING_POINT_TYPES
from rosidl_parser.definition import INTEGER_TYPES
from rosidl_parser.definition import NamespacedType
from rosidl_parser.definition import SIGNED_INTEGER_TYPES
from rosidl_parser.definition import UnboundedSequence
from rosidl_parser.definition import UNSIGNED_INTEGER_TYPES
}

using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using ROS2.Interfaces;
using ROS2.Utils;

@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore
module_name = convert_camel_case_to_lower_case_underscore(message.structure.namespaced_type.name)
msg_typename = '__'.join(message.structure.namespaced_type.namespaced_name())
package_name = message.structure.namespaced_type.namespaced_name()[0]
native_methods = 'NativeMethods__%s' % msg_typename
}@

namespace @(package_name)
{

namespace msg
{

internal static class @(native_methods)
{
  private static readonly DllLoadUtils dllLoadUtils = DllLoadUtilsFactory.GetDllLoadUtils();

  private static readonly IntPtr typeSupportEntryPointLibrary = dllLoadUtils.LoadLibrary(
    "@(package_name)__rosidl_typesupport_c__csext");

  // NOTE(sam): Possibly better to wrap functions in _msg_support.c instaid of accessing directry?
  private static readonly IntPtr typeSupportCLibrary = dllLoadUtils.LoadLibraryNoSuffix(
    "@(package_name)__rosidl_generator_c");

  private static readonly IntPtr messageSupportLibrary = dllLoadUtils.LoadLibrary(
  "@(package_name)__csharp");
@{
get_type_support = {'function_name': '%s__get_type_support' % msg_typename,
                    'args': '',
                    'return_type': 'IntPtr',
                    'native_library': 'typeSupportEntryPointLibrary'}

create_message = {'function_name': '%s__create' % msg_typename,
                  'args': '',
                  'return_type': 'IntPtr',
                  'native_library': 'typeSupportCLibrary'}

destroy_message = {'function_name': '%s__destroy' % msg_typename,
                   'args': 'IntPtr msg',
                   'return_type': 'IntPtr',
                   'native_library': 'typeSupportCLibrary'}

native_generator_c_methods = [create_message, destroy_message]

native_read_field_methods = []
native_write_field_methods = []
native_init_field_methods = []

for member in message.structure.members:
  if isinstance(member.type, BasicType):

    msg_full_name = '__'.join(
      message.structure.namespaced_type.namespaces +
      [convert_camel_case_to_lower_case_underscore(message.structure.namespaced_type.name)] +
      [member.name])

    # TODO(sam): check if string
    read_return_type = get_dotnet_type(member.type)
    write_args = 'IntPtr message_handle, %s value' % get_dotnet_type(member.type)

    native_read_field_methods.append(
      {'function_name': '%s__native_read' % (msg_full_name),
       'args': 'IntPtr message_handle',
       'return_type': read_return_type,
       'native_library': 'messageSupportLibrary'})

    native_write_field_methods.append(
      {'function_name': '%s__native_write' % (msg_full_name),
       'args': write_args,
       'return_type': 'void',
       'native_library': 'messageSupportLibrary'})


native_methods_list = []
native_methods_list.append(get_type_support)
native_methods_list.extend(native_generator_c_methods)
native_methods_list.extend(native_read_field_methods)
native_methods_list.extend(native_write_field_methods)
native_methods_list.extend(native_init_field_methods)
}

@[for native_method in native_methods_list]@
  // @(native_method['function_name'])
  [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
  internal delegate @(native_method['return_type']) @(native_method['function_name'])__type(@(native_method['args']));
  internal static @(native_method['function_name'])__type
      @(native_method['function_name']) =
      (@(native_method['function_name'])__type) Marshal.GetDelegateForFunctionPointer(dllLoadUtils.GetProcAddress(
      @(native_method['native_library']),
      "@(native_method['function_name'])"),
      typeof(@(native_method['function_name'])__type));

@[end for]@

}

public class @(message.structure.namespaced_type.name): IRclcsMessage
{
private IntPtr handle;

  private bool disposed;
  private bool isTopLevelMsg;

  public @(message.structure.namespaced_type.name)()
  {
    isTopLevelMsg = true;
    handle = @(native_methods).@(create_message['function_name'])();
    //SetNestedHandles();
  }

  public void Dispose()
  {
    if(!disposed)
    {
      if(isTopLevelMsg)
      {
        handle = @(native_methods).@(destroy_message['function_name'])(handle);
        disposed = true;
      }
    }
  }

  ~@(message.structure.namespaced_type.name)()
  {
    Dispose();
  }

  public static IntPtr _GET_TYPE_SUPPORT()
  {
    return @(native_methods).@(get_type_support['function_name'])();
  }

  public IntPtr TypeSupportHandle
  {
    get
    {
      return _GET_TYPE_SUPPORT();
    }
  }

  public IntPtr Handle
  {
    get
    {
      return handle;
    }
  }

@[for member in message.structure.members]@
@[  if isinstance(member.type, BasicType)]
@{
msg_full_name = '__'.join(
  message.structure.namespaced_type.namespaces +
  [convert_camel_case_to_lower_case_underscore(message.structure.namespaced_type.name)] +
  [member.name])
}
  public @(get_dotnet_type(member.type)) @(member.name)
  {
    get
    {
      //TODO(sam): add string support
      return @(msg_full_name)__native_read(handle);
    }
    set
    {
      return @(msg_full_name)__native_write(handle, value);
    }
  }
@[  end if]
@[end for]@

}

} // msg

} // package
