// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:crosscheck/src/common/logging.dart';
import 'package:crosscheck/src/pub/package_info.dart';
import 'package:crosscheck/src/pub/pubspec_parser.dart';
import 'package:http/http.dart';
import 'package:crosscheck/src/pub/pub_service.dart';
import 'package:yaml/yaml.dart';
import 'package:logging/logging.dart';

/// Runs pub commands programatically.
class PubCli {
  final _pubService = new PubService(new IOClient(new HttpClient()));
  static const _upgrade = 'pub upgrade';

  /// Runs pub upgrade.
  Future pubUpgrade({bool dryRun = false}) async {
    await Process.run(_upgrade, dryRun ? ['dry-run'] : <String>[]);
  }

  /// Expands all depdencies to the lastest version.
  Future pubExpand({bool dryRun = false}) async {
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
    final newRaw = newMap.toString();
    info('Upgraded pubspec: $newRaw');
  }
}
