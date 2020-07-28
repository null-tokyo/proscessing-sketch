import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
color colorBack = color(255);
color colorLeft = color(0);
color colorRight = color(0);

float tileCount = 1;
boolean transparentLeft = false;
boolean transparentRight = false;
float alphaLeft = 100;
float alphaRight = 100;

int actRandomSeed = 0;

void setup(){
  frameRate(30);
  size(800, 800);
  colorMode(HSB, 360, 100, 100, 100);

  colorLeft = color(323, 100, 77);
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100, 100);
  background(colorBack);
  smooth();
  noFill();
  randomSeed(actRandomSeed);
  strokeWeight(mouseX / 15);

  tileCount = mouseY / 15;

  for (int gridY = 0; gridY < tileCount; gridY++) {
    for (int gridX = 0; gridX < tileCount; gridX++) {
      float posX = width / tileCount * gridX;
      float posY = height / tileCount * gridY;

      if (transparentLeft == true) alphaLeft = gridY*10; 
      else alphaLeft = 100;

      if (transparentRight == true) alphaRight = 100-gridY*10; 
      else alphaRight = 100;

      int toggle = (int) random(0, 2);

      if(toggle == 0) {
        stroke(colorLeft, alphaLeft);
        line(posX, posY, posX + (width / tileCount) / 2, posY + (height / tileCount));
        line(posX+(width/tileCount)/2, posY, posX+(width/tileCount), posY+height/tileCount);
      }
      if(toggle == 1) {
        stroke(colorRight, alphaRight);
        line(posX, posY + (height / tileCount), posX + (width / tileCount) / 2, posY);
        line(posX+(height/tileCount)/2, posY+width/tileCount, posX+(height/tileCount), posY);
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

  if (key == '1'){
    if (colorLeft == color(273, 73, 51)) {
      colorLeft = color(323, 100, 77);
    } 
    else {
      colorLeft = color(273, 73, 51);
      //      colorLeft = color(0);
    } 
  }
  if (key == '2'){
    if (colorRight == color(0)) {
      colorRight = color(192, 100, 64);
    } 
    else {
      colorRight = color(0);
    } 
  }
  if (key == '3'){
    transparentLeft =! transparentLeft;
  }
  if (key == '4'){
    transparentRight =! transparentRight;
  }

  if (key == '0'){
    transparentLeft = false;
    transparentRight = false;
      colorLeft = color(323, 100, 77);
      colorRight = color(0);
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
