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
import '../pub/pub_cli.dart';
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
        'path',
        defaultsTo: p.current,
        abbr: 'p',
        help: 'Path to the pub package to check.',
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
      final pub = const PubCli();
      log.fine('Attempting "pub upgrade"...');
      await withCopyOf<Null>(results['path'] as String, (path) async {
        log.fine('Running checks on "$path"');
        var results = await analyzer.analyze(path);
        if (results.isNotEmpty) {
          log.severe(''
              'Analysis errors before "pub upgrade".:'
              '\n  - ${results.join('\n  - ')}');
          exitCode = 1;
          return;
        }
        // ignore: prefer_interpolation_to_compose_strings
        log.fine('pub upgrade: \n${await pub.pubUpgrade(path)}');
        results = await analyzer.analyze(path);
        if (results.isEmpty) {
          log.info('No analysis issues.');
        } else {
          log.severe('Results: \n  - ${results.join('\n  - ')}');
        }
      });
    }
    if (config.friends.isNotEmpty) {
      log.fine('Verifying friends...');
      throw new UnimplementedError();
    }
  }
}
