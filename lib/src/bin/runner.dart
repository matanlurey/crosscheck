// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../common/logging.dart' as log;
import 'config.dart';
import 'version.dart';

class CrosscheckCommandRunner extends CommandRunner<Null> {
  static const _name = 'crosscheck';
  static const _desc = 'Automated Dependnecy Management for Dart';

  CrosscheckCommandRunner() : super(_name, _desc) {
    argParser
      ..addFlag(
        'version',
        callback: (passed) {
          if (passed) {
            print('crosscheck $version running on Dart ${Platform.version}.');
            exit(0);
          }
        },
        negatable: false,
        help: 'Print version number.',
      )
      ..addOption(
        'friend',
        allowMultiple: true,
        help: 'Name of a package that should be checked for compatibility.',
      );
  }

  @override
  Future<Null> runCommand(ArgResults results) async {
    if (results.rest.isEmpty) {
      _runDefaultCommand(results);
      return null;
    }
    return super.runCommand(results);
  }

  void _runDefaultCommand(ArgResults results) {
    final config = new Crosscheck(
      friends: results['friend'] as List<String>,
    );
    log.info('Running crosscheck...');
    if (config.friends.isNotEmpty) {
      log.fine('Will verify friends: \n  - ${config.friends.join('\n  - ')}');
    }
    // TODO: Actually do something.
  }
}
