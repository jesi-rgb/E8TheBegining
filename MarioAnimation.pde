import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import geomerative.*;
import processing.sound.*;



final static int LEFT = 0, RIGHT = 1;
final static int LEFT_ARROW = 37;
final static int UP_ARROW = 38;
final static int RIGHT_ARROW = 39;
final static int DOWN_ARROW = 40;
final int FULLSCREEN_WIDTH = 1920;
final int FULLSCREEN_HEIGHT = 1080;


Box2DProcessing box2d;

Terreno s;
Terreno[] pared = new Terreno[2];
Plataforma[] plataformas = new Plataforma[4];
RShape grp;
Scenario surface;

SoundFile bgMusic;
SoundFile jump;
SoundFile shoot;
SoundFile intro;

ArrayList<Coin> coins;

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
  size(1366, 768, P2D);
  //size(1280, 720, P2D);
  //size(720, 480, P2D);
  frameRate(40);
  imageMode(CENTER);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -700);
  box2d.listenForCollisions();
  
  bgMusic = new SoundFile(this, "media/music/bgMusic.wav");
  intro = new SoundFile(this, "media/music/intro.wav");
  jump = new SoundFile(this, "media/music/jump.wav");
  shoot = new SoundFile(this, "media/music/shoot.wav");
  bgMusic.amp(0.4);
  intro.amp(0.4);
  shoot.amp(0.4);
  intro.play();
  delay(int(intro.duration())*1000);
  bgMusic.loop();

  coins = new ArrayList<Coin>();
  for (int c = 0; c < 3; c++) {
    coins.add(new Coin(new PVector(width/4 + 25*c, height/6)));
  }

  keys = new Boolean[256];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }

  projectiles = new ArrayList<Bullet>();
  enemigos = new ArrayList<Enemigo>();


  jug = new Jugador(new Vec2(width/4, height/9), "jugador", 8, 3, false);
  //imgEnemy = new Imagen(new Vec2(width/4, height/2), "imgEnemy", 8, 2, false);
  //audEnemy = new Audio(new Vec2(3*width/4, height/2 - 10), "audEnemy", 19, 2, true);


  tex = loadImage("media/scenarios/textures/texture.png");
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);
  grp = RG.loadShape("media/scenarios/level2.svg");
  grp.scale(width/grp.width);

  RPoint[] points = grp.getPoints();
  surface = new Scenario(points);


  bg = loadShape("media/backgrounds/trianglify.svg");
}

void draw() {
  box2d.step(1/(frameRate * 2), 10, 10);
  shape(bg);
  surface.display();

  for (Coin c : coins) {
    c.display();
  }

  //Jugador
  if (jug != null) {
    //println("1");
    if ( !(jug.vidaActual <= 0 || jug.outOfBounds()) ) { //no sé como hacer esto mendorito ayuda
      //println("2");
      textSize(30);
      fill(0);
      text(jug.vidaActual, 40, 40);
      jug.accion();
      jug.atacar(enemigos);
      jug.display();
      jugPos = box2d.getBodyPixelCoord(jug.body);
    } else {
      //println("3");
      jug.killBody();
      jug = null;
      jugPos = new Vec2(10000, 10000);
    }
  } else {
    textSize(78);
    fill(0);
    textAlign(CENTER);
    text("Has muerto", width/2, height/2);
    bgMusic.stop();
    setup();
  }

  //Enemigos
  if (imgEnemy != null) {
    if (imgEnemy.vidaActual > 0 && !imgEnemy.outOfBounds()) {
      imgEnemy.detectarJugador(jugPos);
      imgEnemy.display();
    } else {
      //print("Rip imagen");
      imgEnemy.killBody();
      imgEnemy = null;
    }
  }

  if (audEnemy != null) {
    if (audEnemy.vidaActual > 0 && !audEnemy.outOfBounds()) {
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
