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

float wRatio;
PFont font;

Box2DProcessing box2d;

RShape grp;
Scenario surface;

SoundFile bgMusic;
SoundFile jump;
SoundFile shoot;
SoundFile intro;
SoundFile meleeAttack;
SoundFile coin;
SoundFile charge;

ArrayList<Coin> coins;
ArrayList<Charge> charges;

Jugador jug;
Vec2 jugPos;
Enemigo imgEnemy;
Enemigo audEnemy;
ArrayList<Bullet> projectiles;
ArrayList<Enemigo> enemigos;
Vec2[][] spawners;

PShape bg;
PImage tex;

Boolean[] keys;

void setup() {

  //fullScreen(P2D);
  //size(1366, 768, P2D);
  size(1280, 720, P2D);
  //size(720, 480, P2D);
  frameRate(40);
  imageMode(CENTER);

  wRatio = float(width) / FULLSCREEN_WIDTH;

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -700 * wRatio);
  box2d.listenForCollisions();

  bgMusic = new SoundFile(this, "media/music/bgMusic.wav");
  //intro = new SoundFile(this, "media/music/intro.wav");
  jump = new SoundFile(this, "media/music/jump.wav");
  shoot = new SoundFile(this, "media/music/shoot.wav");
  meleeAttack = new SoundFile(this, "media/music/melee.mp3");
  meleeAttack.amp(0.2);
  shoot.amp(0.2);
  jump.amp(0.4);
  coin = new SoundFile(this, "media/music/coin.wav");
  charge = new SoundFile(this, "media/music/charge.mp3");
  bgMusic.amp(0.4);
  //intro.amp(0.4);
  shoot.amp(0.1);
  coin.amp(0.2);
  charge.amp(0.2);
  //intro.play();
  bgMusic.loop();
  
  spawners = new Vec2[4][3];
  spawners[0][0] = new Vec2(2*width/4, height/11);
  spawners[0][1] = new Vec2(width/4, height/2);
  spawners[0][2] = new Vec2(width/4, height/4);
  spawners[1][0] = new Vec2(width/4, height/11);
  spawners[1][1] = new Vec2(3*width/4, height/2);
  spawners[1][2] = new Vec2(width/4, height/2);
  spawners[2][0] = new Vec2(width/4, height/2);
  spawners[2][1] = new Vec2(3*width/4, height/10);
  spawners[2][2] = new Vec2(3*width/4, 2*height/10);
  spawners[3][0] = new Vec2(width/2, height/10);
  spawners[3][1] = new Vec2(3*width/4, height/2);
  spawners[3][2] = new Vec2(3*width/4, 2*height/5);
  

  coins = new ArrayList<Coin>();
  int k = int(random(0,2));
  for (int c = 0; c < 6; c++) {
    coins.add(new Coin(new Vec2(spawners[2][k].x + 25*c, spawners[2][k].y)));
  }
  
  charges = new ArrayList<Charge>();
  k = int(random(0,2));
  charges.add(new Charge(spawners[3][k]));

  keys = new Boolean[256];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }

  projectiles = new ArrayList<Bullet>();
  enemigos = new ArrayList<Enemigo>();

  font = loadFont("PressStart2P-Regular-48.vlw");


  jug = new Jugador(spawners[0][int(random(2))], "jugador", 8, 3, false);
  
  enemigos.add(new Imagen(spawners[1][int(random(2))], "imgEnemy", 8, 2, false));
  enemigos.add(new Audio(spawners[1][int(random(2))], "audEnemy", 19, 2, true));

  tex = loadImage("media/scenarios/textures/texture.png");
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);
  grp = RG.loadShape("media/scenarios/level2noise.svg");
  grp.scale(width/grp.width);

  RPoint[] points = grp.getPoints();
  surface = new Scenario(points);


  bg = loadShape("media/backgrounds/trianglify.svg");
}

void draw() {
  box2d.step(1/(frameRate * 2), 10, 10);
  shape(bg);
  surface.display();
  
  if(frameCount % 400 == 0){
    println("Generando enemigos");
    enemigos.add(new Imagen(spawners[1][int(random(2))], "imgEnemy", 8, 2, false));
    enemigos.add(new Audio(spawners[1][int(random(2))], "audEnemy", 19, 2, true));
    int k = int(random(0,2));
    for (int c = 0; c < 6; c++) {
      coins.add(new Coin(new Vec2(spawners[2][k].x + 25*c, spawners[2][k].y)));
    }
    k = int(random(0,2));
    charges.add(new Charge(spawners[3][k]));
  }

  for (int i=0; i<coins.size(); i++) {
    if (coins.get(i).show()) {
      coins.get(i).display();
    } else {
      Coin c = coins.get(i);
      coins.remove(i);
      c.killBody();
    }
  }
  
  for (int i=0; i<charges.size(); i++) {
    if(charges.get(i).show()){
      charges.get(i).display();
    } else {
      Charge c = charges.get(i);
      charges.remove(i);
      c.killBody();
    }
  }

  //Jugador
  if (jug != null) {
    if ( jug.vidaActual > 0 ) {
      textSize(30);
      fill(0);
      textFont(font, 32);
      text(jug.vidaActual, 40, 40);
      text(jug.getCoins(), 150, 40);
      text(jug.carga, 350, 40);
      jug.accion();
      jug.atacar(enemigos);
      jug.display();
      jugPos = box2d.getBodyPixelCoord(jug.body);
    } else {
      jug.killBody();
      jug = null;
      jugPos = new Vec2(10000, 10000);
    }
  } else {
    textSize(28);
    fill(0);
    textAlign(CENTER);
    text("Array index out of bounds", width/2, height/2);
    bgMusic.stop();
    setup();
  }

  //Enemigos
  for(int i = 0; i<enemigos.size(); i++){
    if (enemigos.get(i).vidaActual > 0) {
      enemigos.get(i).detectarJugador(jugPos);
      enemigos.get(i).display();
    } else {
      if(jug != null){
        jug.incrementCoins(100);
      }
      enemigos.get(i).killBody();
      enemigos.remove(i);
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
  
  if(f1.getUserData().equals("jugador")){
    Jugador j = (Jugador) f1.getBody().getUserData();
    if(f2.getUserData().equals("suelo") || f2.getUserData().equals("enemigo")){
      j.onAir = false;
    } else {
      j.onAir=true;
    }
  }
  
  if(f2.getUserData().equals("jugador")){
    Jugador j = (Jugador) f2.getBody().getUserData();
    if(f1.getUserData().equals("suelo") || f1.getUserData().equals("enemigo")){
      j.onAir = false;
    } else {
      j.onAir=true;
    }
  }
  
  if ((f1.getUserData().equals("jugador") && f2.getUserData().equals("coin")) ||
    (f2.getUserData().equals("jugador") && f1.getUserData().equals("coin")) ) {
      Coin c;
      if (f1.getUserData().equals("coin")) {
        c = (Coin) f1.getBody().getUserData();
      } else {
        c = (Coin) f2.getBody().getUserData();
      }
      jug.incrementCoins(c.get());
      coin.play();
    }
    
  if ((f1.getUserData().equals("jugador") && f2.getUserData().equals("charge")) ||
  (f2.getUserData().equals("jugador") && f1.getUserData().equals("charge")) ) {
    Charge c;
    if (f1.getUserData().equals("charge")) {
      c = (Charge) f1.getBody().getUserData();
    } else {
      c = (Charge) f2.getBody().getUserData();
    }
    c.get();
    if(jug.vidaActual + 20 <= jug.vidaMax){
      jug.vidaActual += 20;
    } else jug.vidaActual = jug.vidaMax;
    jug.recargar();
    charge.play();
  }

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
          if(f1.getUserData().equals("jugador") || f1.getUserData().equals("enemigo")){
            Personaje e = (Personaje) f1.getBody().getUserData();
            e.takeDamage(b.damage);
          }
        }
      }
      b.delete();
    }
  }
  
  if (f1.getUserData().equals("bulletAnimation")) {
    Bullet b = (Bullet) f1.getBody().getUserData();

    if (!f2.getUserData().equals(b.personaje)) {
      if (!f2.getUserData().equals("suelo")) {
        if (f2.getUserData().equals("bulletAnimation")) {
          Bullet b2 = (Bullet) f2.getBody().getUserData();
          b2.delete();
        } else {
          if(f2.getUserData().equals("jugador") || f2.getUserData().equals("enemigo")){
            Personaje e = (Personaje) f2.getBody().getUserData();
            e.takeDamage(b.damage);
          }
        }
      }
      b.delete();
    }
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
