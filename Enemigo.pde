class Enemigo extends Personaje {

  Enemigo(Vec2 center, String spriteDirectory, int numSpr, int numSts) {
    super(center, spriteDirectory, numSpr, numSts);
  }

  void mover() {
    Vec2 vel = body.getLinearVelocity();

    vel.x += random(-50, 50);
    inMotion = true;
    
    if(vel.x < 0)
      currentDirection = LEFT;
    else
      currentDirection = RIGHT;
      
    body.setLinearVelocity(vel);
  }
}
