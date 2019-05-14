static int id = 0;

class Coin {

  Vec2 position;
  int value;
  PImage sprite;
  Body body;
  boolean up;
  boolean oddCoin;
  boolean display;

  Coin(Vec2 p) {
    position = p;
    value = 10;
    if (id%2 == 0) {
      up = false;
      sprite = loadImage("media/scenarios/coins/coin0.png");
    } else {
      sprite = loadImage("media/scenarios/coins/coin1.png");
      up = true;
    }
    display = true;
    

    makeBody(position, false);
    id++;
  }

  void makeBody(Vec2 center, boolean flotante) {
    //Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    if (flotante) {
      bd.gravityScale = 0;
    }
    bd.position = box2d.coordPixelsToWorld(center);

    //Make a body object out of that definition
    body = box2d.createBody(bd);
    body.setUserData(this);

    //Define the bounding box that is gonna experience all the forces
    PolygonShape boundingBox = new PolygonShape();
    float box2dw = box2d.scalarPixelsToWorld(sprite.width/2);
    float box2dh = box2d.scalarPixelsToWorld(sprite.height/2);
    boundingBox.setAsBox(box2dw, box2dh);

    //Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.setUserData("coin");
    fd.shape = boundingBox;
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.31;

    //Attach the fixture to the body
    body.createFixture(fd);
    body.resetMassData();
  }

  void display() {

    Vec2 pos = box2d.getBodyPixelCoord(this.body);

    if (frameCount % 30 == 0) {
      if (up) {
        pos.y += 10;
        up = false;
      } else {
        pos.y -= 10;
        up = true;
      }
      //up = !up;
    }

    tint(0, 255, 255, 255);
    image(sprite, pos.x, pos.y);
    noTint();
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  int get() {
    display = false;
    return value;
  }

  boolean show() {
    return display;
  }
}
