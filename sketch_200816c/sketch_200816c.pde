import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;
import processing.video.*;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
Capture video;

int pixelIndex;
color c;

float x1, x2, x3, y1, y2, y3;
float curvePointX = 0;
float curvePointY = 0;

int counter;
int maxCounter = 100000;

void setup(){
  String[] cameras = Capture.list();
  size(640, 480);
  video = new Capture(this, width, height, cameras[0]);
  video.start();
  background(255);
  x1 = 0;
  y1 = height / 2;
  x2 = width / 2;
  y2 = 0;
  x3 = width;
  y3 = height / 2;
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100);
  smooth();
  noFill();

  if (video.available()) video.read();
  video.loadPixels();

  pixelIndex = (int) ((video.width - 1 - int(x1)) + int(y1) * video.width);
  c = video.pixels[pixelIndex];
  float hueValue = hue(c);
  strokeWeight(hueValue / 50);
  stroke(c);

  beginShape();
  curveVertex(x1, y1);
  curveVertex(x1, y1);
  for (int i = 0; i < 7; i++) {
    curvePointX = constrain(x1 + random(-50, 50), 0, width - 1);
    curvePointY = constrain(y1 + random(-50, 50), 0, width - 1);
    curveVertex(curvePointX, curvePointY);
  }
  curveVertex(curvePointX, curvePointY);
  endShape();
  x1 = curvePointX;
  y1 = curvePointY;


  pixelIndex = (int) ((video.width - 1 - int(x2)) + int(y2) * video.width);
  c = video.pixels[pixelIndex];
  float saturationValue = saturation(c);
  strokeWeight(saturationValue / 2);
  stroke(c);

  beginShape();
  curveVertex(x2, y2);
  curveVertex(x2, y2);
  for (int i = 0; i < 7; i++) {
    curvePointX = constrain(x2 + random(-50, 50), 0, width - 1);
    curvePointY = constrain(y2 + random(-50, 50), 0, width - 1);
    curveVertex(curvePointX, curvePointY);
  }
  curveVertex(curvePointX, curvePointY);
  endShape();
  x2 = curvePointX;
  y2 = curvePointY;

    pixelIndex = (int) ((video.width - 1 - int(x3)) + int(y3) * video.width);
  c = video.pixels[pixelIndex];
  float brightnessValue = brightness(c);
  strokeWeight(brightnessValue / 100);
  stroke(c);

  beginShape();
  curveVertex(x3, y3);
  curveVertex(x3, y3);
  for (int i = 0; i < 7; i++) {
    curvePointX = constrain(x3 + random(-50, 50), 0, width - 1);
    curvePointY = constrain(y3 + random(-50, 50), 0, width - 1);
    curveVertex(curvePointX, curvePointY);
  }
  curveVertex(curvePointX, curvePointY);
  endShape();
  x3 = curvePointX;
  y3 = curvePointY;

  counter++;
  if (counter >= maxCounter) noLoop();

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
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
