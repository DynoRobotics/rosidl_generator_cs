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

  // NOTE(samaim): possibly better to wrap functions in _msg_support.c instaid of accessing directry?
  private static readonly IntPtr typeSupportCLibrary = dllLoadUtils.LoadLibraryNoSuffix(
    "@(spec.base_type.pkg_name)__rosidl_generator_c");

  private static readonly IntPtr messageSupportLibrary = dllLoadUtils.LoadLibrary(
  "@(spec.base_type.pkg_name)__csharp");

@{
get_type_support = {'function_name': '%s__msg__%s__get_type_support' % (package_name, module_name),
                    'args': '',
                    'return_type': 'IntPtr',
                    'native_library': 'typeSupportEntryPointLibrary'}

create_message = {'function_name': '%s__msg__%s__create' % (package_name, spec.base_type.type),
                  'args': '',
                  'return_type': 'IntPtr',
                  'native_library': 'typeSupportCLibrary'}

destroy_message = {'function_name': '%s__msg__%s__destroy' % (package_name, spec.base_type.type),
                   'args': 'IntPtr msg',
                   'return_type': 'IntPtr',
                   'native_library': 'typeSupportCLibrary'}

native_generator_c_methods = [create_message, destroy_message]

native_read_field_methods = []
native_write_field_methods = []
for field in spec.fields:
  native_read_field_methods.append(
    {'function_name': 'native_read_field_%s' % field.name,
     'args': 'IntPtr message_handle',
     'return_type': get_dotnet_type(field.type),
     'native_library': 'messageSupportLibrary'})

  native_write_field_methods.append(
    {'function_name': 'native_write_field_%s' % field.name,
     'args': 'IntPtr message_handle, %s value' % get_dotnet_type(field.type),
     'return_type': 'void',
     'native_library': 'messageSupportLibrary'})

native_methods_list = []
native_methods_list.append(get_type_support)
native_methods_list.extend(native_generator_c_methods)
native_methods_list.extend(native_read_field_methods)
native_methods_list.extend(native_write_field_methods)
}

@[for native_method in native_methods_list]@
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
