
static enum state {
  stop, left, right
}

abstract class Personaje {


  //Vec2 position; //Pretty self explanatory vectors.
  Vec2 velocity;
  //Vec2 acceleration;

  PImage[][] sprites; //Matriz para guardar los sprites.

  state state;
  Boolean inMotion; //Comprueba si el personaje está en movimiento o no.
  int currentDirection; //Nos dice la dirección hacia la que mira el personaje.
  float currentFrame; //Nos indica el sprite que estamos reproduciendo.

  Body body; //Para el motor de físicas.

  //Pretty self explanatory constants.
  final int NUM_SPRITES = 8;
  final int VELOCITY_LIMIT = 8;
  final int NUM_STATES = 2; //estados del personaje (saltar, correr dcha, izda, etc...)


  /*
  Constructor del personaje. Se le pasa un vector posición para indicar
   la posición en pantalla.
   */
  Personaje(Vec2 center, String spriteDirectory) {

    velocity = new Vec2(0, 0);

    state = state.stop;

    currentFrame = 0;
    inMotion = false;
    currentDirection = RIGHT;

    sprites = new PImage[NUM_STATES][NUM_SPRITES];
    for (int i=0; i<NUM_SPRITES; i++) {
      sprites[LEFT][i] = loadImage("media/"+spriteDirectory+"/"+LEFT+"/spr"+(i+1)+".png");
      sprites[RIGHT][i] = loadImage("media/"+spriteDirectory+"/"+RIGHT+"/spr"+(i+1)+".png");
    }

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
    
    if( (vel.x > -4.5 && vel.x <= 0) || (vel.x < 4.5 && vel.x >= 0) )
      inMotion = false;
    
    if (inMotion) {
      image(sprites[currentDirection][1+int(currentFrame)], pos.x, pos.y);
    } else {
      image(sprites[currentDirection][0], pos.x, pos.y);
    }
  }

  /*
  Función que actualiza todo lo referente al personaje.
   El parámetro xDelta se utiliza para comprobar en qué 
   dirección se estaba moviendo.
   */
  //void update() {

    //Esta sección actualiza las físicas del personaje.
    //position.add(velocity);
    //if (!keyPressed) {
    //  dragForce(acceleration, 0.5);
    //  dragForce(velocity, 0.88);
    //}
    //velocity.add(acceleration);
    //velocity.limit(VELOCITY_LIMIT);
    //acceleration.limit(VELOCITY_LIMIT);


    //Esta sección actualiza los sprites.

    //Cálculo para ver qué velocidad tenemos y loopear sobre los sprites
    //en base a esa velocidad.
    //float frameRateFactor = abs(map(velocity.x, 1, VELOCITY_LIMIT, 1, 1.4));
    //currentFrame = (currentFrame + 1) % (NUM_SPRITES-1);

    /*
     Esta comprobación evalúa si xDelta está en el intervalo [-0.3, 0] o [0, 0.3].
     
     Debido a cómo funcionan los PVectores aquí, nunca llegan a ser 0 del todo, y 
     cuando nuestra velocidad sea 0, queremos poner inMotion a false
     para activar el sprite de estar de pie, y no corriendo. 
     
     Por ello, necesitamos evaluar si está en un umbral aceptable para parar, en vez
     de comprobar directamente si xDelta == 0.
     */


    //if ( ((xDelta < 0.3) && (xDelta >= 0)) || ((xDelta > -0.3) && (xDelta <= 0)) ) 
    //  inMotion = false;
    //else {
    //  inMotion = true;
    //  if (xDelta < 0)
    //    currentDirection = LEFT;
    //  else if (xDelta > 0)
    //    currentDirection = RIGHT;
    //}

    //position.x += xDelta;
//  }

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
    fd.density = 0.03;
    fd.friction = 0.3;
    fd.restitution = 0.01;

    //Attach the fixture to the body
    body.createFixture(fd);
    body.resetMassData();
  }
}
