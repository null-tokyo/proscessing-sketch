import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
int tileCount = 20;
int rectSize = 30;

int actRandomSeed = 0;

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
  noStroke();

  fill(192, 100, 64, 60);

  randomSeed(actRandomSeed);

  for (int gridY = 0; gridY < tileCount; gridY++) {
    for (int gridX = 0; gridX < tileCount; gridX++) {
      int posX = width / tileCount * gridX;
      int posY = height / tileCount * gridY;

      float shiftX1 = mouseX / 20 * random(-1, 1);
      float shiftY1 = mouseX / 20 * random(-1, 1);
      float shiftX2 = mouseX/20 * random(-1, 1);
      float shiftY2 = mouseY/20 * random(-1, 1);
      float shiftX3 = mouseX/20 * random(-1, 1);
      float shiftY3 = mouseY/20 * random(-1, 1);
      float shiftX4 = mouseX/20 * random(-1, 1);
      float shiftY4 = mouseY/20 * random(-1, 1);

      beginShape();
      vertex(posX + shiftX1, posY + shiftY1);
      vertex(posX + rectSize + shiftX2, posY + shiftY2);
      vertex(posX + rectSize + shiftX3, posY + rectSize + shiftY3);
      vertex(posX + shiftX4, posY + rectSize + shiftY4);
      endShape(CLOSE);
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

void mouseReleased() {
  actRandomSeed = (int) random(1, 10000);
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
