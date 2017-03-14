import org.gicentre.geomap.*;
import org.gicentre.geomap.io.*;

GeoMap geoMap;

void setup() {
  size(1080,720);
  
  geoMap = new GeoMap(this);
  geoMap.readFile("Wards");
}

void draw() {
  fill(255,255,255);
  stroke(0,0,0);
  background(100,100,100);
  geoMap.draw();
  int id = geoMap.getID(mouseX, mouseY);
  if (id != -1) {
    fill(0,255,0);
    geoMap.draw(id);
  }
}