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
    
    ampX = 1500;
    ampY = 700;
    wX = 0.03;
    wY = 0.1;
    xInicial = center.x;
    yInicial = center.y;
    a = 0;
    dist = 500;
    
    vel = new Vec2(0,0);
    
    vidaMax = 100;
    vidaActual = vidaMax;
  }
  
  void mover() {
    inMotion = true;
    //float pFrames;
    
    if(detectado){
      shoot(jugPos);
      //pFrames = 0.3;
      
      Vec2 pos = box2d.getBodyPixelCoord(this.body);
      float distancia;  
      
      if(jugPos.x<pos.x){
        currentDirection = RIGHT;
        distancia = pos.x - jugPos.x;
        if(distancia<dist){
          vel.x += 5 * wRatio;
        } else {
          if(distancia>dist){
            vel.x -= 5 * wRatio;
          } else vel.x = wX * ampX * cos(wX * a) * wRatio;
        }
      } else {
        currentDirection = LEFT;
        distancia = jugPos.x - pos.x;
        if(distancia<dist){
          vel.x -= 5 * wRatio;
        } else {
          if(distancia>dist){
            vel.x += 5 * wRatio;
          } else vel.x = wX * ampX * cos(wX * a) * wRatio;
        }
      }
  
      body.setLinearVelocity(vel);
      
      preVel = body.getLinearVelocity().x;
    } else {
      //pFrames = 0.90;
      vel.x = wX * ampX * cos(wX * a) * wRatio;
      body.setLinearVelocity(vel);
      if(vel.x > 0)
        currentDirection = LEFT;
      else
        currentDirection = RIGHT;
    }
    vel.y = wY * ampY * sin(wY * a) * wRatio;
    body.setLinearVelocity(vel);   
    a++;
  }
  
  void shoot(Vec2 jugPos){
    if(a%50 == 0){
      Vec2 pos = box2d.getBodyPixelCoord(this.body);
      float sprWidth = sprites[0][0].width;
      
      Vec2 direction = new Vec2(jugPos.x-pos.x, jugPos.y-pos.y);
      
      if(currentDirection == RIGHT){
        pos.x -= sprWidth/2+10;
        projectiles.add(new Bullet(pos, direction, "enemigo"));
      }
      else{
        pos.x += sprWidth/2+10;
        projectiles.add(new Bullet(pos, direction, "enemigo"));
      }
    }
  }
  
}
