// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:crosscheck/src/pub/package_info.dart';
import 'package:crosscheck/src/pub/pubspec_parser.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

const expectedMainVersion = '0.1.0';
const expectedVersion = '^1.3.0';
const testYamlFile = '''
  name: crosscheck
  description: >
    Automated Dependency Management for Dart.
  version: $expectedMainVersion
  authors:
    - Dart Team <misc@dartlang.org>
  homepage: https://github.com/matanlurey/crosscheck

  environment:
    sdk: '>=1.24.0 <2.0.0-dev.infinity'

  dependencies:
    yaml: "$expectedVersion"
    pub_semver: "$expectedVersion"
    path: "$expectedVersion"

  dev_dependencies:
    test:

  executables:
    crosscheck:
  ''';

void main() {
  group('Pubspec', () {
    test('can parse a pubspec file and it\'s dependencies', () {
      final yaml = loadYaml(testYamlFile) as YamlMap;
      final pubspec = new Pubspec(yaml);
      final expectedConstraint = new VersionConstraint.parse(expectedVersion);

      expect(pubspec.name, 'crosscheck');
      expect(
          pubspec.dependencies,
          unorderedEquals(<PackageRange>[
            new PackageRange('yaml', expectedConstraint),
            new PackageRange('pub_semver', expectedConstraint),
            new PackageRange('path', expectedConstraint),
          ]));
      expect(pubspec.version, new VersionConstraint.parse(expectedMainVersion));
    });

    test('produces a minimal yaml from toString()', () {
      final yaml = loadYaml(testYamlFile) as YamlMap;
      final pubspec = new Pubspec(yaml);
      final minimal = loadYaml(pubspec.toString()) as YamlMap;

      expect(minimal['name'], 'crosscheck');
      expect(minimal['dependencies'], {
        'yaml': '$expectedVersion',
        'pub_semver': '$expectedVersion',
        'path': '$expectedVersion',
      });
    });
  });
}
