class Imagen extends Enemigo{
  
  Imagen(Vec2 center, String spriteDirectory, int numSpr, int numSts, float density){
    super(center, spriteDirectory, numSpr, numSts, density);
    umbralMovimiento = 0.98;
    umbralParada = 0.8;
    ANCHO_VISION = 1000;
    ALTO_VISION = 500;
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
}
