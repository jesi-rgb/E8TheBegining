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
  }

  void display() {
    
    PVector esqInfIzda = box2d.coordWorldToPixelsPVector(vertices[0]);
    PVector esqSupDcha = box2d.coordWorldToPixelsPVector(vertices[2]);

    float w, h;
    w = abs(esqInfIzda.x - esqSupDcha.x);
    h = abs(esqInfIzda.y - esqSupDcha.y);
    
    strokeWeight(2);
    stroke(0);
    textureMode(NORMAL);
    textureWrap(REPEAT);
    tint(0, 240, 0, 127);
    
    beginShape();
      texture(tex);
      vertex(esqInfIzda.x, esqInfIzda.y, 0, 0);
      vertex(esqInfIzda.x + w, esqInfIzda.y, 1, 0);
      vertex(esqInfIzda.x + w, esqInfIzda.y + h, 1, 1);
      vertex(esqInfIzda.x, esqInfIzda.y + h, 0, 1);
      vertex(esqInfIzda.x, esqInfIzda.y, 0, 0);
    endShape();
    
    noTint();
  }
}
