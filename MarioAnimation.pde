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
int gameMode = 0;

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
SoundFile shootAudio;
SoundFile outOfAmmo;
SoundFile deathAudio;
SoundFile deathImg;
SoundFile battleTheme;

ArrayList<Coin> coins;
ArrayList<Charge> charges;

Jugador jug;
Vec2 jugPos;
Enemigo imgEnemy;
Enemigo audEnemy;
ArrayList<Bullet> projectiles;
ArrayList<Enemigo> enemigos;
Vec2[][] spawners;

ArrayList<Integer> puntuaciones = new ArrayList<Integer>();

PShape bg;
PImage tex;

Boolean[] keys;

Boolean[][] ocupados;

void setup() {

  //fullScreen(P2D);
  size(1366, 768, P2D);
  //size(1280, 720, P2D);
  //size(720, 480, P2D);
  frameRate(40);
  imageMode(CENTER);

  wRatio = float(width) / FULLSCREEN_WIDTH;

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -700 * wRatio);
  box2d.listenForCollisions();

  bgMusic = new SoundFile(this, "media/music/bgMusic.wav");
  jump = new SoundFile(this, "media/music/jump.wav");
  shoot = new SoundFile(this, "media/music/shoot.wav");
  meleeAttack = new SoundFile(this, "media/music/melee.mp3");
  coin = new SoundFile(this, "media/music/coin.wav");
  charge = new SoundFile(this, "media/music/charge.mp3");
  shootAudio = new SoundFile(this, "media/music/shootAudio.wav");
  deathAudio = new SoundFile(this, "media/music/deathAudio.wav");
  deathImg = new SoundFile(this, "media/music/deathImg.wav");
  outOfAmmo = new SoundFile(this, "media/music/outOfAmmo.wav");
  battleTheme = new SoundFile(this, "media/music/battleTheme.wav");

  bgMusic.amp(0.4);
  battleTheme.amp(0.7);
  meleeAttack.amp(0.2);
  shoot.amp(0.4);
  jump.amp(0.9);
  coin.amp(0.2);
  charge.amp(0.2);
  
  ocupados = new Boolean[2][3];
  for(int i=0; i<2; i++){
    for(int j=0; j<3; j++){
      ocupados[i][j] = false;
    }
  }
  
  spawners = new Vec2[4][3];
  //Spawner jugador
  spawners[0][0] = new Vec2(2*width/4, height/11);
  spawners[0][1] = new Vec2(width/4, height/2);
  spawners[0][2] = new Vec2(width/4, height/4);
  //Spawner jugatres
  spawners[1][0] = new Vec2(width/4, height/11);
  spawners[1][1] = new Vec2(3*width/4, height/2);
  spawners[1][2] = new Vec2(width/4, height/2);
  //Spawner coins
  spawners[2][0] = new Vec2(width/6, 7*height/10);
  spawners[2][1] = new Vec2(3*width/4, height/10);
  //spawners[2][2] = new Vec2(width/4, 2*height/10);
  //Spawner charges
  spawners[3][0] = new Vec2(3*width/5, height/20);
  spawners[3][1] = new Vec2(3*width/4, height/2);
  //spawners[3][2] = new Vec2(3*width/4, 2*height/5);


  coins = new ArrayList<Coin>();
  int k = int(random(0, 1));
  for (int c = 0; c < 3; c++) {
    coins.add(new Coin(new Vec2(spawners[2][k].x + 25*c, spawners[2][k].y)));
    ocupados[k][c] = true;
  }

  charges = new ArrayList<Charge>();
  k = int(random(0, 1));
  charges.add(new Charge(spawners[3][k]));

  keys = new Boolean[256];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }

  projectiles = new ArrayList<Bullet>();
  enemigos = new ArrayList<Enemigo>();

  font = loadFont("PressStart2P-Regular-48.vlw");


  jug = new Jugador(spawners[0][int(random(2))], "jugador", 8, 3, false);

  int s1 = (int) random(2);
  int s2;
  do{
    s2 = (int) random(2);
  } while(s1==s2);
  enemigos.add(new Imagen(spawners[1][s1], "imgEnemy", 8, 2, false));
  enemigos.add(new Audio(spawners[1][s2], "audEnemy", 19, 2, true));

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
  shape(bg);

  switch(gameMode) {
  case 0: //menu
    if (!bgMusic.isPlaying())
      bgMusic.loop();
    menuDisplay();
    break;
  case 1: //juego

    //steps de box2d para el motor de físicas
    box2d.step(1/(frameRate * 2), 10, 10);
    bgMusic.stop();
    if (!battleTheme.isPlaying())
      battleTheme.loop();
    //display de fondo y formas
    shape(bg);
    surface.display();
    generacionElementos();
    displayMiscelanea();
    logicaJugador();
    logicaEnemigos();
    if (keys['q']) {
      battleTheme.stop();
      gameMode = 0;
    }
    break;


  case 2: //statistics
    displayPoints();
    if (keys['q'])
      gameMode = 0;
    break;


  case 3: // instructions
    displayInstructions();
    if (keys['q'])
      gameMode = 0;
    break;


  case 4: //about
    displayAbout();
    if (keys['q'])
      gameMode = 0;
    break;

  case 5: //death screen

    meleeAttack.stop();
    deathScreen();
    if (keys['q'])
      gameMode = 0;
    break;
  }
}

void menuDisplay() {
  textAlign(CENTER);
  fill(0);
  textFont(font, 60 * wRatio);
  text("E8 GAME: THE BEGINING", width/2, height/4);
  textFont(font, 35 * wRatio);

  int dist = 60;
  textAlign(LEFT);
  pushMatrix();

  text("Press 1 to start playing", width/12, height/2);
  text("Press 2 to see statistics", width/12, height/2 + dist);
  text("Press 3 to see the instructions", width/12, height/2 + 2*dist);
  text("Press 4 for the credits", width/12, height/2 + 3*dist);
  popMatrix();


  switch(key) {
  case '1':
    gameMode = 1;
    break;
  case '2':
    gameMode = 2;
    break;
  case '3':
    gameMode = 3;
    break;
  case '4':
    gameMode = 4;
    break;
  default:
    gameMode = 0;
    break;
  }
}

void displayPoints() {
  float dist = 80 * wRatio;
  float factor = 1.5;
  textAlign(LEFT);
  textFont(font, 60 * wRatio);
  text("Mejores puntuaciones", width/15, height/10);
  textFont(font, 30 * wRatio);
  pushMatrix();
  translate(-dist, - 4 * dist);
  java.util.Collections.sort(puntuaciones);
  int cont = 0;
  for (int i=puntuaciones.size()-1; i>=puntuaciones.size()-7; i--) {
    text((cont+1) + ". " + puntuaciones.get(i), width/15, height/2 + factor * dist * (cont));
    cont++;
  }
  popMatrix();


  textAlign(LEFT);
  textFont(font, 30 * wRatio);
  text("Press q to come back", 4*width/6, 9*height/10 + 30);
}

void displayInstructions() {

  float dist = 80 * wRatio;
  float factor = 1.5;
  textAlign(LEFT);
  textFont(font, 30 * wRatio);
  pushMatrix();
  translate(-dist, - 4 * dist);
  text("- Use WASD to move and jump.", width/15, height/2);
  text("- Press ',' to discharge and make \n great damage around you.", width/15, height/2 + factor*dist);
  text("- Press '.' to shoot your enemies down.", width/15, height/2 + 2*factor*dist);
  text("- Rainbow rays will recharge your energy \n and provide a bit of extra health.", width/15, height/2 + 3*factor*dist);
  text("- 1 and 0 are like coins, they give you points.", width/15, height/2 + 4*factor*dist);
  text("- All the elements (enemies and aids) \n are respawned every 10 seconds.", width/15, height/2 + 5*factor*dist);
  text("- How much can you last?", width/15, height/2 + 6*factor*dist);
  popMatrix();

  textAlign(LEFT);
  textFont(font, 30 * wRatio);
  text("Press q to come back", 4*width/6, 9*height/10 + 30);
}

void displayAbout() {

  fill(0);
  textAlign(CENTER);
  textFont(font, 50 * wRatio);
  text("Game designed and developed by: \nJesús Enrique Cartas Rascón (Jesi)\nand Álvaro Mendoza González (Mendo)", width/2, height/2 - 180 * wRatio);
  textFont(font, 40 * wRatio);
  text("Thanks to everyone who took the \ntime to play the game. \nIt means the world to us.", width/2, height/2 + 100 * wRatio);


  textAlign(LEFT);
  textFont(font, 30 * wRatio);
  text("Press q to come back", 4*width/6, 9*height/10 + 30);
}


void deathScreen() {
  fill(0);
  textAlign(CENTER);
  textFont(font, 30 * wRatio);
  text("You died. Your final score was: "+puntuaciones.get(puntuaciones.size()-1), width/2, height/2);
  text("Press F to pay respects and start a new game, \nor q to finish", width/2, height/2 + 80);

  if (keys['f'])
    gameMode = 1;
  if (keys['q'])
    gameMode = 0;
}






//LOGICA DEL JUEGO

void generacionElementos() {
  if (frameCount % 400 == 0) {
    int s1 = (int) random(2);
    int s2;
    do{
      s2 = (int) random(2);
    } while(s1==s2);
    enemigos.add(new Imagen(spawners[1][s1], "imgEnemy", 8, 2, false));
    enemigos.add(new Audio(spawners[1][s2], "audEnemy", 19, 2, true));
    int k = int(random(0, 2));
    for (int c = 0; c < 3; c++) {
      if(!ocupados[k][c]){
        coins.add(new Coin(new Vec2(spawners[2][k].x + 25*c, spawners[2][k].y)));
        ocupados[k][c] = true;
      }
    }
    k = int(random(0, 2));
    charges.add(new Charge(spawners[3][k]));
  }
}

void displayMiscelanea() {

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
    if (charges.get(i).show()) {
      charges.get(i).display();
    } else {
      Charge c = charges.get(i);
      charges.remove(i);
      c.killBody();
    }
  }
}

void logicaJugador() {
  //Jugador
  if (jug != null) {
    if ( jug.vidaActual > 0 ) {
      textSize(30);
      fill(0);
      textFont(font, 20);
      textAlign(LEFT);
      text("HP: " + jug.vidaActual + "\t Points: "+jug.getCoins() + "\t Charge: "+jug.carga, 40, 40);
      jug.accion();
      jug.atacar(enemigos);
      jug.display();
      jugPos = box2d.getBodyPixelCoord(jug.body);
    } else {
      puntuaciones.add(jug.puntuacion);
      jug.killBody();
      jug = null;
      jugPos = new Vec2(10000, 10000);
    }
  } else {
    bgMusic.stop();
    gameMode = 5;
    battleTheme.stop();
    setup();
  }
}

void logicaEnemigos() {
  //Enemigos
  for (int i = 0; i<enemigos.size(); i++) {
    if (enemigos.get(i).vidaActual > 0) {
      enemigos.get(i).detectarJugador(jugPos);
      enemigos.get(i).display();
    } else {
      if (jug != null) {
        jug.incrementCoins(100);
      }
      enemigos.get(i).killBody();
      Enemigo e = enemigos.get(i);
      if (e instanceof Audio) {
        deathAudio.play();
      } else {
        if (e instanceof Imagen)
          deathImg.play();
      }
      enemigos.remove(i);
      e = null;
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

  String elemento1 = (String) f1.getUserData();
  String elemento2 = (String) f2.getUserData();    

  switch(elemento1) {

  case "jugador":
    Jugador j = (Jugador) f1.getBody().getUserData();
    switch(elemento2) {
    case "suelo":
      j.onAir = false;
      break;

    case "enemigo":
      j.onAir = false;
      j.takeDamage(10);
      break;

    case "bulletAnimation":
      Bullet b = (Bullet) f2.getBody().getUserData();
      if (b.personaje!=elemento1) {
        j.takeDamage(b.damage);
        b.delete();
      }
      break;

    case "coin":
      Coin c = (Coin) f2.getBody().getUserData();
      Vec2 pos = box2d.getBodyPixelCoord(c.body);
      if(pos.y == 7*height/10){
        for (int i = 0; i < 3; i++) {
          if(pos.x == spawners[2][0].x + 25*i){
            ocupados[0][i] = false;
          }
        }
      } else {
        if(pos.y == height/10){
          for (int i = 0; i < 3; i++) {
            if(pos.x == spawners[2][1].x + 25*i){
              ocupados[1][i] = false;
            }
          }
        }
      }
      j.incrementCoins(c.get());
      coin.play();
      break;

    case "charge":
      Charge ch = (Charge) f2.getBody().getUserData();
      j.recargar(ch.get());
      charge.play();
      break;
    }
    break;

  case "suelo":
    switch(elemento2) {

    case "jugador":
      Jugador ju = (Jugador) f2.getBody().getUserData();
      ju.onAir = false;
      break;

    case "bulletAnimation":
      Bullet bu = (Bullet) f2.getBody().getUserData();
      bu.delete();
      break;
    }
    break;

  case "enemigo":
    Enemigo e = (Enemigo) f1.getBody().getUserData();
    switch(elemento2) {

    case "jugador":
      Jugador ju = (Jugador) f2.getBody().getUserData();
      ju.onAir = false;
      ju.takeDamage(10);
      break;

    case "bulletAnimation":
      Bullet bu = (Bullet) f2.getBody().getUserData();
      if (bu.personaje != elemento1) {
        e.takeDamage(bu.damage);
        bu.delete();
      }
      break;
    }
    break;

  case "bulletAnimation":
    Bullet b = (Bullet) f1.getBody().getUserData();
    boolean borrar = true;

    switch(elemento2) {

    case "jugador":
      if (b.personaje != elemento2) {
        Jugador ju = (Jugador) f2.getBody().getUserData();
        ju.takeDamage(b.damage);
      } else borrar = false;
      break;

    case "enemigo":
      if (b.personaje != elemento2) {
        Enemigo en = (Enemigo) f2.getBody().getUserData();
        en.takeDamage(b.damage);
      } else borrar = false;
      break;

    case "bulletAnimation":
      Bullet b2 = (Bullet) f2.getBody().getUserData();
      if (b.personaje != b2.personaje) {
        b2.delete();
      }
      break;
    
    default:
      borrar=true;
      break;
    }
    
    if(borrar){
      b.delete();
    }
    
    break;

  case "coin":
    Coin c = (Coin) f1.getBody().getUserData();
    switch(elemento2) {
    case "jugador":
      Vec2 pos = box2d.getBodyPixelCoord(c.body);
      if(pos.y == 7*height/10){
        for (int i = 0; i < 3; i++) {
          if(pos.x == spawners[2][0].x + 25*i){
            ocupados[0][i] = false;
          }
        }
      } else {
        if(pos.y == height/10){
          for (int i = 0; i < 3; i++) {
            if(pos.x == spawners[2][1].x + 25*i){
              ocupados[1][i] = false;
            }
          }
        }
      }
      Jugador ju = (Jugador) f2.getBody().getUserData();
      ju.incrementCoins(c.get());
      coin.play();
      break;
      
    case "bulletAnimation":
      Bullet bu = (Bullet) f2.getBody().getUserData();
      bu.delete();
      break;
    
    case "coin":
      c.get();
      break;
    }
    break;
    
  case "charge":
    Charge ch = (Charge) f1.getBody().getUserData();
    switch(elemento2) {
    case "jugador":
      Jugador ju = (Jugador) f2.getBody().getUserData();
      ju.recargar(ch.get());
      charge.play();
      break;
      
    case "bulletAnimation":
      Bullet bu = (Bullet) f2.getBody().getUserData();
      bu.delete();
      break;
      
    case "charge":
      println("charge + charge");
      ch.get();
      break;
    }
    break;
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
