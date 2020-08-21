import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
int actRandomSeed = 42;

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

  randomSeed(actRandomSeed);
  beginShape();
  for (int x = 0; x < width; x+=10) {
    float y = random(0, height);
    vertex(x, y);
  }
  endShape();

  noStroke();
  fill(0);

  randomSeed(actRandomSeed);
  for (int x = 0; x < width; x+=10) {
    float y = random(0, height);
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

void mousePressed() {
  actRandomSeed = (int) random(100000);
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
