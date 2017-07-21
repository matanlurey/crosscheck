// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

/// Runs the dart analyzer on a package or files in a package.
class DartAnalyzer {
  final String _executable;

  const DartAnalyzer({
    String command: 'dartanalyzer',
  })
      : _executable = command;

  /// Returns a collection of errors or warnings that are considered failures.
  ///
  /// This varies from project to project based on _analysis options_.
  Future<Iterable<AnalysisResult>> analyze(String path) async {
    final result = await Process.run(_executable, [
      '--format=machine',
      path,
    ]);
    return const LineSplitter().convert(result.stderr as String).map((line) {
      final parts = line.split('|');
      var type = AnalysisResultType.unknown;
      switch (parts[0]) {
        case 'ERROR':
          type = AnalysisResultType.error;
          break;
        case 'WARNING':
          type = AnalysisResultType.warning;
          break;
        case 'LINT':
          type = AnalysisResultType.lint;
          break;
      }
      return new AnalysisResult(
        type: type,
        path: parts[3],
        message: parts[7],
      );
    });
  }
}

class AnalysisResult {
  final AnalysisResultType type;
  final String path;
  final String message;

  const AnalysisResult({
    @required this.type,
    @required this.path,
    @required this.message,
  });

  @override
  bool operator ==(Object o) =>
      o is AnalysisResult &&
      type == o.type &&
      path == o.path &&
      message == o.message;

  @override
  int get hashCode => type.hashCode ^ path.hashCode ^ message.hashCode;

  @override
  String toString() => 'AnalysisResult {$type, $path, $message}';
}

enum AnalysisResultType {
  error,
  warning,
  lint,
  unknown,
}
