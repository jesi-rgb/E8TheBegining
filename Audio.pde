class Audio extends Enemigo{
  float xInicial;
  float yInicial;
  private boolean impulsar;
  int sentido;
  int len;
  
  Audio(Vec2 center, String spriteDirectory, int numSpr, int numSts, float density){
    super(center, spriteDirectory, numSpr, numSts, density);
    ANCHO_VISION = 1000;
    ALTO_VISION = 500;
    impulsar = false;
    preVel = body.getLinearVelocity().y;
    sentido = LEFT;
    len = 180;
    xInicial = center.x;
    yInicial = center.y;
    VELOCITY_LIMIT = 30;
  }
  
  void mover() {
    Vec2 vel = body.getLinearVelocity();
    if(abs(preVel - vel.y) < 0.1){
      impulsar = true;
    }
    if(vel.y<=0.1 && impulsar){
      body.applyLinearImpulse(new Vec2(0, 1000), body.getWorldCenter(), true);
      //body.applyForce(new Vec2(0, 1000), body.getWorldCenter());
      impulsar = false;
    }
    
    preVel = body.getLinearVelocity().y;
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (sentido == RIGHT) {
      println("RIGHT");
      if (pos.x<(xInicial+len)) {
        vel.x = 40;
      } else sentido = LEFT;
    } else {
      if (pos.x>(xInicial-len)) {
        vel.x = -40;
      } else sentido = RIGHT;
    }
    
    body.setLinearVelocity(vel);
  }
}
