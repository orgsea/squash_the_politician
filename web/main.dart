// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' show querySelector;
import 'package:stagexl/stagexl.dart';

import 'package:stop_tory/game.dart';

void main() {
  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.Bisque;

  var subscription;
  var subscription2;
  var canvas = querySelector('#game');
  var stage = new Stage(canvas, width: 800, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var rect = stage.contentRectangle;
  Game game = new Game(stage, 1);
  subscription = stage.addEventListener(MouseEvent.CLICK, (e) {
    game.run(
        [
          new Tory('David Cameron', 'images/David_Cameron2.jpg', 'sounds/pig_scream.mp3'),
          new Tory('George Osborne', 'images/George_Osborne2.jpg', 'sounds/human_sniffing_001.mp3'),
          new Tory('Theresa May', 'images/Theresa_May2.jpg', 'sounds/zombie_vocal_hiss_growl.mp3'),
          new Tory('Gerald Howarth', 'images/Gerald_Howarth2.jpg', 'sounds/man_says_no_stubbornly.mp3'),
          new Tory('Boris Johnson', 'images/Boris_Johnson2.jpg', 'sounds/comedy_male_yelling_yee_ha.mp3')
        ]
    );
    subscription.cancel();
  });
}
