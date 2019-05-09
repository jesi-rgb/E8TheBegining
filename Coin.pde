class Coin{
  
  PVector pos;
  int value;
  PImage sprite;
  
  Body body;
  
  Coin(PVector p){
    pos = p;
    value = 10;
    sprite = loadImage("media/scenarios/coins/coin1.png");
  }
  
  void display(){
    image(sprite, pos.x, pos.y);
  }
  
}
