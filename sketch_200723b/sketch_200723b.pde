import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

void setup(){
  frameRate(30);
  size(550, 550, P3D);
}

void draw() {
  /*
  * draw your program!
  */
  smooth();
  noFill();
  background(255);
  translate(width/2, height/2);

  int circleResolution = (int) map(mouseY, 0, height, 2, 80);
  float radius = mouseX - width/2 + 0.5;
  float angle = TWO_PI/circleResolution;

  strokeWeight(mouseY/20);

  beginShape();
  for (int i = 0; i < circleResolution; ++i) {
    float x = cos(angle * i) * radius;
    float y = sin(angle * i) * radius;
    // line(0, 0, x, y);
    vertex(x, y);
  }
  endShape(CLOSE);

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
  if (key == '0') strokeCap(SQUARE);
  if (key == '1') strokeCap(ROUND);
  if (key == '2') strokeCap(PROJECT);
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
