library stop_tory.game;

import 'dart:math' show Random, min, max;
import 'dart:async' show Future, Completer, Timer, StreamController, StreamSubscription, Stream;
import 'dart:convert' show JSON;

import 'package:stagexl/stagexl.dart';

part 'tory.dart';
part 'score.dart';
part 'frog.dart';

class Game {
  Stage _stage;
  var _delay;
  int _totalPoints = 0;
  Map<String, int> _toriesStopped = {};
  List<ToryView> _tories = [];
  List<Frog> _frogs = [];
  Random _random = new Random();
  TextField _loserText;
  TextField _stoppedText;
  Score _score;

  ResourceManager _manager = new ResourceManager();

  Stream<Function> _soundStream;
  StreamController<Function> _controller = new StreamController<Function>();
  StreamSubscription _subscription;

  get stage => _stage;
  get delay => _delay;
  get tories => new List.from(_tories); //make sure _tories is read only

  Game(this._stage, [this._delay = 0.5]);

  void handleClick(MouseEvent event) {
    var point = new Point(event.stageX, event.stageY);
    var clicked = _tories.where((view) => view.isAtPoint(point));
    clicked.forEach((view) {
      var frogData = _manager.getBitmapData('frog');
      var frogSound = _manager.getSound('frog');
      Frog frog = new Frog(frogSound, frogData)
        ..x = view.x
        ..y = view.y
        ..width = 100
        ..height = 100
        ..addTo(_stage)
        ..playSoundBite();
      ;
      _frogs.add(frog);
      _stage.juggler.add(frog);
      view.removeFromParent();
      view._remove = true;
      _totalPoints += view.tory.pointsValue;
      _toriesStopped.putIfAbsent(view.tory.title, () => 0);
      _toriesStopped[view.tory.title]++;
    });
  }

  run(List<Tory> tories) async {
    var subscription = _stage.addEventListener(MouseEvent.CLICK, handleClick);
    _createSoundEventSubscription();
    loadImages(tories);
    loadSounds(tories);

    await for (var counter in _stage.juggler.interval(_delay).take(666)) {
      int pos = _random.nextInt(tories.length);
      var tory = await showTory(new Tory.copy(tories[pos]));
      addTory(tory);

      _tories.forEach((view) {
        if(!view._remove) view.tory.increasePosition();
      });

      _tories.removeWhere((view) => view._remove);
      if(_tories.any((view) => !view._remove && view.tory.isPrimeMinister)) break;
    }
    _subscription.cancel();

    clearStage();
    showFinalScore();

    playFinalMessage();

    subscription.cancel();
  }


  clearStage() {
    if(_loserText != null) {
      _loserText.removeFromParent();
      _loserText = null;
    }
    if(_stoppedText != null) {
      _stoppedText.removeFromParent();
      _stoppedText = null;
    }
    _tories.forEach((view) => view.removeFromParent());
    _frogs.forEach((frog) => frog.removeFromParent());
  }


  showFinalScore() {
    var rect = _stage.contentRectangle;
    _loserText = new TextField('Game Over, the Tories have a Prime Minister, and the final points score is: ${_totalPoints}')
      ..x = rect.center.x / 2
      ..y = rect.center.y
      ..width = rect.width
      ..addTo(_stage);
    _stoppedText = new TextField('Squashed Tories: ${JSON.encode(_toriesStopped)}')
      ..x = 10
      ..y = rect.center.y + 200
      ..width = rect.width
      ..addTo(_stage);
  }

  playFinalMessage() async {
    Sound sound = await Sound.load('sounds/class.mp3');
    sound.play();
  }

  _createSoundEventSubscription() {
    _soundStream = _controller.stream;
    _subscription = _soundStream.listen(playQueue);
  }

  playQueue(func) {
    func();
  }


  addTory(tory) {
    _tories.add(tory);
  }


  /** Used to preload images prior to starting the game
   *
   */
  loadImages(tories) async {
    _manager.addBitmapData('frog', 'images/frog.jpg');
    await _manager.load();
  }

  loadToryImage(tory) async {
    var completer = new Completer();

    if(!_manager.containsBitmapData(tory.image)) {
      _manager.addBitmapData(tory.image, tory.image);
      await _manager.load(); //.then((_) => completer.complete());
      completer.complete();
    } else {
      completer.complete();
    }

    return completer.future;
  }

  loadSounds(tories) async {
//    for(var tory in tories) {
//      if (!_manager.containsSound(tory.soundbite)) {
//        _manager.addSound(tory.soundbite, tory.soundbite);
//        await _manager.load();
//      }
//    }
    _manager.addSound('frog', 'sounds/comedy_male_cartoon_character_crying2.mp3');
    await _manager.load();
  }

  loadTorySound(tory) async {
    var completer = new Completer();
    if (!_manager.containsSound(tory.soundbite)) {
      _manager.addSound(tory.soundbite, tory.soundbite);
      await _manager.load(); //.then((_) => completer.complete());
      completer.complete();
    } else {
      completer.complete();
    }

    return completer.future;
  }

  showTory(tory) async {
    var juggler = _stage.juggler;
    var rect = _stage.contentRectangle;
    await loadToryImage(tory);
    await loadTorySound(tory);
    var toryBitmapData = await _manager.getBitmapData(tory.image);
    var sound = await _manager.getSound(tory.soundbite);
    var toryBitmap = new ToryView(tory, sound, new Bitmap(toryBitmapData))
      ..x = min(rect.width.toInt()-200, rect.left.toInt() + _random.nextInt(rect.width.toInt()-200))
      ..y = min(rect.height.toInt()-200, rect.top.toInt() + _random.nextInt(rect.height.toInt()-200))
      ..width = 100
      ..height = 120
      ..addTo(_stage);

    juggler.addTween(toryBitmap, 1.0, Transition.easeOutBack);
    juggler.add(toryBitmap);
    _controller.add(toryBitmap.playSoundbite);

    return toryBitmap;
  }
}
