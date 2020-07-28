
import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

// Global
int tileCount = 20;

color colorLeft = color(197, 0, 123);
color colorRight = color(87, 35, 129);

int alphaLeft = 100;
int alphaRight = 100;

int actRandomSeed = 0;
int actStrokeCap = ROUND;

void setup(){
  frameRate(30);
  size(800, 800);
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100, 100);
  background(360);
  smooth();
  noFill();
  strokeCap(actStrokeCap);

  randomSeed(actRandomSeed);

  for (int gridY = 0; gridY < tileCount; gridY++) {
    for (int gridX = 0; gridX < tileCount; gridX++) {
      int posX = width / tileCount * gridX;
      int posY = height / tileCount * gridY;

      int toggle = (int) random(0, 2);

      if(toggle == 0) {
        stroke(colorLeft, alphaLeft);
        strokeWeight(mouseX/10);
        line(posX, posY, posX+width/tileCount, posY+height/tileCount);
      }
      if(toggle == 1){
        stroke(colorRight, alphaRight);
        strokeWeight(mouseY/10);
        line(posX, posY+height/tileCount, posX+width/tileCount, posY);
      }
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

void mousePressed() {
  actRandomSeed = (int) random(100000);
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
