// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart' as yaml;

/// Returns the current version of this package as defined in `pubspec.yaml`.
@visibleForTesting
String readPubVersion() {
  final pubspec = yaml.loadYaml(
    new File('pubspec.yaml').readAsStringSync(),
    sourceUrl: 'pubspec.yaml',
  ) as Map<Object, Object>;
  return pubspec['version'].toString();
}

/// Current version of this package.
///
/// Updated automatically by `tool/golden.dart`.
const version = /*VERSION*/ '0.1.0' /*VERSION*/;
