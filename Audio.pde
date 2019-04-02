class Audio extends Enemigo{
  float xInicial;
  float yInicial;
  int sentido;
  int ampX;
  int ampY;
  float wX;
  float wY;
  int a;
  Vec2 vel;
  
  Audio(Vec2 center, String spriteDirectory, int numSpr, int numSts, boolean flotante){
    super(center, spriteDirectory, numSpr, numSts, flotante);
    ANCHO_VISION = 1000;
    ALTO_VISION = 500;
    preVel = body.getLinearVelocity().y;
    sentido = LEFT;
    ampX = 1000;
    ampY = 500;
    wX = 0.03;
    wY = 0.1;
    xInicial = center.x;
    yInicial = center.y;
    a = 0;
    vel = new Vec2(0,0);
  }
  
  void mover() {
    if(detectado){
      Vec2 pos = box2d.getBodyPixelCoord(this.body);
  
      float diff = vel.x - preVel;
      if (abs(diff) < 0.3) {
        inMotion = false;
      } else inMotion = true;
  
      if (abs(jugPos.x-pos.x) < 800 && jugPos.x < pos.x) {
        currentDirection = RIGHT;
        vel.x += 5;
      }
      
      if (abs(jugPos.x-pos.x) < 800 && jugPos.x > pos.x) {
        currentDirection = LEFT;
        vel.x -= 5;
      }
  
      body.setLinearVelocity(vel);
      
      preVel = body.getLinearVelocity().x;
    } else {
      vel.x = wX * ampX * cos(wX * a);
      body.setLinearVelocity(vel);
    }
    vel.y = wY * ampY * sin(wY * a);
    body.setLinearVelocity(vel);
    inMotion = true;
    if(vel.x > 0)
      currentDirection = LEFT;
    else
      currentDirection = RIGHT;
      
    a++;
    if(random(1) < 0.95)
      currentFrame--;
    
  }
}
