// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:crosscheck/src/pub/package_info.dart';
import 'package:yaml/yaml.dart';
import 'package:pub_semver/pub_semver.dart';

/// The parsed contents of a pubspec file.
///
/// Shamelessly copied from https://github.com/dart-lang/pub/blob/master/lib/src/pubspec.dart.
class Pubspec {
  /// All pubspec fields.
  final YamlMap fields;

  String _name;
  VersionConstraint _version;
  List<PackageRange> _dependencies;
  List<PackageRange> _devDependencies;

  Pubspec(this.fields);

  /// The package name.
  ///
  /// Throws [Exception] if the name is missing or invalid.
  String get name {
    if (_name != null) return _name;

    final Object name = fields['name'];
    if (name == null || name is! String) {
      throw new Exception('Invalid packaged name: $name');
    }
    _name = name as String;
    return _name;
  }

  /// The package version.
  ///
  /// Throws [Exception] if the version is missing or invalid.
  VersionConstraint get version {
    if (_version != null) return _version;

    final Object version = fields['version'];
    if (version == null) {
      _version = Version.none;
      return _version;
    }
    if (version is! String) {
      throw new Exception('version must be a string');
    }
    _version = new VersionConstraint.parse(version as String);
    return _version;
  }

  /// The package's dependencies.
  List<PackageRange> get dependencies {
    _dependencies ??=
        _parseDependencies('dependencies', fields.nodes['dependencies']);
    return _dependencies;
  }

  /// The package's dev dependencies.
  List<PackageRange> get devDependencies {
    _devDependencies ??= _parseDependencies(
        'dev_dependencies', fields.nodes['dev_dependencies']);
    return _devDependencies;
  }

  /// Parses the dependency field named [field], and returns the corresponding
  /// list of dependencies.
  List<PackageRange> _parseDependencies(String field, YamlNode node) {
    final dependencies = <PackageRange>[];

    /// Has no dependencies.
    if (node == null || node.value == null) return dependencies;
    final dependencyMap = node as YamlMap;
    dependencyMap.nodes.forEach((YamlNode nameNode, YamlNode specNode) {
      final name = nameNode.value as String;
      final spec = specNode.value as Object;
      VersionConstraint versionConstraint = new VersionRange();

      if (spec is String) {
        versionConstraint = _parseVersionConstraint(specNode);
      } else if (spec is Map) {
        final specMap = specNode as YamlMap;
        final specCopy = new Map<String, YamlNode>.from(spec);

        if (specCopy.containsKey('version')) {
          specCopy.remove('version');
          versionConstraint = _parseVersionConstraint(specMap.nodes['version']);
        }
      }
      dependencies.add(new PackageRange(name, versionConstraint));
    });
    return dependencies;
  }

  VersionConstraint _parseVersionConstraint(YamlNode node,
      {VersionConstraint defaultConstraint}) {
    if (node?.value == null) return defaultConstraint;
    if (node.value is! String) {
      throw new Exception('A version constraint must be a  string');
    }
    return new VersionConstraint.parse(node.value as String);
  }
}
