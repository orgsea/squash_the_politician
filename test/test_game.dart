part of stop_tory.test;

void test_game() {
  group('[Game]', () {
    Game game;
    var stage;

    setUp(() {
      stage = new Stage(new CanvasElement(width: 800, height: 600));
      game = new Game(stage);
    });

    tearDown(() {
      stage = null;
      game = null;
    });

    test('stage is set', () {
      expect(game.stage, stage);
    });

    test('default delay is 0.5', () {
      expect(game.delay, 0.5);
    });

    test('createSoundEventSubscription creates a stream and subscription for playing sounds with', () {
      var game_ = reflect(game);
      expect(game_.getField(#soundStream).reflectee, isNull);
      expect(game_.getField(#_subscription).reflectee, isNull);
      game_.invoke(#_createSoundEventSubscription, []);
      expect(game_.getField(#soundStream).reflectee, isNotNull);
      expect(game_.getField(#_subscription).reflectee, isNotNull);
    });

    group('[Delay set by constructor]', () {
      var delay = 0.9;
      setUp(() {
        stage = new Stage(new CanvasElement(width: 800, height: 600));
        game = new Game(stage, delay);
      });

      tearDown(() {
        stage = null;
        game = null;
      });

      test('delay is set to ${delay}', () {
        expect(game.delay, delay);
      });
    });
  });
}