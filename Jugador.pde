class Jugador extends Personaje {
  Vec2 prevVel;

  Jugador(Vec2 center, String spriteDirectory, int numSpr, int numSts) {
    super(center, spriteDirectory, numSpr, numSts);
    prevVel = body.getLinearVelocity();
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
    float diff =  vel.y - prevVel.y;
    
    //Si se pulsa space y no estamos en el aire, saltamos
    if(keys[32] && !onAir){
      //estamos en el aire
      onAir=true;
      keys[32]=false; //Si lo descomentamos habrá que pulsar espacio cada vez que queramos saltar
      vel.y += 500;
      body.applyLinearImpulse(vel, body.getWorldCenter(), true);
    }
    //Hemos llegado a una superficie, no estamos en el aire
    
    //println(vel.y +" - "+prevVel.y+" = "+diff);
    
    if(diff >= 0 && diff <= 0.03){
      onAir = false;
    }
    
  }
}
