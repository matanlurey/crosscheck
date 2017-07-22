// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:crosscheck/src/common/copying.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('should make a deep copy of a folder', () async {
    final destination = await withCopyOf(
      p.join('_packages', 'has_no_error'),
      (path) async {
        expect(FileSystemEntity.isDirectorySync(path), isTrue);
        expect(
          FileSystemEntity.isFileSync(
            p.join(path, 'lib', 'has_no_error.dart'),
          ),
          isTrue,
        );
        return path;
      },
    );
    expect(FileSystemEntity.isDirectorySync(destination), isFalse);
  });
}
