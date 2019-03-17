// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// A fixed boundary class

class Plataforma {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float xInicial;
  float yInicial;
  float w;
  float h;
  Boolean sentido;

  // But we also have to make a body for box2d to know about it
  Body b;

  Plataforma(float x_, float y_, float w_, float h_, float friction) {
    x = x_;
    y = y_;
    xInicial = x;
    yInicial = y;
    w = w_;
    h = h_;
    sentido = true;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.KINEMATIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    b = box2d.createBody(bd);

    FixtureDef fd = new FixtureDef();
    fd.setUserData("plataforma");
    fd.shape = sd;
    fd.friction = friction;

    b.createFixture(fd);
    b.resetMassData();
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(b);

    fill(0);
    stroke(0);
    rectMode(CENTER);
    rect(pos.x, pos.y, w, h);
  }

  void move(int direccion, int len) {
    Vec2 vel = b.getLinearVelocity();
    Vec2 pos = box2d.getBodyPixelCoord(b);
    if (direccion==0) {
      if (sentido) {
        if (pos.x<(xInicial+len)) {
          vel.x = 10;
        } else sentido=false;
      } else {
        if (pos.x>(xInicial-len)) {
          vel.x = -10;
        } else sentido=true;
      }
    } else {
      if (sentido) {
        if (pos.y>(yInicial-len)) {
          vel.y = 10;
        } else sentido=false;
      } else {
        if (pos.y<(yInicial+len)) {
          vel.y = -10;
        } else sentido=true;
      }
    }
    b.setLinearVelocity(vel);
  }
}
