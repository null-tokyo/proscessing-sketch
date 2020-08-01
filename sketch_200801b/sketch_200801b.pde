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
float initRadius = 150;
float[] x = new float[formResolution];
float[] y = new float[formResolution];
float centerX, centerY;

boolean filled = false;
boolean freeze = false;

int mode = 0;

void setup(){
  frameRate(30);
  size(displayWidth, displayHeight);
  smooth();

  centerX = width/2;
  centerY = height/2;
  float angle = radians(360/float(formResolution));
  for (int i = 0; i < formResolution; i++) {
    x[i] = cos(angle*i) * initRadius;
    y[i] = sin(angle*i) * initRadius;
  }

  stroke(0, 50);
  background(255);
}

void draw() {
  /*
  * draw your program!
  */
  if(mouseX != 0 || mouseY != 0) {
    centerX += (mouseX - centerX) * 0.01;
    centerY += (mouseY - centerY) * 0.01;
  }

  for (int i = 0; i < formResolution; i++) {
    x[i] += random(-stepSize, stepSize);
    y[i] += random(-stepSize, stepSize);
  }

  strokeWeight(0.75);
  if (filled) fill(random(255));
  else noFill();

  if (mode == 0) {
    beginShape();
    curveVertex(x[formResolution - 1] + centerX, y[formResolution - 1] + centerY);

    for (int i = 0; i < formResolution; i++) {
      curveVertex(x[i] + centerX, y[i] + centerY);
    }

    curveVertex(x[0] + centerX, y[0] + centerY);
    curveVertex(x[1] + centerX, y[1] + centerY);
    endShape();
  }

  if (mode == 1) {
    beginShape();
    curveVertex(x[0] + centerX, y[0] + centerY);

    for (int i = 0; i < formResolution; i++) {
      curveVertex(x[i] + centerX, y[i] + centerY);
    }

    curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
    endShape();
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
  // init forms on mouse position
  centerX = mouseX; 
  centerY = mouseY;

  if (mode == 0) {
    float angle = radians(360 / float(formResolution));
    float radius = initRadius * random(0.5, 1.0);
    for (int i = 0; i < formResolution; i++) {
      x[i] = cos(angle * i) * radius;
      y[i] = sin(angle * i) * radius;
    }
  }

  if(mode == 1) {
    float radius = initRadius * random(0.5, 5.0);
    float angle = random(PI);
    radius = initRadius * 4;
    angle = 0;

    float x1 = cos(angle) * radius;
    float x2 = cos(angle - PI) * radius;
    float y1 = sin(angle) * radius;
    float y2 = sin(angle - PI) * radius;

    for (int i = 0; i < formResolution; i++) {
      x[i] = lerp(x1, x2, i / (float)formResolution);
      y[i] = lerp(y1, y2, i / (float)formResolution);
    }
  }
}

void keyReleased() {  
  if (key == DELETE || key == BACKSPACE) background(255);
  if (key == '1') filled = false;
  if (key == '2') filled = true;
  if (key == '3') mode = 0;
  if (key == '4') mode = 1;
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  if (key == 'g' || key == 'g') {
    gifExport = new GifMaker(this, timestamp()+".gif");
    gifExport.setRepeat(0);
    gifExport.setQuality(10);
    gifExport.setDelay(1);
    startGifFrame = frameCount;
    saveGif = true;
  }

    // switch draw loop on/off
  if (key == 'f' || key == 'F') freeze = !freeze;
  if (freeze == true) noLoop();
  else loop();
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
