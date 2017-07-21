// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Global configuration options for executing the `crosscheck` command.
class Crosscheck {
  /// Names of packages that are considered "friends" of your package.
  final List<String> friends;

  const Crosscheck({
    this.friends: const [],
  });
}
