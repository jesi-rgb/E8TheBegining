class Bullet extends Personaje{
  
  Vec2 direction;
  boolean delete;
  int damage;
  String personaje;
  float a;
  
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
      velocity.x -= 10 * wRatio;
      currentDirection = RIGHT;
    }else{
      velocity.x += 10 * wRatio;
      currentDirection = LEFT;
    }
    
    float seno = direction.y / (sqrt(pow(direction.x, 2) + pow(direction.y, 2)));
    velocity.y -= 10 * seno * wRatio;
    
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

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    currentFrame = (currentFrame + 1) % (NUM_SPRITES-1);
    pushMatrix();
      translate(pos.x,pos.y);
      rotate(a);
      image(sprites[currentDirection][1+int(currentFrame)], 0, 0);
    popMatrix();
  }

}
