class Imagen extends Enemigo{
  
  Imagen(Vec2 center, String spriteDirectory, int numSpr, int numSts, boolean flotante){
    super(center, spriteDirectory, numSpr, numSts, flotante);
    
    umbralMovimiento = 0.98;
    umbralParada = 0.8;
    ANCHO_VISION = 1000;
    ALTO_VISION = 500;
    
    vidaMax = 200;
    vidaActual = vidaMax;
  }
  
  void mover() {
    Vec2 vel = body.getLinearVelocity();
    if(detectado){
      Vec2 pos = box2d.getBodyPixelCoord(this.body);
  
      float diff = vel.x - preVel;
      if (abs(diff) < 0.3) {
        inMotion = false;
      } else inMotion = true;
  
      if (jugPos.x > (pos.x - ANCHO_VISION/2) && jugPos.x < pos.x) {
        currentDirection = LEFT;
        vel.x -= 5 * wRatio;
      }
      
      if (jugPos.x < (pos.x + ANCHO_VISION/2) && jugPos.x > pos.x) {
        currentDirection = RIGHT;
        vel.x += 5 * wRatio;
      }
  
      body.setLinearVelocity(vel);
      
      preVel = body.getLinearVelocity().x;
    } else {
      float diff = vel.x - preVel;
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
  
        if (currentDirection == LEFT) {
          vel.x += random(-10, -3) * wRatio;
        } else vel.x += random(3, 10) * wRatio;
  
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
  
  
  
  void killBody() {
    box2d.destroyBody(body);
  }
}
