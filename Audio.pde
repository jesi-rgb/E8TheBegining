class Audio extends Enemigo{
  float xInicial;
  float yInicial;
  int sentido;
  int ampX;
  int ampY;
  float wX = 0.03;
  float wY = 0.1;
  int a;
  Vec2 vel;
  
  Audio(Vec2 center, String spriteDirectory, int numSpr, int numSts, boolean dynamic){
    super(center, spriteDirectory, numSpr, numSts, dynamic);
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
    vel.x = wX * ampX * cos(wX * a);
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
