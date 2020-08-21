import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
int actRandomSeed = 0;
int count = 150;

void setup(){
  size(800, 800);
  cursor(CROSS);
  smooth();
}

void draw() {
  /*
  * draw your program!
  */
  background(255);
  noStroke();

  float faderX = (float) mouseX / width;
  randomSeed(actRandomSeed);

  float angle = radians(360 / float(count));

  for (int i = 0; i < count; i++) {
    float randomX = random(0, width);
    float randomY = random(0, height);

    float circleX = width / 2 + cos(angle * i) * 300;
    float circleY = height / 2 + sin(angle * i) * 300;

    float x = lerp(randomX, circleX, faderX);
    float y = lerp(randomY, circleY, faderX);

    fill(0, 130, 164);
    ellipse(x, y, 11, 11);
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
