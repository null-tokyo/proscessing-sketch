import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
int formResolution = 15;
int stepSize = 2;
float distortionFactor = 1;
float intRadius = 50;
float stepRadius = 0;

float centerX, centerY;
float beforeMouseX, beforeMouseY, beforeMouseDist;
float[] x = new float[formResolution];
float[] y = new float[formResolution];
float[] sx = new float[formResolution];
float[] sy = new float[formResolution];

boolean filled = false;
boolean freeze = false;

float speed = 0.01;
float angle = radians(360 / float(formResolution));

void setup(){
  frameRate(30);
  size(displayWidth, displayHeight);
  smooth();

  //init form
  centerX = width/2;
  centerY = height/2;
  beforeMouseX = centerX;
  beforeMouseY = centerY;
  beforeMouseDist = 0;

  for (int i = 0; i < formResolution; i++) {
    x[i] = cos(angle * i) * intRadius;
    y[i] = sin(angle * i) * intRadius;
  }

  stroke(0, 50);
  background(255);
}

void draw() {
  /*
  * draw your program!
  */

  // flaoting towards mouse position
  if( mouseX != 0 || mouseY != 0 ) {
    centerX += (mouseX - centerX) * speed;
    centerY += (mouseY - centerY) * speed;
  }

  float mouseDist = abs(dist(centerX, centerY, mouseX, mouseY));
  stepRadius += (mouseDist - beforeMouseDist) * speed;

  beforeMouseDist = mouseDist;

  // calculate new points
  for (int i = 0; i < formResolution; i++) {
    x[i] = cos(angle * i) * (intRadius + stepRadius * 10);
    y[i] = sin(angle * i) * (intRadius + stepRadius * 10);

    sx[i] += random(-stepSize, stepSize);
    sy[i] += random(-stepSize, stepSize); 
  }

  // set form face
  strokeWeight(0.75);
  if (filled) fill(random(255));
  else noFill();

  //draw form
  beginShape();

  //start
  curveVertex(
    x[formResolution-1] + sx[formResolution-1] + centerX,
    y[formResolution-1] + sy[formResolution-1] + centerY
  );

  for (int i = 0; i < formResolution; i++) {
    curveVertex(
      x[i] + sx[i] + centerX,
      y[i] + sy[i] + centerY
    );
  }
  curveVertex(
    x[0] + sx[0] + centerX,
    y[0] + sy[0] + centerY
  );

  //endpoint
  curveVertex(
    x[1] + sx[1] + centerX,
    y[1] + sy[1] + centerY
  );
  endShape();
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

  if (key == '1') filled = false;
  if (key == '2') filled = true;

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
