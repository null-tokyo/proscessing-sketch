import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
color col = color(181, 157, 0, 100);
float lineLength = 0;
float angle = 0;
float angleSpeed = 1.0;

void setup(){
  size(displayWidth, displayHeight);
  background(255);
  smooth();
  cursor(CROSS);
}

void draw() {
  /*
  * draw your program!
  */

  if (mousePressed) {
    pushMatrix();
    strokeWeight(1.0);
    noFill();
    stroke(col);
    translate(mouseX, mouseY);
    rotate(radians(angle));
    line(0, 0, lineLength, 0);
    popMatrix();

    angle += angleSpeed;
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
  lineLength = random(70, 200);
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

  if (key == 'd' || key == 'D') {
    angle = angle + 180;
    angleSpeed = angleSpeed * -1;
  }

  if (key == '1') col = color(181, 157, 0, 100);
  if (key == '2') col = color(0, 130, 164, 100);
  if (key == '3') col = color(87, 35, 129, 100);
  if (key == '4') col = color(197, 0, 123, 100);

  if (keyCode == UP) lineLength += 5;
  if (keyCode == DOWN) lineLength -= 5; 
  if (keyCode == LEFT) angleSpeed -= 0.5;
  if (keyCode == RIGHT) angleSpeed += 0.5;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
