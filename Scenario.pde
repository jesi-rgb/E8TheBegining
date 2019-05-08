class Scenario {
  ArrayList<Vec2> surface;
  ArrayList<JeShape> formas;

  Scenario(RPoint[] points) {

    surface = new ArrayList<Vec2>();
    formas = new ArrayList<JeShape>();

    ArrayList<RPoint> aux = new ArrayList();

    int i = 0;
    for (RPoint r : points) {
      if (i % 6 == 0 && i != 0) {
        formas.add(new JeShape(aux));
        aux.clear();
      }
      if (!(i % 6 == 4 || i % 6 == 5)) {
        aux.add(r);
      }
      i++;
    }
  }

  void display() {
    for (JeShape j : formas) {
      j.display();
    }
  }
}
