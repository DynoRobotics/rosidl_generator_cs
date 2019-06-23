# Copyright 2014-2016 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from ast import literal_eval
from collections import defaultdict
import os
import pathlib

from rosidl_cmake import convert_camel_case_to_lower_case_underscore
from rosidl_cmake import expand_template
from rosidl_cmake import generate_files
from rosidl_cmake import get_newest_modification_time
from rosidl_cmake import read_generator_arguments
# from rosidl_generator_c import primitive_msg_type_to_c
# from rosidl_parser import parse_message_file
# from rosidl_parser import parse_service_file

from rosidl_parser.definition import IdlContent
from rosidl_parser.definition import IdlLocator

from rosidl_parser.parser import parse_idl_file

import logging


from rosidl_parser.definition import Message


def generate_cs(generator_arguments_file, typesupport_impls):
    logging.warn("Generating .NET interface code")

    mapping = {
        '_idl.cs.em': '_%s.cs',
        '_idl_support.c.em': '_%s_s.c',
    }
    generate_files(generator_arguments_file, mapping)

    args = read_generator_arguments(generator_arguments_file)
    package_name = args['package_name']

    modules = {}
    idl_content = IdlContent()
    for idl_tuple in args.get('idl_tuples', []):
        idl_parts = idl_tuple.rsplit(':', 1)
        assert len(idl_parts) == 2

        idl_rel_path = pathlib.Path(idl_parts[1])
        idl_stems = modules.setdefault(str(idl_rel_path.parent), set())
        idl_stems.add(idl_rel_path.stem)

        locator = IdlLocator(*idl_parts)
        idl_file = parse_idl_file(locator)
        idl_content.elements += idl_file.content.elements

    template_dir = args['template_dir']
    type_support_impl_by_filename = {
        '_%s_s.ep.{0}.c'.format(impl): impl for impl in typesupport_impls
    }
    mapping_msg_pkg_extension = {
        os.path.join(template_dir, '_idl_pkg_typesupport_entry_point.c.em'):
        type_support_impl_by_filename.keys(),
    }

    for template_file in mapping_msg_pkg_extension.keys():
        assert os.path.exists(template_file), 'Could not find template: ' + template_file

    latest_target_timestamp = get_newest_modification_time(args['target_dependencies'])

    for template_file, generated_filenames in mapping_msg_pkg_extension.items():
        for generated_filename in generated_filenames:
            package_name = args['package_name'],
            data = {
                'package_name': args['package_name'],
                'content': idl_content,
                'typesupport_impl': type_support_impl_by_filename.get(generated_filename, ''),
            }
            generated_file = os.path.join(
                args['output_dir'], generated_filename % package_name
            )
            expand_template(
                template_file, data, generated_file,
                minimum_timestamp=latest_target_timestamp)

    return 0


def get_builtin_dotnet_type(type_, use_primitives=True):
    if type_ == 'bool':
        return 'bool' if use_primitives else 'System.Boolean'

    if type_ == 'byte':
        return 'byte' if use_primitives else 'System.Byte'

    if type_ == 'char':
        return 'char' if use_primitives else 'System.Char'

    if type_ == 'float32':
        return 'float' if use_primitives else 'System.Single'

    if type_ == 'float64':
        return 'double' if use_primitives else 'System.Double'

    if type_ == 'int8':
        return 'sbyte' if use_primitives else 'System.Sbyte'

    if type_ == 'uint8':
        return 'byte' if use_primitives else 'System.Byte'

    if type_ == 'int16':
        return 'short' if use_primitives else 'System.Int16'

    if type_ == 'uint16':
        return 'ushort' if use_primitives else 'System.UInt16'

    if type_ == 'int32':
        return 'int' if use_primitives else 'System.Int32'

    if type_ == 'uint32':
        return 'uint' if use_primitives else 'System.UInt32'

    if type_ == 'int64':
        return 'long' if use_primitives else 'System.Int64'

    if type_ == 'uint64':
        return 'ulong' if use_primitives else 'System.UInt64'

    if type_ == 'string':
        return 'System.String'

    assert False, "unknown type '%s'" % type_


def get_dotnet_type(type_, use_primitives=True):
    if not type_.is_primitive_type():
        return type_.pkg_name + ".msg." + type_.type

    return get_builtin_dotnet_type(type_.type, use_primitives=use_primitives)
