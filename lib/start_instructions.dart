part of stop_tory.game;

class StartInstructions extends Sprite {
  List<TextField> _instructions = [];

  StartInstructions(List<String> instructions) {
    var ypos = 10;
    var posInc = 5;
    instructions.forEach((instruction) {
      var instText = new TextField(instruction, new TextFormat('monospace', 2, Color.Black, bold: true))
        ..wordWrap = true
        ..addTo(this)
        ..y = ypos
        ..width = width
//        ..height = 400
      ;
      ypos += posInc;
      _instructions.add(instText);

    });
  }


}