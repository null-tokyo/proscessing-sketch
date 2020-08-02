import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
PFont font;
PShape[] modules;
float tileSize = 30;
int gridResolutionX, girdResolutionY;
char[][] tiles;

boolean drawGrid = true;
boolean debugMode = false;

void setup(){
  size(displayWidth, displayHeight);
  background(255);
  smooth();
  cursor(CROSS);
  
  font = createFont("sans-serif",8);
  textFont(font,8);

  gridResolutionX = round(width / tileSize) + 2;
  girdResolutionY = round(height / tileSize) + 2;
  tiles = new char[gridResolutionX][girdResolutionY];

  initTiles();

  modules = new PShape[16]; 
  for (int i=0; i< modules.length; i++) { 
    modules[i] = loadShape(nf(i,2)+".svg");
  }
}

void initTiles() {
  for (int gridY = 0; gridY < girdResolutionY; gridY++) {
    for (int gridX = 0; gridX < gridResolutionX; gridX++) {
      tiles[gridX][gridY] = '0';
    }
  }
}

void draw() {
  /*
  * draw your program!
  */

  background(255);

  if (mousePressed && (mouseButton == LEFT)) setTile();
  if (mousePressed && (mouseButton == RIGHT)) unsetTile();

  if (drawGrid) drawGrid();
  drawModule();
  // save gif animation
  if(saveGif) {
    if(frameCount < frameRate * gifSecond + startGifFrame) {
      gifExport.addFrame(); // フレームを追加
    } else {
      gifExport.finish(); // 終了してファイル保存
      saveGif = false;
    }
  }
}

void setTile() {
  int gridX = floor((float) mouseX / tileSize) + 1;
  gridX = constrain(gridX, 1, gridResolutionX - 2);
  int gridY = floor((float) mouseY / tileSize) + 1;
  gridY = constrain(gridY, 1, gridResolutionX - 2);
  tiles[gridX][gridY] = '1';
}

void unsetTile() {
  int gridX = floor((float) mouseX / tileSize) + 1;
  gridX = constrain(gridX, 1, gridResolutionX - 2);
  int gridY = floor((float) mouseY / tileSize) + 1;
  gridY = constrain(gridY, 1, gridResolutionX - 2);
  tiles[gridX][gridY] = '0';
}

void drawGrid() {
  rectMode(CENTER);
  for (int gridY = 0; gridY < girdResolutionY; gridY++) {
    for (int gridX = 0; gridX < gridResolutionX; gridX++) {
      float posX = tileSize * gridX - tileSize / 2;
      float posY = tileSize * gridY - tileSize / 2;

      strokeWeight(0.15);
      fill(255);
      if (debugMode) {
        if (tiles[gridX][gridY] == '1') fill(220);
      }
      rect(posX, posY, tileSize, tileSize);
    }
  }
}

void drawModule() {
  shapeMode(CENTER);
  for (int gridY = 0; gridY < girdResolutionY; gridY++) {
    for (int gridX = 0; gridX < gridResolutionX; gridX++) {
      if(tiles[gridX][gridY] == '1') {
        String east = str(tiles[gridX + 1][gridY]);
        String south = str(tiles[gridX][gridY + 1]);
        String west = str(tiles[gridX - 1][gridY]);
        String north = str(tiles[gridX][gridY - 1]);

        String binaryResult = north + west + south + east;

        int decimalResult = unbinary(binaryResult);

        float posX = tileSize * gridX - tileSize / 2;
        float posY = tileSize * gridY - tileSize / 2;

        shape(modules[decimalResult], posX,  posY, tileSize, tileSize);

        if (debugMode) {
          fill(150);
          text(decimalResult+"\n"+binaryResult,posX, posY);
        }
      }
    }
  }
}

void keyReleased() {
  if (key == DELETE || key == BACKSPACE) background(255);
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  // if (key == 'g' || key == 'g') {
  //   gifExport = new GifMaker(this, timestamp()+".gif");
  //   gifExport.setRepeat(0);
  //   gifExport.setQuality(10);
  //   gifExport.setDelay(1);
  //   startGifFrame = frameCount;
  //   saveGif = true;
  // }

  if (key == 'g' || key == 'G') drawGrid = !drawGrid;
  if (key == 'd' || key == 'D') debugMode = !debugMode;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
