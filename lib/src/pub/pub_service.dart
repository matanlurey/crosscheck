// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:crosscheck/src/pub/package_info.dart';
import 'package:http/http.dart';
import 'package:pub_semver/pub_semver.dart';

/// A service for fetching data from pub.
class PubService {
  static const _root = 'https://pub.dartlang.org';
  static const _packages = '/api/packages/';
  final BaseClient _client;

  PubService(this._client);

  /// Fetches all package version for a given package [name].
  Future<PackageSummary> fetchPackageInfo(String name) async {
    final response = await _client.get('$_root$_packages$name');
    final result = JSON.decode(response.body) as Map<String, Object>;
    final latest = result['latest'] as Map<String, Object>;
    final latestVersion =
        new VersionConstraint.parse(latest['version'] as String);
    final allVersions = <VersionConstraint>[];
    for (var version in result['versions'] as List) {
      allVersions
          .add(new VersionConstraint.parse(version['version'] as String));
    }
    return new PackageSummary(name, latestVersion, allVersions);
  }
}
