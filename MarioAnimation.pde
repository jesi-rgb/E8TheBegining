import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import geomerative.*;


final static int LEFT = 0, RIGHT = 1;
final static int LEFT_ARROW = 37;
final static int UP_ARROW = 38;
final static int RIGHT_ARROW = 39;
final static int DOWN_ARROW = 40;

Box2DProcessing box2d;

Terreno s;
Terreno[] pared = new Terreno[2];
Plataforma[] plataformas = new Plataforma[4];
RShape grp;
Scenario surface;

Jugador jug;
Vec2 jugPos;
Enemigo imgEnemy;
Enemigo audEnemy;
ArrayList<Bullet> projectiles;
ArrayList<Enemigo> enemigos;

PShape bg;
PImage tex;

Boolean[] keys;

void setup() {

  //fullScreen(P2D);
  size(1280, 720, P2D); 
  frameRate(40);
  imageMode(CENTER);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -700);
  box2d.listenForCollisions();
  
  tex = loadImage("media/scenarios/textures/texture.png");


  keys = new Boolean[256];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }

  projectiles = new ArrayList<Bullet>();
  enemigos = new ArrayList<Enemigo>();


  jug = new Jugador(new Vec2(width/4, height/9), "jugador", 8, 3, false);
  //imgEnemy = new Imagen(new Vec2(3*width/4, height/6), "imgEnemy", 8, 2, false);
  //audEnemy = new Audio(new Vec2(3*width/4, 7*height/8), "audEnemy", 19, 2, true);

  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);
  grp = RG.loadShape("media/scenarios/level1.svg");
  RPoint[] points = grp.getPoints();
  surface = new Scenario(points);

  bg = loadShape("media/backgrounds/trianglify.svg");

  //s = new Terreno(width/2, height-50, width, 50, "floor");
  //pared[0] = new Terreno(0, height/2, 30, height*100, "floor");
  //pared[1] = new Terreno(width, height/2, 30, height*100, "floor");
  //plataformas[0] = new Plataforma(width/2, 4*height/5, 300, 20, 1);
  //plataformas[1] = new Plataforma(3*width/4, 4*height/5, 200, 20, 1);
}

void draw() {
  box2d.step(1/(frameRate * 2), 10, 10);

  shape(bg);
  surface.display();

  //Jugador
  if (jug != null) {
    if (jug.vidaActual>0) {
      jug.accion();
      jug.atacar(enemigos);
      jug.display();
      jugPos = box2d.getBodyPixelCoord(jug.body);
    } else {
      jug.killBody();
      jug = null;
      jugPos = new Vec2(10000, 10000);
    }
  }

  if (jug == null) {
    textSize(78);
    fill(0);
    textAlign(CENTER);
    text("Has muerto", width/2, height/2);
  }

  //Enemigos
  if (imgEnemy != null) {
    if (imgEnemy.vidaActual>0) {
      imgEnemy.detectarJugador(jugPos);
      imgEnemy.display();
    } else {
      imgEnemy.killBody();
      imgEnemy = null;
    }
  }

  if (audEnemy != null) {
    if (audEnemy.vidaActual>0) {
      audEnemy.detectarJugador(jugPos);
      audEnemy.display();
    } else {
      audEnemy.killBody();
      audEnemy = null;
    }
  }

  if (projectiles != null)
    for (int i = projectiles.size()-1; i >= 0; i--) {
      Bullet p = projectiles.get(i);
      p.mover();
      p.display();
      if (p.done()) {
        projectiles.remove(i);
      }
    }




  //s.display();
  //pared[0].display();
  //pared[1].display();
  //plataformas[0].display();
  //plataformas[1].display();

  //plataformas[0].move(1, 100);
  //plataformas[1].move(1, 50);
}


void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();


  if ((f1.getUserData().equals("jugador") && f2.getUserData().equals("enemigo")) ||
    (f2.getUserData().equals("jugador") && f1.getUserData().equals("enemigo")) ) {
    Personaje p;
    if (f1.getUserData().equals("jugador")) {
      p = (Personaje) f1.getBody().getUserData();
    } else {
      p = (Personaje) f2.getBody().getUserData();
    }

    p.takeDamage(10);
  }

  if (f2.getUserData().equals("bulletAnimation")) {
    Bullet b = (Bullet) f2.getBody().getUserData();

    if (!f1.getUserData().equals(b.personaje)) {
      if (!f1.getUserData().equals("suelo")) {
        if (f1.getUserData().equals("bulletAnimation")) {
          Bullet b2 = (Bullet) f1.getBody().getUserData();
          b2.delete();
        } else {
          Personaje e = (Personaje) f1.getBody().getUserData();
          e.takeDamage(b.damage);
        }
      }
    }
    b.delete();
  }
}

// Objects stop touching each other
void endContact(Contact cp) {
}

void keyPressed() {
  if (key == CODED)
    keys[keyCode] = true;
  else
    keys[key] = true;
}

void keyReleased() {
  if (key == CODED)
    keys[keyCode] = false;
  else
    keys[key] = false;
}
