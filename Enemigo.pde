class Enemigo extends Personaje {
  
  float umbralMovimiento = 0.9;
  float umbralParada = 0.9;
  float preVel;
  boolean moviendo;

  Enemigo(Vec2 center, String spriteDirectory, int numSpr, int numSts) {
    super(center, spriteDirectory, numSpr, numSts);
    preVel = body.getLinearVelocity().x;
    inMotion = false;
    moviendo = false;
  }

  void mover() {
    float diff = body.getLinearVelocity().x - preVel;
    if(abs(diff)<0.3){
      inMotion = false;
    } else inMotion = true;
    
    float alfa;
    if(!moviendo){
      alfa = random(1);
      if(alfa>umbralMovimiento){
        moviendo=true;
      }
    }
    
    if(moviendo){
      Vec2 vel = body.getLinearVelocity();
      
      if(currentDirection == LEFT){
        vel.x += random(-10,-3);
      } else vel.x += random(3,10);
      
      body.setLinearVelocity(vel);
      
      alfa = random(1);
      if(alfa > umbralParada){
        moviendo = false;
        alfa = random(1);
        if(alfa > 0.75) currentDirection = (currentDirection + 1)%2;
      }
      
      preVel = body.getLinearVelocity().x;
    }
  }
}
