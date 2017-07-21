// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

Logger get _currentLogger {
  final logger = Zone.current[Logger] as Object;
  if (logger is Logger) {
    return logger;
  }
  throw new StateError('Logging not enabled. Use "runLogged".');
}

/// Logs a [message] with the [Level.FINE] verbosity.
void fine(String message) => _currentLogger.fine(message);

/// Logs a [message] with the [Level.INFO] verbosity.
void info(String message) => _currentLogger.info(message);

/// Logs a [message] with the [Level.WARNING] verbosity.
///
/// Optionally specify an [error] and/or stack [trace].
void warning(String message, [Object error, StackTrace trace]) {
  _currentLogger.warning(message, error, trace);
}

/// Logs a [message] with the [Level.SEVERE] verbosity.
///
/// Optionally specify an [error] and/or stack [trace].
///
/// This may result in the program executing with a non-zero exit code.
void severe(String message, [Object error, StackTrace trace]) {
  _currentLogger.severe(message, error, trace);
}

/// Executes the [run] function with logging enabled.
T runLogged<T>(
  // TODO: Use new function syntax after http://dartbug.com/30229.
  T run(), {
  String name: 'crosscheck',
  @required void onLog(LogRecord record),
}) {
  if (Zone.current[Logger] != null) {
    throw new StateError('Logging already configured');
  }
  // TODO: Make the log level configurable.
  Logger.root.level = Level.ALL;
  final logger = new Logger(name);
  if (onLog != null) {
    logger.onRecord.listen(onLog);
  }
  return runZoned(run, zoneValues: <Object, Object>{Logger: logger});
}
