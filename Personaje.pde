static enum State {
  stop, left, right
}

abstract class Personaje {

  //Vec2 position; //Pretty self explanatory vectors.
  Vec2 velocity;
  //Vec2 acceleration;

  PImage[][] sprites; //Matriz para guardar los sprites.

  State state; //Indica si el personaje está parado, en movimiento, saltando, etc...
  Boolean inMotion; //Comprueba si el personaje está en movimiento o no.
  Boolean onAir;
  int currentDirection; //Nos dice la dirección hacia la que mira el personaje.
  float currentFrame; //Nos indica el sprite que estamos reproduciendo.

  Body body; //Para el motor de físicas.

  //Pretty self explanatory constants.
  final int NUM_SPRITES = 8;
  final int VELOCITY_LIMIT = 8;
  final int NUM_STATES = 3; //estados del personaje (saltar, correr dcha, izda, etc...)


  /*
  Constructor del personaje. Se le pasa un vector posición para indicar
   la posición en pantalla.
   */
  Personaje(Vec2 center, String spriteDirectory) {

    velocity = new Vec2(0, 0);

    state = State.stop;

    currentFrame = 0;
    inMotion = false;
    onAir = false;
    currentDirection = RIGHT;

    sprites = new PImage[NUM_STATES][NUM_SPRITES];
    for (int i=0; i<NUM_SPRITES; i++) {
      sprites[LEFT][i] = loadImage("media/"+spriteDirectory+"/"+LEFT+"/spr"+(i+1)+".png");
      sprites[RIGHT][i] = loadImage("media/"+spriteDirectory+"/"+RIGHT+"/spr"+(i+1)+".png");
    }
    sprites[2][0] = loadImage("media/"+spriteDirectory+"/jump/jump0.png");
    sprites[2][1] = loadImage("media/"+spriteDirectory+"/jump/jump1.png");

    makeBody(center);
    body.setUserData(this);
  }



  /*
   Función para pintar en pantalla el personaje.
   Dependiendo de si se mueve cogeremos un set de sprites
   u otro, y esto viene guiado por el atributo inMotion.
   */
  void display() {

    Vec2 pos = box2d.getBodyPixelCoord(body);
    currentFrame = (currentFrame + 1) % (NUM_SPRITES-1);
    Vec2 vel = body.getLinearVelocity();

    if ( (vel.x > -4.5 && vel.x <= 0) || (vel.x < 4.5 && vel.x >= 0) )
      inMotion = false;

    if (onAir) {
      image(sprites[2][currentDirection], pos.x, pos.y);
    } else
      if (inMotion) {
        image(sprites[currentDirection][1+int(currentFrame)], pos.x, pos.y);
      } else {
        image(sprites[currentDirection][0], pos.x, pos.y);
      }
  }


  abstract void mover();

  void makeBody(Vec2 center) {
    //Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position = box2d.coordPixelsToWorld(center);

    //Make a body object out of that definition
    body = box2d.createBody(bd);

    //Define the bounding box that is gonna experience all the forces
    PolygonShape boundingBox = new PolygonShape();
    float box2dw = box2d.scalarPixelsToWorld(sprites[RIGHT][0].width/2);
    float box2dh = box2d.scalarPixelsToWorld(sprites[RIGHT][0].height/2);
    boundingBox.setAsBox(box2dw, box2dh);

    //Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = boundingBox;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.01;

    //Attach the fixture to the body
    body.createFixture(fd);
    body.resetMassData();
  }
}
