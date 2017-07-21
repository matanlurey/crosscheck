// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:crosscheck/src/bin/runner.dart';
import 'package:crosscheck/src/common/logging.dart';
import 'package:logging/logging.dart';

void main(List<String> args) => runLogged<Null>(
      () {
        new CrosscheckCommandRunner().run(args);
        return null;
      },
      onLog: (record) {
        // TODO: Make logging verbosity configurable and potentially to file.
        if (record.level >= Level.SEVERE) {
          stderr.writeln(record.message);
        } else {
          stdout.writeln(record.message);
        }
      },
    );
