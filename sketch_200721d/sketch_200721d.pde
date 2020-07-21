int tileCountX = 2;
int tileCountY = 10;

color[] colorsLeft = new color[tileCountY];
color[] colorsRight = new color[tileCountY];
color[] colors;

boolean interpolateShortest = true;

void setup() { 
  size(800, 800);
  colorMode(HSB,360,100,100,100); 
  noStroke();
} 

void draw() {
  tileCountX = (int) map(mouseX, 0, width, 2, 100);
  tileCountY = (int) map(mouseY, 0, height, 2, 10);
  
  float tileWidth = width / (float)tileCountX;
  float tileHeight = height / (float)tileCountY;
  color interCol;
  
  colors = new color[tileCountX*tileCountY];
  int i = 0;
  
  for(int gridY = 0; gridY < tileCountY; gridY++) {
    color col1 = colorsLeft[gridY];
    color col2 = colorsRight[gridY];
    for(int gridX = 0; gridX < tileCountX; gridX++) {
      float amount = map(gridX, 0, tileCountX - 1, 0, 1);
      
      if (interpolateShortest) {
        colorMode(RGB,255,255,255,255);
        interCol = lerpColor(col1,col2, amount); 
        colorMode(HSB,360,100,100,100);
      }else{
        interCol = lerpColor(col1, col2, amount);
      }
      
      fill(interCol);
      
      float posX = tileWidth*gridX;
      float posY = tileHeight*gridY;      
      rect(posX, posY, tileWidth, tileHeight); 
      
      colors[i] = interCol;
      i++;
    }
  }
}

void shakeColors() {
  for (int i=0; i<tileCountY; i++) {
    colorsLeft[i] = color(random(0,60), random(0,100), 100);
    colorsRight[i] = color(random(160,190), 100, random(0,100));
  }
}

void mouseReleased() {
  shakeColors();
}

void keyReleased() {
  if(key == '1') interpolateShortest = true;
  if(key == '2') interpolateShortest = false;
}
