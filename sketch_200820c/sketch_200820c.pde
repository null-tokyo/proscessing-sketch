import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

void setup(){
  size(1024, 256);
  smooth();
}

void draw() {
  /*
  * draw your program!
  */
  background(255);

  stroke(0, 130, 164);
  strokeWeight(1);
  strokeJoin(ROUND);
  noFill();

  int noiseXRange = mouseX / 10;
  println("noiseXRange: 0 - " + noiseXRange);

  beginShape();
  for (int x = 0; x < width; x+=10) {
    float noiseX = map(x, 0, width, 0, noiseXRange);
    float y = noise(noiseX) * height;
    vertex(x, y);
  }
  endShape();

  noStroke();
  fill(0);

  for (int x = 0; x < width; x+=10) {
    float noiseX = map(x, 0, width, 0, noiseXRange);
    float y = noise(noiseX) * height;
    ellipse(x, y, 3, 3);
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
  noiseSeed((int) random(100000));
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
