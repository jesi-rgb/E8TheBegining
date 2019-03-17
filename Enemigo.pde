class Enemigo extends Personaje {

  float umbralMovimiento = 0.98;
  float umbralParada = 0.8;
  float preVel;
  boolean moviendo;
  int ANCHO_VISION = 400;
  final int ALTO_VISION = 200;

  Enemigo(Vec2 center, String spriteDirectory, int numSpr, int numSts) {
    super(center, spriteDirectory, numSpr, numSts);
    preVel = body.getLinearVelocity().x;
    inMotion = false;
    moviendo = false;
  }

  void mover() {
    float diff = body.getLinearVelocity().x - preVel;
    if (abs(diff) < 0.3) {
      inMotion = false;
    } else inMotion = true;

    float alfa;
    if (!moviendo) {
      alfa = random(1);
      if (alfa>umbralMovimiento) {
        moviendo=true;
      }
    }

    if (moviendo) {
      Vec2 vel = body.getLinearVelocity();

      if (currentDirection == LEFT) {
        vel.x += random(-10, -3);
      } else vel.x += random(3, 10);

      body.setLinearVelocity(vel);

      alfa = random(1);
      if (alfa > umbralParada) {
        moviendo = false;
        alfa = random(1);
        if (alfa > 0.75) currentDirection = (currentDirection + 1)%2;
      }

      preVel = body.getLinearVelocity().x;
    }
  }

  void moverHaciaJugador(Vec2 jugPos) {
    Vec2 vel = body.getLinearVelocity();
    Vec2 pos = box2d.getBodyPixelCoord(this.body);

    float diff = vel.x - preVel;
    if (abs(diff) < 0.3) {
      inMotion = false;
    } else inMotion = true;

    if (jugPos.x > (pos.x - ANCHO_VISION/2) && jugPos.x < pos.x) {
      currentDirection = LEFT;
      vel.x -= 3;
    }
    
    if (jugPos.x < (pos.x + ANCHO_VISION/2) && jugPos.x > pos.x) {
      currentDirection = RIGHT;
      vel.x += 3;
    }

    body.setLinearVelocity(vel);
    
    preVel = body.getLinearVelocity().x;
  }

  void detectarJugador(Vec2 jugPos) {
    rectMode(CENTER);
    Vec2 pos = box2d.getBodyPixelCoord(this.body);

    if ( (jugPos.x > (pos.x - ANCHO_VISION/2)) && (jugPos.x < (pos.x + ANCHO_VISION/2)) ) {
      fill(250, 10, 10, 80); //rojo, jugador dentro de campo de visión. nos movemos hacia él
      ANCHO_VISION = 800;
      moverHaciaJugador(jugPos);
    } else {
      fill(10, 10, 250, 80); //azul, no hay moros en la costa
      ANCHO_VISION = 400;
      mover();
    }
    rect(pos.x, pos.y, ANCHO_VISION, ALTO_VISION); //cuadrado de debuggeo para ayudar a visualizar
  }
}
