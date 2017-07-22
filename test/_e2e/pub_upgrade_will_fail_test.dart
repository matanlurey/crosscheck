// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@Timeout.factor(2.0)
import 'package:crosscheck/src/bin/runner.dart';
import 'package:crosscheck/src/common/logging.dart';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  final logs = <String>[];
  void onLog(LogRecord r) => logs.add('[${r.level}]: ${r.message}');
  tearDown(logs.clear);

  test('"pub_upgrade_fails" reports analysis errors', () async {
    await runLogged(() async {
      await new CrosscheckCommandRunner().run([
        '-p',
        p.join(
          '_packages',
          'pub_upgrade_fails',
        ),
      ]);
      // TODO: Expect something more concrete once we have --machine.
      expect(logs.join(''), contains('[SEVERE]: Results:'));
    }, onLog: onLog);
  });
}
