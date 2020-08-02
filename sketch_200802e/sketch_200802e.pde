import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global

float x = 0;
float y = 0;

float stepSize = 5.0;
float moduleSize = 25;

PShape lineModule;

void setup(){
  size(displayWidth, displayHeight);
  background(255);
  smooth();

  x = mouseX;
  y = mouseY;

  cursor(CROSS);

  lineModule = loadShape("01.svg");
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
      translate(mouseX, mouseY);
      rotate(angle + PI);
      shape(lineModule, 0, 0, d, moduleSize);
      popMatrix();

      x = x + cos(angle) * stepSize;
      y = y + sin(angle) * stepSize;
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
  x = mouseX;
  y = mouseY;
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

    // load svg for line module
  if (key=='1') lineModule = loadShape("01.svg");
  if (key=='2') lineModule = loadShape("02.svg");
  if (key=='3') lineModule = loadShape("03.svg");
  if (key=='4') lineModule = loadShape("04.svg");
  if (key=='5') lineModule = loadShape("05.svg");
  if (key=='6') lineModule = loadShape("06.svg");
  if (key=='7') lineModule = loadShape("07.svg");
  if (key=='8') lineModule = loadShape("08.svg");
  if (key=='9') lineModule = loadShape("09.svg");
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
