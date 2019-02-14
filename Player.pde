class Player {
  PVector position; //Pretty self explanatory vectors.
  PVector velocity;
  PVector acceleration;

  PImage[][] sprites; //Matriz para guardar los sprites.

  Boolean inMotion; //Comprueba si el personaje está en movimiento o no.
  int currentDirection; //Nos dice la dirección hacia la que mira el personaje.
  float currentFrame; //Nos indica el sprite que estamos reproduciendo.

  final int LEFT = 0, RIGHT = 1; //Pretty self explanatory constants.
  final int numSprites = 8;
  final int velocityLimit = 8;


  /*
  Constructor del personaje. Se le pasa un vector posición para indicar
   la posición en pantalla.
   */
  Player(PVector pos) {
    position = pos;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    currentFrame = 0;
    inMotion = false;
    sprites = new PImage[2][numSprites];
    for (int i=0; i<numSprites; i++) {
      sprites[LEFT][i] = loadImage("media/"+LEFT+"/spr"+(i+1)+".png");
      sprites[RIGHT][i] = loadImage("media/"+RIGHT+"/spr"+(i+1)+".png");
    }
  }



  /*
  Función para pintar en pantalla el personaje.
   Dependiendo de si se mueve cogeremos un set de sprites
   u otro, y esto viene guiado por el atributo inMotion.
   */
  void display() {
    if (inMotion) {
      image(sprites[currentDirection][1+int(currentFrame)], position.x, position.y);
    } else {
      image(sprites[currentDirection][0], position.x, position.y);
      println("inmotion = false");
    }
  }

  /*
  Función que actualiza todo lo referente al personaje.
   El parámetro xDelta se utiliza para comprobar en qué 
   dirección se estaba moviendo.
   */
  void update(float xDelta) {

    //Esta sección actualiza las físicas del personaje.
    position.add(velocity);
    if (!keyPressed) {
      dragForce(acceleration, 0.5);
      dragForce(velocity, 0.88);
    }
    velocity.add(acceleration);
    velocity.limit(velocityLimit);
    acceleration.limit(velocityLimit);


    //Esta sección actualiza los sprites.

    //Cálculo para ver qué velocidad tenemos y loopear sobre los sprites
    //en base a esa velocidad.
    float frameRateFactor = abs(map(velocity.x, 1, velocityLimit, 1, 1.4));
    currentFrame = (currentFrame + frameRateFactor) % (numSprites-1);

    /*
    Esta comprobación evalúa si xDelta está en el intervalo [-0.3, 0] o [0, 0.3].
     
     Debido a cómo funcionan los PVectores aquí, nunca llegan a ser 0 del todo, y 
     cuando nuestra velocidad sea 0, queremos poner inMotion a false
     para activar el sprite de estar de pie, y no corriendo. 
     
     Por ello, necesitamos evaluar si está en un umbral aceptable para parar, en vez
     de comprobar directamente si xDelta == 0.
     */
    if ( ((xDelta < 0.3) && (xDelta > 0)) || ((xDelta > -0.3) && (xDelta < 0)) ) 
      inMotion = false;
    else {
      inMotion = true;
      if (xDelta < 0)
        currentDirection = LEFT;
      else if (xDelta > 0)
        currentDirection = RIGHT;
    }

    position.x += xDelta;
  }


  /*
  Función para hacer que la velocidad del personaje decaiga de forma gradual.
   */
  void dragForce(PVector v, float factor) {
    PVector drag = new PVector(-v.x * factor, -v.y * factor);
    v.add(drag);
  }

  /*
  Función para hacer que si llega a un borde, aparezca
   por el otro
   */
  void edges() {
    if (position.x > width)
      position.x = 0;
    if (position.x < 0)
      position.x = width;
    if (position.y > height)
      position.y = 0;
    if (position.y < 0)
      position.y = height;

    if (position.y >= height/2) {
      position.y = height/2;
    }
  }
  
}
