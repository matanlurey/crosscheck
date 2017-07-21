// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import '../checks/analyzer.dart';
import '../common/copying.dart';
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
      ..addFlag(
        'upgrade',
        defaultsTo: true,
        negatable: true,
        help: 'Whether to verify if "pub upgrade" would succeed.',
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
      return _runDefaultCommand(results);
    }
    return super.runCommand(results);
  }

  Future<Null> _runDefaultCommand(ArgResults results) async {
    final config = new Crosscheck(
      checkUpgrade: results['upgrade'] as bool,
      friends: results['friend'] as List<String>,
    );
    log.info('Running crosscheck...');
    if (config.checkUpgrade) {
      final analyzer = const DartAnalyzer();
      log.fine('Attempting "pub upgrade"...');
      await withCopyOf<Null>(p.current, (path) async {
        // TODO: Add the actual pub upgrade logic here.
        print('Path: $path');
        final results = await analyzer.analyze(path);
        if (results.isEmpty) {
          print('No analysis issues.');
        } else {
          print('Results: \n  - ${results.join('\n  - ')}');
        }
      });
    }
    if (config.friends.isNotEmpty) {
      log.fine('Verifying friends...');
      throw new UnimplementedError();
    }
  }
}
