import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

final static int LEFT = 0, RIGHT = 1;
final static int LEFT_ARROW = 37;
final static int UP_ARROW = 38;
final static int RIGHT_ARROW = 39;
final static int DOWN_ARROW = 40;

Box2DProcessing box2d;

Terreno s;
Terreno[] pared = new Terreno[2];
Plataforma[] plataformas = new Plataforma[4];

Jugador jug;
Vec2 jugPos;
Enemigo imgEnemy;
Enemigo audEnemy;
ArrayList<Bullet> projectiles;

PShape bg;

Boolean[] keys;

void setup() {

  //fullScreen(P2D);
  size(1300, 700, P2D);
  frameRate(40);
  imageMode(CENTER);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -700);
  box2d.listenForCollisions();

  bg = loadShape("media/backgrounds/trianglify.svg");
  
  keys = new Boolean[256];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }
  
  projectiles = new ArrayList<Bullet>();

  jug = new Jugador(new Vec2(width/2, height/2), "jugador", 8, 3, false);
  imgEnemy = new Imagen(new Vec2(3*width/4, height/2), "imgEnemy", 8, 2, false);
  //audEnemy = new Audio(new Vec2(3*width/4, 7*height/8), "audEnemy", 19, 2, true);
  s = new Terreno(width/2, height-50, width, 50, "floor");
  pared[0] = new Terreno(0, height/2, 30, height*100, "floor");
  pared[1] = new Terreno(width, height/2, 30, height*100, "floor");
  //plataformas[0] = new Plataforma(width/2, 4*height/5, 300, 20, 1);
  //plataformas[1] = new Plataforma(3*width/4, 4*height/5, 200, 20, 1);
}

void draw() {
  shape(bg);
  //background(150);
  box2d.step(1/(frameRate * 2), 10, 10);
  
  //Jugador
  jug.mover();
  jug.jump();
  jug.display();
  jug.shoot();

  jugPos = box2d.getBodyPixelCoord(jug.body);
  
  //Enemigos
  if(imgEnemy != null){
    if(imgEnemy.vidaActual>0){
      //imgEnemy.detectarJugador(jugPos);
      imgEnemy.display();
    } else {
      imgEnemy.killBody();
      imgEnemy = null;
    }
  }
  
  //audEnemy.detectarJugador(jugPos);
  //audEnemy.display();

  for (int i = projectiles.size()-1; i >= 0; i--) {
    Bullet p = projectiles.get(i);
    p.mover();
    p.display();
    if (p.done()) {
      projectiles.remove(i);
    }
  }

  s.display();
  pared[0].display();
  pared[1].display();
  //plataformas[0].display();
  //plataformas[1].display();

  //plataformas[0].move(1, 100);
  //plataformas[1].move(1, 50);
}


void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();


  if((f1.getUserData().equals("jugador") && f2.getUserData().equals("imgEnemy")) ||
     (f2.getUserData().equals("jugador") && f1.getUserData().equals("imgEnemy")) ){
       Personaje p;
    if(f1.getUserData().equals("jugador")){
      p = (Personaje) f1.getBody().getUserData();
    } else {
      p = (Personaje) f2.getBody().getUserData();
    }
    
    p.takeDamage(10);
    println(p.vidaActual);
  }
  
  if(f2.getUserData().equals("bulletAnimation")){
    Bullet b = (Bullet) f2.getBody().getUserData();

    if(!f1.getUserData().equals("suelo")){
      if(!f1.getUserData().equals(b.personaje)){
        Personaje e = (Personaje) f1.getBody().getUserData();
        e.takingDamage = true;
        e.takeDamage(b.damage);
        println(f1.getBody().getUserData() + ": " + e.vidaActual);
        b.delete();
      }
    } else b.delete();
  }
  

}

// Objects stop touching each other
void endContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Personaje p = (Personaje) f1.getBody().getUserData();
  p.takingDamage = false;
}

void keyPressed() {
  if(key == CODED)
    keys[keyCode] = true;
  else
    keys[key] = true;
  
}

void keyReleased() {
  if(key == CODED)
    keys[keyCode] = false;
  else
    keys[key] = false;
  
}
