import 'dart:io';

String readFixture(String name) {
  return File('fixtures/$name').readAsStringSync();
}
