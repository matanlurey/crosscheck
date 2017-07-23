// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:crosscheck/src/common/logging.dart';
import 'package:crosscheck/src/pub/package_info.dart';
import 'package:crosscheck/src/pub/pubspec_parser.dart';
import 'package:crosscheck/src/pub/pub_service.dart';
import 'package:http/http.dart';
import 'package:yaml/yaml.dart';

/// Runs pub commands programmatically.
class PubCli {
  static final _pubService = new PubService(new IOClient(new HttpClient()));

  final String _executable;

  const PubCli({String command: 'pub'}) : _executable = command;

  /// Runs `pub get` inside of [path].
  Future<String> get(String path) async {
    final result = await Process.run(
      _executable,
      const ['get'],
      workingDirectory: path,
    );
    final stderr = result.stderr.toString();
    if (stderr.isNotEmpty) {
      return stderr;
    }
    final stdout = result.stdout.toString();
    return stdout;
  }

  /// Runs pub upgrade inside of [path].
  ///
  /// May optionally define [dryRun].
  Future<String> pubUpgrade(String path, {bool dryRun = false}) async {
    final result = (await Process.run(
      _executable,
      dryRun ? const ['upgrade ', '--dry-run'] : const ['upgrade'],
      workingDirectory: path,
    ));
    final stderr = result.stderr.toString();
    if (stderr.isNotEmpty) {
      return stderr;
    }
    final stdout = result.stdout.toString();
    return stdout;
  }

  /// Expands all dependencies to the latest version.
  Future<Null> pubExpand({bool dryRun = false}) async {
    final rawPub = await new File('pubspec.yaml').readAsString();
    final pubspec = new Pubspec(loadYaml(rawPub) as YamlMap);
    final depFutures = pubspec.dependencies.map<Future<PackageSummary>>((dep) {
      return _pubService.fetchPackageInfo(dep.name);
    });
    final summaries = await Future.wait(depFutures);
    final newDeps = <String, String>{};
    for (var summary in summaries) {
      newDeps[summary.name] = summary.latest.toString();
    }
    final newMap = new Map<String, Object>.from(pubspec.fields);
    newMap['dependencies'] = newDeps;
    final newPubspec = new YamlMap.wrap(newMap);
    if (dryRun) {
      info('Would pubspec: ${newPubspec.toString()}');
      return;
    }
    await new File('$pubspec.yaml').writeAsString(newPubspec.toString());
  }
}
