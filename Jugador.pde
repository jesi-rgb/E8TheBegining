class Jugador extends Personaje {


  Jugador(Vec2 center, String spriteDirectory) {
    super(center, spriteDirectory);
  }
  
  void mover() {
    Vec2 vel = body.getLinearVelocity();

    if (keyPressed) {
      if (keys[37]) {
        state = state.left;
      }
      if (keys[39]) {
        state = state.right;
      }
    } else {      
      state = state.stop;
      
    }
    
    switch(state){
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
}
