// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';

class CrosscheckCommandRunner extends CommandRunner<Null> {
  CrosscheckCommandRunner()
      : super(
          'crosscheck',
          'Automated Dependency Management for Dart',
        ) {
    argParser
      ..addFlag('version', callback: (_) {
        print('crosscheck v0.0.0 running on Dart ${Platform.version}.');
        exit(0);
      }, negatable: false, help: 'Print version number.');
  }
}
