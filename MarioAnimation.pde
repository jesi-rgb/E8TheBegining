import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

final static int LEFT = 0, RIGHT = 1;

Box2DProcessing box2d;
Suelo s;
Suelo[] pared = new Suelo[2];

Jugador jug;
Boolean[] keys;

void setup() {
  size(840, 900, P2D);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -700);
  

  frameRate(40);
  imageMode(CENTER);

  keys = new Boolean[128];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }


  jug = new Jugador(new Vec2(width/2, height/2), "jugador");
  s = new Suelo(width/2, height-50, width, 50);
  pared[0] = new Suelo(0, height/2, 30, height*100);
  pared[1] = new Suelo(width, height/2, 30, height*100);
}

void draw() {
  background(140, 200, 0);
  box2d.step();

  jug.mover();
  jug.jump();
  jug.display();
  

  s.display();
  //pared.move();
  pared[0].display();
  pared[1].display();
}

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}
