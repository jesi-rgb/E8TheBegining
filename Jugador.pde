class Jugador extends Personaje {


  Jugador(Vec2 center, String spriteDirectory) {
    super(center, spriteDirectory);
  }

  void mover() {
    Vec2 vel = body.getLinearVelocity();

    if (keyPressed) {
      if (keys[37]) {
        state = State.left;
      }
      if (keys[39]) {
        state = State.right;
      }
    } else {      
      state = State.stop;
    }

    switch(state) {
    case left:
      vel.x -= 10;
      inMotion = true;
      currentDirection = LEFT;
      break;
    case right:
      vel.x += 10;
      inMotion = true;
      currentDirection = RIGHT;
      break;
    case stop:
      vel.x *= 0.69;
      break;
    }

    body.setLinearVelocity(vel);
  }

  void jump() {
    Vec2 vel = body.getLinearVelocity();
    if (keys[32] && !(vel.y < 0) && !onAir) {
      onAir = true;
    }else
      onAir = false;
    
    if(onAir){
      vel.y += 150;
      body.applyLinearImpulse(vel, body.getWorldCenter(), true);
    }
    println(vel.y);
    
  }
}
