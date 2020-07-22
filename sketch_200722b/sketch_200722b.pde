import generativedesign.*;

PImage img;
color[] colors;
String sortMode = null;

void setup() {
  size(600, 600);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  noCursor();
  img = loadImage("pic2.jpg");
}

void draw() {
  int tileCount = width / max(mouseY, 5);
  float rectSize = width / float(tileCount);
  
  int i = 0;
  colors = new color[tileCount*tileCount];
  for(int gridY = 0; gridY < tileCount; gridY++) {
    for(int gridX = 0; gridX < tileCount; gridX++) {
      int px = (int) (gridX * rectSize);
      int py = (int) (gridY * rectSize);
      colors[i] = img.get(px, py);
      i++;
    }
  }
  
  if (sortMode != null) colors = GenerativeDesign.sortColors(this, colors, sortMode);
  
  i = 0;
  for(int gridY = 0; gridY < tileCount; gridY++) {
    for(int gridX = 0; gridX < tileCount; gridX++) {
      fill(colors[i]);
      rect(gridX*rectSize, gridY*rectSize, rectSize, rectSize);
      i++;
    }
  }
}

void keyReleased() {
  if(key == '1') sortMode = null;
  if(key == '2') sortMode = GenerativeDesign.HUE;
  if(key == '3') sortMode = GenerativeDesign.SATURATION;
  if(key == '4') sortMode = GenerativeDesign.BRIGHTNESS;
  if(key == '5') sortMode = GenerativeDesign.GRAYSCALE;
}
