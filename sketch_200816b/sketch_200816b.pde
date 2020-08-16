import processing.video.*;
import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
Capture video;

int x, y;
int curvePointX = 0;
int curvePointY = 0;
int pointCount = 1;
float diffusion = 50;

void setup(){
  String[] cameras = Capture.list();
  size(640, 480);
  background(255);
  x = width / 2;
  y = height / 2;
  video = new Capture(this, width, height, cameras[0]);
  video.start();
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100);
  smooth();
  noFill();

  for (int j = 0; j <= mouseX / 50; j++) {
    if(video.available()) video.read();
    video.loadPixels();

    int pixelIndex = ((video.width - 1 - x) + y * video.width);
    color c = video.pixels[pixelIndex];

    strokeWeight(hue(c)/ 50);
    stroke(c);

    diffusion = map(mouseY, 0, height, 5, 100);

    beginShape();
    curveVertex(x, y);
    curveVertex(x, y);
    for (int i = 0; i < pointCount; i++) {
      int rx = (int) random(-diffusion, diffusion);
      curvePointX = constrain(x + rx, 0, width - 1);
      int ry = (int) random(-diffusion, diffusion);
      curvePointY = constrain(y + ry, 0, height - 1);
      curveVertex(curvePointX, curvePointY);
    }
    curveVertex(curvePointX, curvePointY);
    endShape();

    x = curvePointX;
    y = curvePointY;
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
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
