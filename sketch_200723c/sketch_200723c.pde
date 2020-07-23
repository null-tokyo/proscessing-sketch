import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

color strokeColor = color(0, 10);

void setup(){
  frameRate(30);
  size(800, 800, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  noFill();
  background(360);
}

void draw() {
  /*
  * draw your program!
  */
  if(mousePressed) {
    pushMatrix();
    
    translate(width/2, height/2);
    int circleResolution = (int) map(mouseY + 100, 0, height, 2, 10);
    float radius = mouseX - width/2 + 0.5;
    float angle = TWO_PI / circleResolution;

    strokeWeight(2);
    stroke(strokeColor);

    beginShape();
    for (int i = 0; i <= circleResolution; ++i) {
      float x = 0 + cos(angle * i + PI / 6) * radius;
      float y = 0 + sin(angle * i + PI / 6) * radius;
      vertex(x, y);
    }
    endShape();

    popMatrix();
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
  if (key == DELETE || key == BACKSPACE) background(360);

  if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  if (key == 'g' || key == 'g') {
    gifExport = new GifMaker(this, timestamp()+".gif");
    gifExport.setRepeat(0);
    gifExport.setQuality(10);
    gifExport.setDelay(1);
    startGifFrame = frameCount;
    saveGif = true;
  }

  switch(key){
  case '1':
    strokeColor = color(0, 10);
    break;
  case '2':
    strokeColor = color(192, 100, 64, 10);
    break;
  case '3':
    strokeColor = color(52, 100, 71, 10);
    break;
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
