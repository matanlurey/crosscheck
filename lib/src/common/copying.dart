// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Makes a copy of the folder at [path], and executes [run] with a new path.
///
/// May optionally specify the precise [destination] folder, otherwise it is
/// provided automatically by the system.
Future<T> withCopyOf<T>(
  String path,
  Future<T> run(String path), {
  String destination,
}) async {
  if (destination == null) {
    final temp = Directory.systemTemp.createTempSync().path;
    destination = p.join(
      temp,
      p.basenameWithoutExtension(path),
    );
  }
  final source = new Directory(path);
  if (!source.existsSync()) {
    throw new ArgumentError('No directory found at $path.');
  }
  await _copy(path, destination);
  final result = await run(destination);
  // await new Directory(destination).delete(recursive: true);
  return result;
}

Future<Null> _copy(String from, String to) async {
  await new Directory(to).create(recursive: true);
  await for (final file in new Directory(from).list(recursive: true)) {
    final copyTo = p.join(to, p.relative(file.path, from: from));
    if (file is Directory) {
      await new Directory(copyTo).create(recursive: true);
    } else if (file is File) {
      await new File(file.path).copy(copyTo);
    }
  }
}
