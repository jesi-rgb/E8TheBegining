// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// A fixed boundary class

class Terreno {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  Boolean xd;
  PImage texture;

  // But we also have to make a body for box2d to know about it
  Body b;

  Terreno(float x_, float y_, float w_, float h_, String ruta) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    xd = true;
    texture = loadImage("media/backgrounds/"+ruta+".png");
    makeBody();
  }

  
  void makeBody(){
    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    b = box2d.createBody(bd);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.setUserData("suelo");

    b.createFixture(fd);
    b.resetMassData();
  }

  void display() {
    beginShape();
    texture(texture);
    vertex(x-w/2, y+h/2, 0, 0);
    vertex(x-w/2, y-h/2, 1000, 0);
    vertex(x+w/2, y-h/2, 1000, 1000);
    vertex(x+w/2, y+h/2, 1000, 0);
    endShape();
  }
}
