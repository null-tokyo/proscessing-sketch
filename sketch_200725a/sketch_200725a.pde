import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
color moduleColorBackground = color(0);
color moduleColorForeground = color(255);

color moduleAlphaBackground = 100;
color moduleAlphaForeground = 100;

float moduleRadiusBackground = 30;
float moduleRadiusForeground = 15;

color backColor = color(255);

float tileCount = 20;
int actRandomSeed = 0;

void setup(){
  frameRate(30);
  size(800, 800);
}

void draw() {
  /*
  * draw your program!
  */
  translate(width/tileCount/2, height/tileCount/2);

  colorMode(HSB, 360, 100, 100, 100);
  background(255);
  smooth();
  noStroke();

  randomSeed(actRandomSeed);

  for (int gridY = 0; gridY < tileCount; gridY++) {
    for (int gridX = 0; gridX < tileCount; gridX++) {
      float posX = width / tileCount * gridX;
      float posY = height / tileCount * gridY;

      float shiftX = random(-1, 1) * mouseX / 20;
      float shiftY = random(-1, 1) * mouseY / 20;

      fill(moduleColorBackground, moduleAlphaBackground);
      ellipse(posX + shiftX, posY + shiftY, mouseY/15, mouseY/15);
    }
  }

    for (int gridY = 0; gridY < tileCount; gridY++) {
    for (int gridX = 0; gridX < tileCount; gridX++) {
      float posX = width / tileCount * gridX;
      float posY = height / tileCount * gridY;

      fill(moduleColorForeground, moduleAlphaForeground);
      ellipse(posX, posY, moduleRadiusForeground, moduleRadiusForeground);
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
