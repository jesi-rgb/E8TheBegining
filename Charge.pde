class Charge {

  Vec2 position;
  int value;
  PImage sprite;
  Body body;
  boolean display;

  Charge(Vec2 p) {
    position = p;
    value = 20;
    sprite = loadImage("media/scenarios/charge/spr1.png");
    display = true;
    
    makeBody(position, false);
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
    fd.setUserData("charge");
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
    image(sprite, pos.x, pos.y);
  }
  
  void killBody() {
    box2d.destroyBody(body);
  }
  
  int get(){
    display = false;
    return value;
  }
  
  boolean show(){
    return display;
  }
}
