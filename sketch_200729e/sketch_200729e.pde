import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
int NORTH = 0;
int NORTHEAST = 1;
int EAST = 2;
int SOUTHEAST = 3;
int SOUTH = 4;
int SOUTHWEST = 5;
int WEST = 6;
int NORTHWEST = 7;

float stepSize = 1;
float diameter = 1;

float drawMode = 1;
int counter = 0;

int direction;
float posX, posY;

void setup(){
  frameRate(30);
  size(800, 800);
  colorMode(HSB, 360, 100, 100, 100);
  background(360);
  smooth();
  noStroke();
  posX = width / 2;
  posY = height / 2;
}

void draw() {
  /*
  * draw your program!
  */
  for (int i=0; i<=mouseX; i++) {
    counter++;

    if(drawMode == 2) {
      direction = (int) random(0, 3);
    } else {
      direction = (int) random(0, 8);
    }

    if(direction == NORTH) {
      posY -= stepSize;
    }else if(direction == NORTHEAST) {
      posX += stepSize;
      posY -= stepSize;
    }else if(direction == EAST) {
      posX += stepSize;
    }else if(direction == SOUTHEAST) {
      posX += stepSize;
      posY += stepSize;
    }else if(direction == SOUTH) {
      posY += stepSize;
    }else if(direction == SOUTHWEST) {
      posX -= stepSize;
      posY += stepSize;
    }else if(direction == WEST) {
      posX -= stepSize;
    }else if(direction == NORTHWEST) {
      posX -= stepSize;
      posY -= stepSize;
    }

    if (posX > width) posX = 0;
    if (posX < 0) posX = width;
    if (posY > height) posY = 0;
    if (posY < 0) posY = height;

    if (drawMode == 3) {
      if (counter >= 100){
        counter = 0;
        fill(192, 100, 64, 80);
        ellipse(posX+stepSize/2, posY+stepSize/2, diameter+7, diameter+7);
      } 
    }

    fill(0, 40);
    ellipse(posX + stepSize /2, posY + stepSize /2, diameter, diameter);
  }
  // fill(255, 5);
  // rect(0, 0, width, height);
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
  if (key == '1') {
    drawMode = 1;
    stepSize = 1;
    diameter = 1;
  }
  if (key == '2') {
    drawMode = 2;
    stepSize = 1;
    diameter = 1;
  }
  if (key == '3') {
    drawMode = 3;
    stepSize = 10;
    diameter = 5;
  }
  if (key == DELETE || key == BACKSPACE) background(360);
  if (keyCode == UP) stepSize += 1;
  if (keyCode == DOWN) stepSize = max(stepSize - 1, 1);
  if (keyCode == LEFT) diameter += 1;
  if (keyCode == RIGHT) diameter = max(diameter - 1, 1);
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
