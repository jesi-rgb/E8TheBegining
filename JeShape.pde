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

    stroke(1);
    textureMode(NORMAL);
    textureWrap(REPEAT);
    fill(70);
    beginShape();
      PVector auxP;
      for(int i=0;i<vertices.length;i++){
        auxP = box2d.coordWorldToPixelsPVector(vertices[i]);
        vertex(auxP.x, auxP.y);
      }
    endShape();
    
    noTint();
  }
}
