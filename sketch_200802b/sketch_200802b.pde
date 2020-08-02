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
float lineModuleSize = 0;
float angle = 0;
float angleSpeed = 1.0;
PShape lineModule = null;

int clickPosX = 0;
int clickPosY = 0;

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
    int x = mouseX;
    int y = mouseY;

    if(keyPressed && keyCode == SHIFT) {
      if (abs(clickPosX -  x) > abs(clickPosY - y)) {
        y = clickPosY;
      }else {
        x = clickPosY;
      }
    }

    strokeWeight(0.75);
    noFill();
    stroke(col);
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));

    if(lineModule != null) {
      shape(lineModule, 0, 0, lineModuleSize, lineModuleSize);
    } else {
      line(0, 0, lineModuleSize, lineModuleSize);
    }
    angle = angle + angleSpeed;

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

void mousePressed() {
  // create a new random color and line length
  lineModuleSize = random(50,160);

  // remember click position
  clickPosX = mouseX;
  clickPosY = mouseY;
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

    // load svg for line module
  if (key=='5') lineModule = null;
  if (key=='6') lineModule = loadShape("02.svg");
  if (key=='7') lineModule = loadShape("03.svg");
  if (key=='8') lineModule = loadShape("04.svg");
  if (key=='9') lineModule = loadShape("05.svg");
  if (lineModule != null) {
    lineModule.disableStyle();
  }

  //default colors from 1 to 4 
  if (key == '1') col = color(181,157,0,100);
  if (key == '2') col = color(0,130,164,100);
  if (key == '3') col = color(87,35,129,100);
  if (key == '4') col = color(197,0,123,100);
}

void keyPressed() {
  if (keyCode == UP) lineModuleSize += 5;
  if (keyCode == DOWN) lineModuleSize -= 5; 
  if (keyCode == LEFT) angleSpeed -= 0.5;
  if (keyCode == RIGHT) angleSpeed += 0.5; 
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
