class JeShape {
  Body body;
  Vec2[] vertices;


  JeShape(ArrayList<RPoint> points) {

    ChainShape chain = new ChainShape();
    vertices = new Vec2[points.size()+1];
    for (int i = 0; i < points.size(); i++) {
      Vec2 edge = box2d.coordPixelsToWorld(new Vec2(points.get(i).x, points.get(i).y));
      vertices[i] = edge;
    }
    vertices[points.size()] = box2d.coordPixelsToWorld(new Vec2(points.get(0).x, points.get(0).y));
    chain.createChain(vertices, vertices.length);
    

    BodyDef bd = new BodyDef();
    Body body = box2d.createBody(bd);
    body.createFixture(chain, 1);
    body.setUserData("suelo");
    body.getFixtureList().setUserData("suelo");
  }

  void display() {
    
    PVector esqInfIzda = box2d.coordWorldToPixelsPVector(vertices[0]);
    PVector esqSupDcha = box2d.coordWorldToPixelsPVector(vertices[2]);

    float w, h;
    w = abs(esqInfIzda.x - esqSupDcha.x);  
    h = abs(esqInfIzda.y - esqSupDcha.y);
    
    noStroke();
    textureMode(NORMAL);
    textureWrap(REPEAT);
    fill(70);
    rect(esqInfIzda.x, esqInfIzda.y, w, h);
    //tint(random(0, 255), random(0, 255), random(0, 255), random(0, 255));
    
    //beginShape();
    //  texture(tex);
    //  vertex(esqInfIzda.x, esqInfIzda.y, 0, 0);
    //  vertex(esqInfIzda.x + w, esqInfIzda.y, 1, 0);
    //  vertex(esqInfIzda.x + w, esqInfIzda.y + h, 1, 1);
    //  vertex(esqInfIzda.x, esqInfIzda.y + h, 0, 1);
    //  vertex(esqInfIzda.x, esqInfIzda.y, 0, 0);
    //endShape();
    
    noTint();
  }
}
