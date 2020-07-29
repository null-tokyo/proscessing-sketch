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

int drawMode = 1;

void setup(){
  frameRate(30);
  size(600, 600);
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

  count = mouseX / 20 + 5;

  println(count);
  float para = (float) mouseY / height - 0.5;

  for (int gridY = 0; gridY < tileCountY; gridY++) {
    for (int gridX = 0; gridX < tileCountX; gridX++) {

      float tileWidth = width / tileCountX;
      float tileHeight = height / tileCountY;
      float posX = tileWidth * gridX + tileWidth * 0.5;
      float posY = tileHeight * gridY + tileHeight * 0.5;

      pushMatrix();
      translate(posX, posY);

      switch (drawMode) {
        case 1:
          translate(-tileWidth/2, -tileHeight/2);
          for(int i = 0; i <= count; i++) {
            line(0, (para + 0.5) * tileHeight, tileWidth, i * tileHeight / count);
            line(0, i * tileHeight / count, tileWidth, tileHeight - (para + 0.5) * tileHeight);
          }
          break;
        case 2:
          for(float i=0; i<=count; i++) {
            line(para*tileWidth, para*tileHeight, tileWidth/2, (i/count-0.5)*tileHeight);
            line(para*tileWidth, para*tileHeight, -tileWidth/2, (i/count-0.5)*tileHeight);
            line(para*tileWidth, para*tileHeight, (i/count-0.5)*tileWidth, tileHeight/2);
            line(para*tileWidth, para*tileHeight, (i/count-0.5)*tileWidth, -tileHeight/2);
          }
          break;
        case 3:
          for(float i=0; i<=count; i++) {
          line(0, para*tileHeight, tileWidth/2, (i/count-0.5)*tileHeight);
          line(0, para*tileHeight, -tileWidth/2, (i/count-0.5)*tileHeight);
          line(0, para*tileHeight, (i/count-0.5)*tileWidth, tileHeight/2);
          line(0, para*tileHeight, (i/count-0.5)*tileWidth, -tileHeight/2);
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
  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == '3') drawMode = 3;

  if (keyCode == DOWN) tileCountY = max(tileCountY-1, 1);
  if (keyCode == UP) tileCountY += 1;
  if (keyCode == LEFT) tileCountX = max(tileCountX-1, 1);
  if (keyCode == RIGHT) tileCountX += 1;

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
