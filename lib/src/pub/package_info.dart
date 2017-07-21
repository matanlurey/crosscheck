// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:pub_semver/pub_semver.dart';

/// A package name and constraint.
class PackageRange {
  final String name;
  final VersionConstraint constraint;

  PackageRange(this.name, this.constraint);

  @override
  bool operator ==(Object other) =>
      other is PackageRange &&
      name == other.name &&
      !constraint.intersect(other.constraint).isEmpty;
  
  @override
  int get hashCode => name.hashCode ^ constraint.hashCode;

  @override
  String toString() => '{name: $name, constraint: $constraint}';
}

/// A summary of all versions of a package.
class PackageSummary {
  final String name;
  final VersionConstraint latest;
  final List<VersionConstraint> ranges;

  PackageSummary(this.name, this.latest, this.ranges);

  @override
  String toString() => '{name: $name, latest: $latest, '
      'versions: ${ranges.join(', ')}}';
}
