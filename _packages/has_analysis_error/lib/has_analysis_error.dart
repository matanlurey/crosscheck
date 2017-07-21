// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

void method() {
  var name = 'Kevin Moore';
  // Strong-mode exception: "A value of type 'int' can't be assigned...".
  name = 5;
  print(name);
}
