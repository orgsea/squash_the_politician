library stop_tory.test;

import 'dart:html' show CanvasElement;
import 'dart:mirrors';


import 'package:test/test.dart';

import 'package:stagexl/stagexl.dart' show Stage;

import 'package:stop_tory/game.dart';

part 'test_game.dart';
part 'test_tory.dart';

main() {
  test_game();
  test_tory();
}