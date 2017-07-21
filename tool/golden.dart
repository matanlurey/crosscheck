// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:crosscheck/src/bin/version.dart';

/// Bumps any recorded "golden" files or attributes across the package.
///
/// For example, the package's "version" (from pubspec.yaml) is recorded.
void main() {
  _writePubVersion(readPubVersion());
}

void _writePubVersion(String version) {
  final file = new File('lib/src/bin/version.dart');
  var contents = file.readAsStringSync();
  contents = contents.replaceAll(
    new RegExp(r"/\*VERSION\*/'([^']*)'/\*VERSION\*/"),
    "/*VERSION*/'$version'/*VERSION*/",
  );
  file.writeAsStringSync(contents);
}
