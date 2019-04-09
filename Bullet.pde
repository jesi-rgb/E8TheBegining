class Bullet extends Personaje{
  
  Vec2 direction;
  boolean delete;
  int damage;
  String personaje;
  
  Bullet(Vec2 origin, Vec2 dest, String pers){
    super(origin, "bulletAnimation", 9, 2, true);
    direction = dest;
    delete = false;
    damage = 10;
    personaje = pers;
  }
  
  void mover(){
    inMotion = true;
    if(direction.x < 0){
      velocity.x -= 10;
      currentDirection = RIGHT;
    }else{
      velocity.x += 10;
      currentDirection = LEFT;
    }
      
    body.setLinearVelocity(velocity);
    
  }
  
  boolean done() {
    if (delete) {
      killBody();
      return true;
    }
    return false;
  }
  
  void killBody() {
    box2d.destroyBody(body);
  }
  
  void delete(){
    delete = true;
  }

}
