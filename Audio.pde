class Audio extends Enemigo{
  float xInicial;
  float yInicial;
  int sentido;
  int ampX;
  int ampY;
  float wX;
  float wY;
  int a;
  float dist;
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
    dist = 100;
    
    vel = new Vec2(0,0);
    
    body.setUserData(this);
  }
  
  void mover() {
    inMotion = true;
    //float pFrames;
    
    if(detectado){
      //pFrames = 0.3;
      
      Vec2 pos = box2d.getBodyPixelCoord(this.body);
      float distancia;  
      
      if(jugPos.x<pos.x){
        currentDirection = RIGHT;
        distancia = pos.x - jugPos.x;
        if(distancia<dist){
          vel.x += 5;
        } else {
          if(distancia>dist){
            vel.x -= 5;
          } else vel.x = wX * ampX * cos(wX * a);
        }
      } else {
        currentDirection = LEFT;
        distancia = jugPos.x - pos.x;
        if(distancia<dist){
          vel.x -= 5;
        } else {
          if(distancia>dist){
            vel.x += 5;
          } else vel.x = wX * ampX * cos(wX * a);
        }
      }
  
      body.setLinearVelocity(vel);
      
      preVel = body.getLinearVelocity().x;
    } else {
      //pFrames = 0.90;
      vel.x = wX * ampX * cos(wX * a);
      body.setLinearVelocity(vel);
      if(vel.x > 0)
        currentDirection = LEFT;
      else
        currentDirection = RIGHT;
    }
    vel.y = wY * ampY * sin(wY * a);
    body.setLinearVelocity(vel);   
    a++;
  }
  
}
