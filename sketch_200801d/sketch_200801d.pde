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
float[] newx = new float[maxCount];
float[] newy = new float[maxCount];
float[] x = new float[maxCount];
float[] y = new float[maxCount];
float[] r = new float[maxCount];

boolean drawGhost = false;

void setup(){
  size(800, 800);
  smooth();
  //frameRate(10);

  x[0] = width/2;
  y[0] = height/2;
  r[0] = 10;
}

void draw() {
  /*
  * draw your program!
  */
  background(255);

  strokeWeight(0.5);

  float newR = random(1, 7);
  float newX = random(0 + newR, width - newR);
  float newY = random(0 + newR, height - newR);

  float closestDist = 10000000;
  int closestIndex = 0;

  for (int i = 0; i < currentCount; i++) {
    float newDist = dist(newX, newY, x[i], y[i]);
    if(newDist < closestDist) {
      closestDist = newDist;
      closestIndex = i;
    }
  }

  // show random position and line
  // fill(230);
  // ellipse(newX,newY,newR*2,newR*2); 
  // line(newX,newY,x[closestIndex],y[closestIndex]);

  float angle = atan2(newY - y[closestIndex], newX - x[closestIndex]);
  newx[currentCount] = newX;
  newy[currentCount] = newY;
  x[currentCount] = x[closestIndex] + cos(angle) * (r[closestIndex] + newR);
  y[currentCount] = y[closestIndex] + sin(angle) * (r[closestIndex] + newR);
  r[currentCount] = newR;

  currentCount++;
  //draw ghost
  if(drawGhost) {
    for (int i = 1; i < currentCount; ++i) {
      fill(230);
      ellipse(newx[i], newy[i], r[i]*2, r[i]*2);
      line(newx[i], newy[i], x[i], y[i]);
    }
  }

  //draw them
  for (int i = 0; i < currentCount; i++) {
    if (i == 0) noFill();
    else fill(50);
    ellipse(x[i], y[i], r[i]*2, r[i]*2);
  }

  if(currentCount >= maxCount) noLoop();

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
  if(key =='1') drawGhost = !drawGhost;
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
