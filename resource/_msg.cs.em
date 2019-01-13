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
using System;
using System.Runtime.InteropServices;

using ROS2.Interfaces;
using ROS2.Utils;

namespace @(package_name)
{

namespace msg
{

public class @(spec.base_type.type)
{
  [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
  internal delegate int NativeGetNumberHandleType();

  public int TestValue
  {
    get
    {
      DllLoadUtils dllLoadUtils;
      dllLoadUtils = DllLoadUtilsFactory.GetDllLoadUtils();
      IntPtr nativelibrary = dllLoadUtils.LoadLibrary("rosidl_generator_cs_custom__csharp");

      NativeGetNumberHandleType GetNumber =
      (NativeGetNumberHandleType)Marshal.GetDelegateForFunctionPointer(
      dllLoadUtils.GetProcAddress(nativelibrary, "bool_get_number"),
      typeof(NativeGetNumberHandleType));

      return GetNumber();
    }
  }
}

} // msg

} // @(package_name)
