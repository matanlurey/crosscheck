// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:crosscheck/src/checks/analyzer.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  final analyzer = const DartAnalyzer();

  test('should detect a strong-mode error', () async {
    final result = await analyzer.analyze(p.join(
      'package',
      'has_analysis_error',
    ));
    expect(result, isNotEmpty);
  });

  test('should clear an error-less package', () async {
    final result = await analyzer.analyze(p.join(
      'package',
      'has_no_error',
    ));
    expect(result, isEmpty);
  });
}
