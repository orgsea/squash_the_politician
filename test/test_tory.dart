part of stop_tory.test;

void test_tory() {
  group('[Tory]', () {
    Tory tory;
    var name = 'David Cameron';
    var image = 'images/David_Cameron.jpg';
    var soundbite = 'sounds/pig_scream.mp3';

    setUp(() {
      tory = new Tory(name, image, soundbite);
    });

    tearDown(() {
      tory = null;
    });

    test('name is correct', () {
      expect(tory.name, name);
    });

    test('image is correct', () {
      expect(tory.image, image);
    });

    test('soundbite is correct', () {
      expect(tory.soundbite, soundbite);
    });

    test('default position starts at zero', () {
      expect(tory.position, 0);
    });

    test('increasePosition() increases position', () {
      [1,2,3].forEach((position) {
        tory.increasePosition();
        expect(tory.position, position);
      });
    });

    test('at position <= 3 title is "MP"', () {
      expect(tory.title, 'MP');
      [1,2,3,4,5,6,7,8,9].forEach((_) {
        tory.increasePosition();
        expect(tory.title, 'MP');
      });
    });

    test('at position > 3 and <= 6 title is "Minister"', () {
      expect(tory.title, 'MP');
      [1,2,3,4,5,6,7,8,9].forEach((_) {
        tory.increasePosition();
      });
      [10,11,12,13,14,15,16,17,18].forEach((_) {
        tory.increasePosition();
        expect(tory.title, 'Minister');
      });
    });

    test('at position > 6 and <= 9 title is "Prime Minister"', () {
      expect(tory.title, 'MP');
      [1,2,3,4,5,6,7,8,9].forEach((_) {
        tory.increasePosition();
      });
      [10,11,12,13,14,15,16,17,18].forEach((_) {
        tory.increasePosition();
      });
      [19,20,21,22,23,24,25,26,27].forEach((_) {
        tory.increasePosition();
        expect(tory.title, 'Prime Minister');
      });
    });

    group('[set position at creation', () {
      var position = 9;
      setUp(() {
        tory = new Tory(name, image, soundbite, position);
      });

      tearDown(() {
        tory = null;
      });

      test('position is set to 9', () {
        expect(tory.position, position);
      });
    });
  });
}