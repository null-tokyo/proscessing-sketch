import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
PImage img;
int drawMode = 1;

void setup(){
  size(603, 873);
  smooth();
  img = loadImage("pic.png");
  println(img.width + " x " + img.height);
}

void draw() {
  /*
  * draw your program!
  */
  background(255);

  float mouseXFactor = map(mouseX, 0, width, 0.05, 1);
  float mouseYFactor = map(mouseY, 0, height, 0.05, 1);

  for (int gridX = 0; gridX < img.width; gridX++) {
    for (int gridY = 0; gridY < img.height; gridY++) {
      float tileWidth = width / (float)img.width;
      float tileHeight = height / (float)img.height;
      float posX = tileWidth * gridX;
      float posY = tileHeight * gridY;

      color c = img.pixels[gridY*img.width+gridX];
      int greyscale = round(
        red(c) * 0.222 +
        green(c) * 0.707 +
        blue(c) * 0.071
      );

      switch(drawMode) {
        case 1:
          float w1 = map(greyscale, 0, 255, 15, 0.1);
          stroke(0);
          strokeWeight(w1 * mouseXFactor);
          line(posX, posY, posX+5, posY+5);
          break;
        case 2:
          fill(0);
          noStroke();
          float r2 = 1.1284 * sqrt(tileWidth*tileWidth*(1 - greyscale / 255.0));
          r2 = r2 * mouseXFactor * 3;
          ellipse(posX, posY, r2, r2);
          break;
        case 3:
          float l3 = map(greyscale, 0, 255, 30, 0.1);
          l3 = l3 * mouseXFactor;
          stroke(0);
          strokeWeight(10 * mouseYFactor);
          line(posX, posY, posX + l3, posY + l3);
          break;
        case 4:
          stroke(0);
          float w4 = map(greyscale, 0, 255, 10, 0);
          strokeWeight(w4 * mouseXFactor + 0.1);
          float l4 = map(greyscale, 0, 255, 35, 0);
          l4 = mouseYFactor;
          pushMatrix();
          translate(posX, posY);
          rotate(greyscale / 255.0 * PI);
          line(0, 0, 0 + l4, 0 + l4);
          popMatrix();
          break;
        case 5:
          float w5 = map(greyscale, 0, 255, 5, 0.2);
          strokeWeight(w5 * mouseYFactor + 0.1);
          color c2 = img.get(min(gridX+1,img.width-1), gridY);
          stroke(c2);
          int greyscale2 = int(
            red(c) * 0.222 +
            green(c) * 0.707 +
            blue(c) * 0.071
          );
          float h5 = 50 * mouseXFactor;
          float d1 = map(greyscale, 0, 255, h5, 0);
          float d2 = map(greyscale2, 0, 255, h5, 0);

          line(posX - d1, posY + d1, posX + tileWidth - d2, posY + d2);
          break;
        case 6:
          float w6 = map(greyscale, 0, 255, 25, 0);
          noStroke();
          fill(c);
          ellipse(posX, posY, w6 * mouseXFactor, w6 * mouseXFactor);
          break;
        case 7:
          stroke(c);
          float w7 = map(greyscale, 0, 255, 5, 0.1);
          strokeWeight(w7);
          fill(255, 255 * mouseXFactor);
          pushMatrix();
          translate(posX, posY);
          rotate(greyscale / 255.0 * PI * mouseYFactor);
          rect(0, 0, 15, 15);
          popMatrix();
          break;
        case 8:
          noStroke();
          fill(greyscale, greyscale * mouseXFactor, 255 * mouseYFactor);
          rect(posX, posY, 3.5, 3.5);
          rect(posX+4, posY, 3.5, 3.5);
          rect(posX, posY+4, 3.5, 3.5);
          rect(posX+4, posY+4, 3.5, 3.5);
          break;
        case 9:
          stroke(255, greyscale, 0);
          noFill();
          pushMatrix();
          translate(posX, posY);
          rotate(greyscale/255.0 * PI);
          strokeWeight(1);
          rect(0, 0, 15 * mouseXFactor, 15 * mouseYFactor);
          float w9 = map(greyscale, 0, 255, 15, 0.1);
          strokeWeight(w9);
          stroke(0, 70);
          ellipse(0, 0, 10, 5);
          popMatrix();
      }
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
  if (key == '4') drawMode = 4;
  if (key == '5') drawMode = 5;
  if (key == '6') drawMode = 6;
  if (key == '7') drawMode = 7;
  if (key == '8') drawMode = 8;
  if (key == '9') drawMode = 9;

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
