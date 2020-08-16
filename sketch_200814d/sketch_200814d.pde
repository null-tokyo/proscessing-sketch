import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
PShape[] shapes;
int shapeCount = 0;

PImage img;

void setup(){
  size(600, 900);
  smooth();
  img = loadImage("pic.png");
  println(img.width + " x " + img.height);

  File dir = new File(sketchPath(""), "data");
  if (dir.isDirectory()) {
    String[] contents = dir.list();
    shapes = new PShape[contents.length];
    for (int i = 0; i < contents.length; i++) {
      if (contents[i].charAt(0) == '.') continue;
      else if (contents[i].toLowerCase().endsWith(".svg")) {
        File childFile = new File(dir, contents[i]);
        shapes[shapeCount] = loadShape(contents[i]);
        shapeCount++;
      }
    }
  }
}

void draw() {
  /*
  * draw your program!
  */
  background(255);

  for (int gridX = 0; gridX < img.width; gridX++) {
    for (int gridY = 0; gridY < img.height; gridY++) {
      float tileWidth = width / (float)img.width;
      float tileHeight = height / (float)img.height;
      float posX = tileWidth * gridX;
      float posY = tileHeight * gridY;

      color c = img.pixels[gridY*img.width + gridX];
      int greyscale = round(
        red(c) * 0.222 +
        green(c) * 0.707 +
        blue(c) * 0.071
      );

      int gradientToIndex = round(map(greyscale, 0, 255, 0, shapeCount - 1));
      shape(shapes[gradientToIndex], posX,posY, tileWidth,tileHeight);
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
