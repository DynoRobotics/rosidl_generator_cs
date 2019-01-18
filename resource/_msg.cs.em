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
using System.Collections.Generic;
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

  // NOTE(samaim): Possibly better to wrap functions in _msg_support.c instaid of accessing directry?
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
  if field.type.is_array:
    write_args = 'IntPtr message_handle, [MarshalAs (UnmanagedType.LPArray, SizeParamIndex=0)] %s[] data, int size' % get_dotnet_type(field.type)
    if field.type.type == 'string':
      native_read_field_methods.append(
        {'function_name': '%s_native_get_string_by_index_%s' % (module_name, field.name),
         'args': 'IntPtr message_handle, int index',
         'return_type': 'string',
         'native_library': 'messageSupportLibrary'})

      write_args = 'IntPtr message_handle, [MarshalAsAttribute(UnmanagedType.LPArray, ArraySubType=UnmanagedType.LPStr)] String[] data, int size'
    else:
      native_read_field_methods.append(
        {'function_name': '%s_native_get_array_ptr_%s' % (module_name, field.name),
         'args': 'IntPtr message_handle',
         'return_type': 'IntPtr',
         'native_library': 'messageSupportLibrary'})


    native_read_field_methods.append(
      {'function_name': '%s_native_get_size_%s' % (module_name, field.name),
       'args': 'IntPtr message_handle',
       'return_type': 'int',
       'native_library': 'messageSupportLibrary'})


    native_write_field_methods.append(
      {'function_name': '%s_native_set_array_%s' % (module_name, field.name),
       'args': write_args,
       'return_type': 'bool',
       'native_library': 'messageSupportLibrary'})

  else:
    read_return_type = get_dotnet_type(field.type)
    write_args = 'IntPtr message_handle, %s value' % get_dotnet_type(field.type)

    if field.type.type == 'string':
      read_return_type = 'IntPtr'
      write_args = 'IntPtr message_handle, [MarshalAs (UnmanagedType.LPStr)] string value'

    native_read_field_methods.append(
      {'function_name': '%s_native_read_field_%s' % (module_name, field.name),
       'args': 'IntPtr message_handle',
       'return_type': read_return_type,
       'native_library': 'messageSupportLibrary'})

    native_write_field_methods.append(
      {'function_name': '%s_native_write_field_%s' % (module_name, field.name),
       'args': write_args,
       'return_type': 'void',
       'native_library': 'messageSupportLibrary'})

native_methods_list = []
native_methods_list.append(get_type_support)
native_methods_list.extend(native_generator_c_methods)
native_methods_list.extend(native_read_field_methods)
native_methods_list.extend(native_write_field_methods)
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

public class @(spec.base_type.type): IRclcsMessage
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

@[for field in spec.fields]@
@[  if field.type.is_array]
  public List<@(get_dotnet_type(field.type))> @(field.name)
  {
    get
    {
      unsafe
      {
@[      if field.type.type == 'string']
        List<string> dataList = new List<string>();

        int size = @(native_methods).@(module_name)_native_get_size_@(field.name)(handle);
        string str;
        for(int i = 0; i < size; i++)
        {
          str = @(native_methods).@(module_name)_native_get_string_by_index_@(field.name)(handle, i);
  				dataList.Add(str);
        }

        return dataList;
@[      else]
        int size = @(native_methods).@(module_name)_native_get_size_@(field.name)(handle);

        List<@(get_dotnet_type(field.type))> dataList = new List<@(get_dotnet_type(field.type))>();

        @(get_dotnet_type(field.type))* data =  (@(get_dotnet_type(field.type))*)@(native_methods).@(module_name)_native_get_array_ptr_@(field.name)(handle);
        for (int i = 0; i < size; i++)
        {
          @(get_dotnet_type(field.type)) value = data[i];
          dataList.Add(value);
        }
        return dataList;
@[      end if]
      }
    }
    set
    {
      unsafe
      {
@[      if field.type.type == 'string']
          string[] stringArray = new string[value.Count];
          for(int i = 0; i < value.Count; i++)
          {
            stringArray[i] = value[i];
          }

          @(native_methods).@(module_name)_native_set_array_@(field.name)(handle, stringArray, stringArray.Length);

@[      else]
        @(get_dotnet_type(field.type))[] data = new @(get_dotnet_type(field.type))[value.Count];
        for (int i = 0; i < value.Count; i++)
        {
          data[i] = value[i];
        }
        @(native_methods).@(module_name)_native_set_array_@(field.name)(handle, data, value.Count);
@[      end if]
      }
    }
  }

@[  else]@
@[    if field.type.is_primitive_type()]@
  public @(get_dotnet_type(field.type)) @(field.name)
  {
    get
    {
@[      if field.type.type == 'string']@
      return Marshal.PtrToStringAnsi(@(native_methods).@(module_name)_native_read_field_@(field.name)(handle));
@[      else]@
      return @(native_methods).@(module_name)_native_read_field_@(field.name)(handle);
@[      end if]@
    }
    set
    {
      @(native_methods).@(module_name)_native_write_field_@(field.name)(handle, value);
    }
  }
@[    else]@
// TODO(samiam): Nested types are not supported
@[    end if]
@[  end if]
@[end for]@
}

} // msg

} // @(package_name)
