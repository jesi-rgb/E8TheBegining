class Coin {

  PVector pos;
  int value;
  PImage sprite;
  Body body;

  Coin(PVector p) {
    pos = p;
    value = 10;
    sprite = loadImage("media/scenarios/coins/coin1.png");
  }

  void display() {
    if (millis() % 20 == 0) {
      pushMatrix();
        translate(0, -5);
        image(sprite, pos.x, pos.y);
      popMatrix();
    } else {
      pushMatrix();
        translate(0, 5);
        image(sprite, pos.x, pos.y);
      popMatrix();
    }
  }
}
