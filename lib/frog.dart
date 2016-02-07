part of stop_tory.game;

class Frog extends Bitmap implements Animatable {
  var _direction = 0;
  Sound _sound;

  Frog(this._sound, bitmapdata) : super(bitmapdata) {
    _direction = new Random().nextInt(4);
  }

  bool advanceTime(num time) {
    if(_direction == 0) {
      x+=10;
    } else if(_direction == 1) {
      x-=10;
    } else if(_direction == 2) {
      y+=10;
    } else {
      y-=10;
    }

    Stage stage = parent;
    if(stage != null &&
        (y+height >= stage.contentRectangle.height+stage.contentRectangle.top || y < stage.contentRectangle.top ||
         x+width >= stage.contentRectangle.width+stage.contentRectangle.left || x < stage.contentRectangle.left)
    ) {
      removeFromParent();
      return false;
    }

    return stage != null;
  }

  playSoundBite() {
    _sound.play();
  }
}