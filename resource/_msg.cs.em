// generated from rosidl_generator_cs/resource/_msg.cs.em
// generated code does not contain a copyright notice

@#######################################################################
@# EmPy template for generating _<msg>.cs files
@#
@# Context:
@#  - module_name
@#  - package_name
@#  - spec (rosidl_parser.MessageSpecification)
@#    Parsed specification of the .msg file
@#  - constant_value_to_py (function)
@#  - get_python_type (function)
@#  - value_to_py (function)
@#######################################################################
@
@{
native_methods = 'NativeMethods%s' % (spec.base_type.type)
get_type_support = {'function_name': '%s__msg__%s__get_type_support' % (package_name, module_name)}
}@
using System;
using System.Runtime.InteropServices;

using ROS2.Interfaces;
using ROS2.Utils;

namespace @(package_name)
{

namespace msg
{

internal static class @(native_methods)
{
  private static readonly DllLoadUtils dllLoadUtils = DllLoadUtilsFactory.GetDllLoadUtils();
  private static readonly IntPtr typeSupportEntryPointLibrary = dllLoadUtils.LoadLibrary(
    "@(spec.base_type.pkg_name)__rosidl_typesupport_c__csext");

  [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
  internal delegate IntPtr GetMsgTypeSupportType();
  internal static GetMsgTypeSupportType
      @(get_type_support['function_name']) =
      (GetMsgTypeSupportType) Marshal.GetDelegateForFunctionPointer(dllLoadUtils.GetProcAddress(
      typeSupportEntryPointLibrary,
      "@(get_type_support['function_name'])"),
      typeof(GetMsgTypeSupportType));

  // NOTE(samaim): possibly better to wrap functions in _msg_support.c instaid of accessing directry?
  private static readonly IntPtr typeSupportCLibrary = dllLoadUtils.LoadLibraryNoSuffix(
    "@(spec.base_type.pkg_name)__rosidl_generator_c");
@{
create_message = {'function_name': '%s__msg__%s__create' % (package_name, spec.base_type.type),
                  'args': ''}

destroy_message = {'function_name': '%s__msg__%s__destroy' % (package_name, spec.base_type.type),
                  'args': 'IntPtr msg'}

native_generator_c_methods = [create_message, destroy_message]
}
@[for native_method in native_generator_c_methods]@

  [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
  internal delegate IntPtr @(native_method['function_name'])__type(@(native_method['args']));
  internal static @(native_method['function_name'])__type
      @(native_method['function_name']) =
      (@(native_method['function_name'])__type) Marshal.GetDelegateForFunctionPointer(dllLoadUtils.GetProcAddress(
      typeSupportCLibrary,
      "@(native_method['function_name'])"),
      typeof(@(native_method['function_name'])__type));
@[end for]@

  private static readonly IntPtr messageSupportLibrary = dllLoadUtils.LoadLibrary(
  "@(spec.base_type.pkg_name)__csharp");

@[for field in spec.fields]@
@{
native_method = {'function_name': 'native_read_field_%s' % field.name,
                 'args': 'IntPtr message_handle',
                 'return_type': get_dotnet_type(field.type),
                 'native_library': 'messageSupportLibrary'}
}
  [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
  internal delegate @(native_method['return_type']) @(native_method['function_name'])__type(@(native_method['args']));
  internal static @(native_method['function_name'])__type
      @(native_method['function_name']) =
      (@(native_method['function_name'])__type) Marshal.GetDelegateForFunctionPointer(dllLoadUtils.GetProcAddress(
      @(native_method['native_library']),
      "@(native_method['function_name'])"),
      typeof(@(native_method['function_name'])__type));

@[end for]@

@[for field in spec.fields]@
@{
native_method = {'function_name': 'native_write_field_%s' % field.name,
                 'args': 'IntPtr message_handle, %s value' % get_dotnet_type(field.type),
                 'return_type': 'void',
                 'native_library': 'messageSupportLibrary'}
}
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

public class @(spec.base_type.type)
{
  private IntPtr handle;

  public @(spec.base_type.type)()
  {
    handle = @(native_methods).@(create_message['function_name'])();
  }

  ~@(spec.base_type.type)()
  {
    handle = @(native_methods).@(destroy_message['function_name'])(handle);
  }

  public IntPtr typeSupportHandle
  {
    get
    {
      return @(native_methods).@(get_type_support['function_name'])();
    }
  }

@[for field in spec.fields]@
  public @(field.type) @(field.name)
  {
    get
    {
      return @(native_methods).native_read_field_@(field.name)(handle);
    }
    set
    {
      @(native_methods).native_write_field_@(field.name)(handle, value);
    }
  }
@[end for]@
}

} // msg

} // @(package_name)
