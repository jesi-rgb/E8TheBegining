import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

final static int LEFT = 0, RIGHT = 1;

Box2DProcessing box2d;

Terreno s;
Terreno[] pared = new Terreno[2];
Plataforma[] plataformas = new Plataforma[4];

Jugador jug;
Vec2 jugPos;
Enemigo enmy;

PImage bg; 

Boolean[] keys;

void setup() {
  //fullScreen(P2D);
  size(1300, 700, P2D);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -700);
  //box2d.listenForCollisions();

  frameRate(40);
  imageMode(CENTER);

  //bg = loadImage("media/backgrounds/background.jpg");

  keys = new Boolean[128];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }

  jug = new Jugador(new Vec2(width/2, height/2), "jugador", 8, 3, 1);
  //enmy = new Imagen(new Vec2(3*width/4, height/2), "imgEnemy", 8, 2, 1);
  enmy = new Audio(new Vec2(3*width/4, height/2), "imgEnemy", 8, 2, 0.1);
  s = new Terreno(width/2, height-50, width, 50, "floor");
  pared[0] = new Terreno(0, height/2, 30, height*100, "floor");
  pared[1] = new Terreno(width, height/2, 30, height*100, "floor");
  //plataformas[0] = new Plataforma(width/2, 4*height/5, 300, 20, 1);
  //plataformas[1] = new Plataforma(3*width/4, 4*height/5, 200, 20, 1);
}

void draw() {
  //background(bg);
  background(150);
  box2d.step(1/(frameRate * 2), 10, 10);
  

  jug.mover();
  jug.jump();
  jug.display();

  jugPos = box2d.getBodyPixelCoord(jug.body);
  //enmy.detectarJugador(jugPos);
  enmy.mover();
  enmy.display();


  s.display();
  //pared.move();
  pared[0].display();
  pared[1].display();
  //plataformas[0].display();
  //plataformas[1].display();

  //plataformas[0].move(1, 100);
  //plataformas[1].move(1, 50);
}


//void beginContact(Contact cp) {
//  // Get both fixtures
//  Fixture f1 = cp.getFixtureA();
//  Fixture f2 = cp.getFixtureB();

//  if(f1.getUserData().equals("jugador")){
//    jug = (Jugador)f1.getBody().getUserData();
//    jug.onAir = false;
//  }else{
//    jug = (Jugador)f2.getBody().getUserData();
//    jug.onAir = false;
//  }
//}

//// Objects stop touching each other
//void endContact(Contact cp) {
//}

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}
