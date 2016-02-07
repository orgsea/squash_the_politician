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
  StartInstructions instructions = new StartInstructions(
      [
        'Click/Touch to start',
        'Click or touch a tory to squash it',
        'Tory changes as time goes on from MP to Minister, then Prime Minister.',
        'Game ends when a tory becomes and stays a Prime Minister for too long',
        'I included a speach from Dennis Skinner that plays when you eventually loose the game.'])
    ..width = rect.width
    ..height = rect.height
    ..x = rect.topLeft.x
    ..y = rect.topLeft.y
    ..addTo(stage)
    ;

  subscription = stage.addEventListener(MouseEvent.CLICK, (e) {
    instructions.removeFromParent();
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
