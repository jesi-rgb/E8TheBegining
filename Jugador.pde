class Jugador extends Personaje {
  float preVelY;
  int ALTO_ATAQUE = sprites[RIGHT][0].height;
  int ANCHO_ATAQUE = 100;

  Jugador(Vec2 center, String spriteDirectory, int numSpr, int numSts, boolean flotante) {
    super(center, spriteDirectory, numSpr, numSts, flotante);
    preVelY = body.getLinearVelocity().y;
    vidaMax = 100;
    vidaActual = 100;
  }

  void accion() {
    mover();
    jump();
    shoot();
  }

  void mover() {
    Vec2 vel = body.getLinearVelocity();

    if (keyPressed) {
      if (keys['a'] || keys[LEFT_ARROW]) {
        state = State.left;
      }
      if (keys['d'] || keys[RIGHT_ARROW]) {
        state = State.right;
      }
    } else {      
      state = State.stop;
    }

    switch(state) {
    case left:
      vel.x -= 10;
      inMotion = true;
      currentDirection = LEFT;
      break;
    case right:
      vel.x += 10;
      inMotion = true;
      currentDirection = RIGHT;
      break;
    case stop:
      vel.x *= 0.69;
      break;
    }

    body.setLinearVelocity(vel);
  }

  void jump() {
    Vec2 vel = body.getLinearVelocity();
    float diff =  vel.y - preVelY;

    if (abs(diff)>3) {
      onAir=true;
    } else onAir = false;

    //Si se pulsa space y no estamos en el aire, saltamos
    if ((keys[' '] || keys[UP_ARROW]) && !onAir) {
      //estamos en el aire
      onAir=true;
      keys[32]=false; //Si lo descomentamos habrá que pulsar espacio cada vez que queramos saltar
      vel.y += 500;
      body.applyLinearImpulse(vel, body.getWorldCenter(), true);
    }

    preVelY = body.getLinearVelocity().y;
  }

  void shoot() {
    if (keys['.'] && frameCount%5 == 0) {
      Vec2 pos = box2d.getBodyPixelCoord(this.body);
      float sprWidth = sprites[0][0].width;

      if (currentDirection == LEFT) {
        pos.x -= sprWidth/2+10;
        projectiles.add(new Bullet(pos, new Vec2(-10, 0), "jugador"));
      } else {
        pos.x += sprWidth/2+10;
        projectiles.add(new Bullet(pos, new Vec2(10, 0), "jugador"));
      }
    }
  }

  void atacar(ArrayList<Enemigo> enemigos) {
    if (keyPressed) {
      if (keys[',']) {
        Vec2 pos = box2d.getBodyPixelCoord(this.body);
        if (currentDirection == LEFT) {
          for (int i=0; i<enemigos.size(); i++) {
            Vec2 posEnemy = box2d.getBodyPixelCoord(enemigos.get(i).body);
            if (((posEnemy.x + enemigos.get(i).sprites[RIGHT][0].width/2) > (pos.x - ANCHO_ATAQUE/2)) &&
              (posEnemy.y + enemigos.get(i).sprites[RIGHT][0].height/2 > (pos.y - ALTO_ATAQUE/2)) &&
              (posEnemy.y - enemigos.get(i).sprites[RIGHT][0].height/2 < (posEnemy.y + ALTO_ATAQUE/2))) {
              enemigos.get(i).recibirGolpe(LEFT, 20);
            }
          }
          rect(pos.x, pos.y, ANCHO_ATAQUE, ALTO_ATAQUE);
        } else {
          for (int i=0; i<enemigos.size(); i++) {
            Vec2 posEnemy = box2d.getBodyPixelCoord(enemigos.get(i).body);
            if (((posEnemy.x - enemigos.get(i).sprites[RIGHT][0].width/2) < (pos.x + ANCHO_ATAQUE/2)) &&
              (posEnemy.y + enemigos.get(i).sprites[RIGHT][0].height/2 > (pos.y - ALTO_ATAQUE/2)) &&
              (posEnemy.y - enemigos.get(i).sprites[RIGHT][0].height/2 < (posEnemy.y + ALTO_ATAQUE/2))) {
              enemigos.get(i).recibirGolpe(RIGHT, 20);
            }
          }
          rect(pos.x, pos.y, ANCHO_ATAQUE, ALTO_ATAQUE);
        }
      }
    }
  }
}
