final int LEFT = 0, RIGHT = 1;

Jugador jug;
Boolean[] keys;
PImage background;

void setup() {
  size(800, 450, P2D);
  //fullScreen(P2D);
  frameRate(40);
  keys = new Boolean[128];
  for (int i=0; i<keys.length; i++) {
    keys[i] = false;
  }
  jug = new Jugador(new PVector(width/2, height/2), "jugador");
  background = loadImage("binary scene.png");
}

void draw() {
  beginShape();
  texture(background);
  vertex(0, 0, 0, 0);
  vertex(0, height, 0, height);
  vertex(width, height, width, height);
  vertex(width, 0, width, 0);
  endShape(CLOSE);
  
  move();
  jug.update(jug.velocity.x);
  jug.edges();
  jug.display();
}

void move() {
  if (keys[37]) { //left
    jug.acceleration.x -= 5;
  }
  if (keys[39]) { //right
    jug.acceleration.x += 5;
  }
}

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}
