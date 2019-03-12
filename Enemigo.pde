class Enemigo extends Personaje {

  float umbralMovimiento = 0.00005;
  float preVel;
  Enemigo(Vec2 center, String spriteDirectory, int numSpr, int numSts) {
    super(center, spriteDirectory, numSpr, numSts);
    preVel = body.getLinearVelocity().x;
    println(body.getLinearVelocity().x);
  }

  void mover() {
    Vec2 vel = body.getLinearVelocity();
    float diff = vel.x - preVel;
    float pMovimiento = random(1);
    
    if (pMovimiento < umbralMovimiento) {
      vel.x += random(-1000, 0);
      body.setLinearVelocity(vel);
      inMotion = true;
    }

    if (diff < 0.03)
      currentDirection = LEFT;
    else
      currentDirection = RIGHT;

    preVel = body.getLinearVelocity().x;
  }
}
