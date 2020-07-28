import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
PShape currentShape;

int tileCount = 20;
float tileWidth, tileHeight;
float shapeSize = 30;
float newShapeSize = shapeSize;
float shapeAngle = 0;
float maxDist;

color shapeColor = color(0, 130, 164);
int fillMode = 0;
int sizeMode = 0;

void setup(){
  frameRate(30);
  size(800, 800);
  background(255);
  smooth();

  tileWidth = width / float(tileCount);
  tileHeight = height / float(tileCount);

  //get distance
  maxDist = sqrt(sq(width)+sq(height));

  currentShape = loadShape("module_4.svg");
}

void draw() {
  /*
  * draw your program!
  */
  background(255);
  smooth();

  for (int gridY = 0; gridY < tileCount; gridY++) {
    for (int gridX = 0; gridX < tileCount; gridX++) {
      float posX = tileWidth * gridX + tileWidth / 2;
      float posY = tileHeight * gridY + tileHeight / 2;

      newShapeSize = map(dist(mouseX,mouseY,posX,posY),0,500,5,shapeSize);;

      // calculate angle between mouse position and actual position of the shape
      float angle = atan2(mouseY-posY, mouseX-posX) + radians(mouseX * 360 / width);
      float a = 255 - map(dist(mouseX,mouseY,posX,posY), 0,maxDist, 255,0);
      currentShape.disableStyle();
      fill(shapeColor, a);

      pushMatrix();
      translate(posX, posY);
      rotate (angle);
      shapeMode(CENTER);

      noStroke();
      shape(currentShape, 0, 0, newShapeSize, newShapeSize);
      popMatrix();
    }
  }

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

void keyReleased() {  
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  if (key == 'g' || key == 'g') {
    gifExport = new GifMaker(this, timestamp()+".gif");
    gifExport.setRepeat(0);
    gifExport.setQuality(10);
    gifExport.setDelay(1);
    startGifFrame = frameCount;
    saveGif = true;
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
