import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

// Global Setting
int tileCount = 20;
int actRandomSeed = 0;
int actStrokeCap = ROUND;

void setup(){
  frameRate(30);
  size(600, 600);
}

void draw() {
  /*
  * draw your program!
  */
  background(255);
  randomSeed(actRandomSeed);
  strokeCap(actStrokeCap);

  for (int gridY = 0; gridY < tileCount; gridY++) {
    for (int gridX = 0; gridX < tileCount; gridX++) {
      int posX = width / tileCount * gridX;
      int posY = height / tileCount * gridY;

      int toggle = (int) random(0, 2);

      if(toggle == 0) {
        strokeWeight(mouseX/20);
        line(posX, posY, posX+width/tileCount, posY+height/tileCount);
      }
      if(toggle == 1) {
        strokeWeight(mouseY/20);
        line(posX, posY+height/tileCount, posX+width/tileCount, posY);
      }
    }
  }

  // save ggridYf animation
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
