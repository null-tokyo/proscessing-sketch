import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
int drawMode = 1;

color col = color(random(255), random(255), random(255), random(100));
float x = 0, y = 0;
// float newX = 0; newY = 0;
float stepSize = 5.0;
float lineLength = 25;

void setup(){
  size(displayWidth, displayHeight);
  background(255);
  smooth();
  x = mouseX;
  y = mouseY;
  cursor(CROSS);
}

void draw() {
  /*
  * draw your program!
  */
  if(mousePressed) {
    float d = dist(x, y, mouseX, mouseY);

    if(d > stepSize) {
      float angle = atan2(mouseY - y, mouseX - x);

      pushMatrix();
      translate(x, y);
      rotate(angle);
      stroke(col);
      if(frameCount % 2 == 0) stroke(150);
      line(0, 0, 0, lineLength * random(0.95, 1.0) * d / 10);

        if (drawMode == 1) {
          x = x + cos(angle) * stepSize;
          y = y + sin(angle) * stepSize; 
        } 
        else {
          x  = mouseX;
          y  = mouseY; 
        }

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
  if (key == DELETE || key == BACKSPACE) background(255);
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  if (key == 'g' || key == 'g') {
    gifExport = new GifMaker(this, timestamp()+".gif");
    gifExport.setRepeat(0);
    gifExport.setQuality(10);
    gifExport.setDelay(1);
    startGifFrame = frameCount;
    saveGif = true;
  }

  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
