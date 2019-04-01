abstract class Enemigo extends Personaje {

  float umbralMovimiento;
  float umbralParada;
  float preVel;
  boolean moviendo;
  int ANCHO_VISION;
  int ALTO_VISION;

  Enemigo(Vec2 center, String spriteDirectory, int numSpr, int numSts, boolean dynamic) {
    super(center, spriteDirectory, numSpr, numSts, dynamic);
    preVel = body.getLinearVelocity().x;
    inMotion = false;
    moviendo = false;
  }

  abstract void mover();

  void moverHaciaJugador(Vec2 jugPos) {
    Vec2 vel = body.getLinearVelocity();
    Vec2 pos = box2d.getBodyPixelCoord(this.body);

    float diff = vel.x - preVel;
    if (abs(diff) < 0.3) {
      inMotion = false;
    } else inMotion = true;

    if (jugPos.x > (pos.x - ANCHO_VISION/2) && jugPos.x < pos.x) {
      currentDirection = LEFT;
      vel.x -= 5;
    }
    
    if (jugPos.x < (pos.x + ANCHO_VISION/2) && jugPos.x > pos.x) {
      currentDirection = RIGHT;
      vel.x += 5;
    }

    body.setLinearVelocity(vel);
    
    preVel = body.getLinearVelocity().x;
  }

  void detectarJugador(Vec2 jugPos) {
    rectMode(CENTER);
    Vec2 pos = box2d.getBodyPixelCoord(this.body);

    if ( (jugPos.x > (pos.x - ANCHO_VISION/2)) && (jugPos.x < (pos.x + ANCHO_VISION/2)) &&
         (jugPos.y > (pos.y - ALTO_VISION/2)) && (jugPos.y < (pos.y + ALTO_VISION/2))
    ) {
      fill(250, 10, 10, 80); //rojo, jugador dentro de campo de visión. nos movemos hacia él
      ANCHO_VISION = 1300;
      moverHaciaJugador(jugPos);
    } else {
      fill(10, 10, 250, 80); //azul, no hay vergas en la costa
      ANCHO_VISION = 1000;
      mover();
    }
    //rect(pos.x, pos.y, ANCHO_VISION, ALTO_VISION); //cuadrado de debuggeo para ayudar a visualizar
  }
}
