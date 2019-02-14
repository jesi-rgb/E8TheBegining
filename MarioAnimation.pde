Player p;
Boolean[] keys;

void setup() {

  fullScreen();
  frameRate(40);
  keys = new Boolean[128];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }
  p = new Player(new PVector(width/2, height/2));
}

void draw() {
  background(40, 104, 0);
  move();
  p.update(p.velocity.x);
  p.edges();
  p.display();
}

void move() {
  if (keys[37]) { //left
    p.acceleration.x -= 5;
  }
  if (keys[39]) { //right
    p.acceleration.x += 5;
  }
}

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}
