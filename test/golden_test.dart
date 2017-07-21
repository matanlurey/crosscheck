// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:crosscheck/src/bin/version.dart' as golden;

import 'package:test/test.dart';

void main() {
  test('should have an updated package number', () {
    expect(
      golden.version,
      golden.readPubVersion(),
      reason: 'Version number out of sync. Run "dart tool/golden.dart".',
    );
  });
}
