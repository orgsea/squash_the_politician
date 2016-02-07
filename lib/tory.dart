part of stop_tory.game;

class Tory {
  var _name;
  var _image;
  var _soundbite;
  var _postion;
  var _pointsValue;

  get name => _name;
  get image => _image;
  get soundbite => _soundbite;
  get position => _postion;
  get pointsValue => _pointsValue;

  bool get isMP => _postion <= 9;
  bool get isMinister => _postion > 9 && _postion <= 18;
  bool get isPrimeMinister => _postion >= 27;

  get title {
    if (_postion <= 9) return 'MP';
    if (_postion <= 18) return 'Minister';
    if (_postion <= 27) return 'Prime Minister';
  }

  Tory(this._name, this._image, this._soundbite, [this._pointsValue=100, this._postion = 0]);

  Tory.copy(Tory tory) : this(tory._name, tory._image, tory._soundbite);

  /// increase the position of this Tory, there is no decrease needed for this game.
  void increasePosition() {
    _postion++;
    _pointsValue += 100;
  }
}

class ToryView extends Sprite implements Animatable {
  var _drawnMinister = false;
  var _drawnPrimeMinister = false;
  var _drawnMP = false;
  Bitmap _bitmap;
  Tory _tory;

  Sound _sound;

  bool _remove = false;

  get tory => _tory;

  ToryView(this._tory, this._sound, this._bitmap) {
    _bitmap
      ..x = 0
      ..y = 0
      ..width = 100
      ..height = 100
      ..addTo(this);
    new TextField(_tory.name, new TextFormat('Arial', 16, Color.DarkGoldenrod, bold: true))
      ..x = 2
      ..y = 100
      ..wordWrap = true
      ..addTo(this)
      ;
  }

  bool isAtPoint(point) => point.x >= x && point.y > y && point.x < x + width && point.y < y + height;

  playSoundbite() {
    _sound.play();
  }

  bool advanceTime(num time) {
    var _x = 0; //bounds.topLeft.x;
    var _y = 0; //bounds.topLeft.y;
    var _width = 100;
    var _height = 150;

    if (_tory.isMinister && !_drawnMinister) {
      _drawnMinister = true;
      GraphicsCommandRect gr = new GraphicsCommandRect(_x, _y, _width, _height);
      graphics.addCommand(gr);
      graphics.strokeColor(Color.Blue, 5);
    } else if (_tory.isPrimeMinister  && !_drawnPrimeMinister) {
      _drawnPrimeMinister = true;
      GraphicsCommandRect gr = new GraphicsCommandRect(_x, _y, _width, _height);
      graphics.addCommand(gr);
      graphics.strokeColor(Color.Red, 5);

      return false;
    } else if(!_drawnMP) {
      _drawnMP = true;
      GraphicsCommandRect gr = new GraphicsCommandRect(_x, _y, _width, _height);
      graphics.addCommand(gr);
      graphics.strokeColor(Color.Black, 5);
    }

    return true;
  }


}