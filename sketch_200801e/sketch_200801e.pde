import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
int maxCount = 5000;
int currentCount = 1;
float[] x = new float[maxCount];
float[] y = new float[maxCount];
float[] r = new float[maxCount];
int[] closestIndex = new int[maxCount];

float minRadius = 3;
float maxRadius = 50;

float mouseRect = 30;

void setup(){
  frameRate(30);
  size(800, 800);
  noFill();
  smooth();
  cursor(CROSS);

  x[0] = 200;
  y[0] = 100;
  r[0] = 50;
  closestIndex[0] = 0;
}

void draw() {
  /*
  * draw your program!
  */
  background(255);

  float newX = random(0 + maxRadius, width - maxRadius);
  float newY = random(0 + maxRadius, height - maxRadius);
  float newR = minRadius;

  if (mousePressed == true){
    newX = random(mouseX - mouseRect / 2, mouseX + mouseRect /2);
    newY = random(mouseY - mouseRect / 2, mouseY + mouseRect /2);
  }

  boolean intersection = false;

  for (int i = 0; i < currentCount; i++) {
    float d = dist(newX, newY, x[i], y[i]);
    if(d < (newR + r[i])) {
      intersection = true;
      break;
    }
  }

  if(intersection == false) {
    float newRadius = width;
    for(int i = 0; i < currentCount; i++) {
      float d = dist(newX, newY, x[i], y[i]);
      if(newRadius > d - r[i]) {
        newRadius = d - r[i];
        closestIndex[currentCount] = i;
      }
    }
    if(newRadius > maxRadius) newRadius = maxRadius;

    x[currentCount] = newX;
    y[currentCount] = newY;
    r[currentCount] = newRadius;
    currentCount++;
  }


  for (int i = 0; i < currentCount; ++i) {
    stroke(0);
    strokeWeight(1.5);
    ellipse(x[i], y[i], r[i] * 2, r[i] * 2);
    stroke(226, 185, 0);
    strokeWeight(0.75);
    int n = closestIndex[i];
    line(x[i],y[i], x[n],y[n]); 
  }

  if (mousePressed == true) {
    stroke(255,200,0);
    strokeWeight(2);
    rect(mouseX-mouseRect/2,mouseY-mouseRect/2,mouseRect,mouseRect);
  }
  
  if (currentCount >= maxCount) noLoop();

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
