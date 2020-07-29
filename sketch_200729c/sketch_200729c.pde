import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
float tileCountX = 6;
float tileCountY = 6;
int count = 0;
int actRandomSeed = 0;

int drawMode = 1;

void setup(){
  frameRate(30);
  size(800, 800);
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER);
  smooth();
  stroke(0);
  noFill();
  background(360);
  randomSeed(actRandomSeed);

  count = mouseX / 10 + 10;
  float para = (float) mouseY / height;

  for (int gridY = 0; gridY <= tileCountY; gridY++) {
    for (int gridX = 0; gridX <= tileCountX; gridX++) {
      float tileWidth = width / tileCountX;
      float tileHeight = height / tileCountY;

      float posX = tileWidth * gridX + tileWidth / 2;
      float posY = tileHeight * gridY + tileHeight / 2;

      pushMatrix();
      translate(posX, posY);
      switch (int(random(4)) {
        case 1:
          for (int i = 0; i < count; i++) {
            rect(0, 0, tileWidth, tileHeight);
            scale(1 - 3.0 / count);
            rotate(para * 0.1);
          }
          break;
        case 2:
          for (float i = 0; i < count; i++) {
            noStroke();
            color gradient = lerpColor(color(0), color(52, 100, 71), i/count);
            fill(gradient, i / count * 200);
            rotate(PI / 4);
            rect(0, 0, tileWidth, tileHeight);
            scale(1 - 3.0 / count);
            rotate(para * 1.5);
          }
          break;
        case 3:
          colorMode(RGB, 255);
          for (float i = 0; i < count; i++) {
            noStroke();
            color gradient = lerpColor(color(0, 130, 164), color(255), i/count);
            fill(gradient,170);

            pushMatrix();
            translate(4*i, 0);
            ellipse(0, 0, tileWidth/4, tileHeight/4);
            popMatrix();

            pushMatrix();
            translate(-4*i, 0);
            ellipse(0, 0, tileWidth/4, tileHeight/4);
            popMatrix();

            scale(1 - 1.5/count);
            rotate(para*1.5);
          }
          break;
        case 4:
          colorMode(RGB, 255);
          for (float i = 0; i < count; i++) {
            noFill();
            color gradient = lerpColor(color(0, 130, 164), color(255), i/count);
            stroke(gradient,170);

            pushMatrix();
            translate(tileWidth/4, tileWidth/4);
            line(0, 0, tileWidth/4, tileHeight/4);
            popMatrix();

            scale(1 - 1.5/count);
            rotate(para*1.5);
          }
          break;
      }
      popMatrix();
    }
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
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  if (key == 'g' || key == 'g') {
    gifExport = new GifMaker(this, timestamp()+".gif");
    gifExport.setRepeat(0);
    gifExport.setQuality(10);
    gifExport.setDelay(1);
    startGifFrame = frameCount;
    saveGif = true;
  }
  if(key == '1') drawMode = 1;
  if(key == '2') drawMode = 2;
  if(key == '3') drawMode = 3;
  if(key == '4') drawMode = 4;

  if(keyCode == DOWN) tileCountY = max(tileCountY - 1, 1);
  if(keyCode == UP) tileCountY += 1;
  if(keyCode == LEFT) tileCountX = max(tileCountX - 1, 1);
  if(keyCode == RIGHT) tileCountX += 1;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
