// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

/// Runs pub commands programatically.
class PubCli {
  static const _upgrade = 'pub upgrade';

  /// Runs pub upgrade.
  Future pubUpgrade({bool dryRun = false}) async {
    await Process.run(_upgrade, dryRun ? ['dry-run'] : <String>[]);
  }
}
