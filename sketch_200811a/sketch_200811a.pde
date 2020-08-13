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

int tileCountX = 4;
int tileCountY = 4;
int tileCount = tileCountX * tileCountY;
PImage[] imageTiles = new PImage[tileCount];

int tileWidth, tileHeight;

int cropX = 0;
int cropY = 0;

boolean selectMode = true;
boolean randomMode = false;

void setup(){
  size(1600, 1200);
  img = loadImage("image.jpg");
  image(img, 0, 0);
  noCursor();

  tileWidth = width/tileCountY;
  tileHeight = height/tileCountX;
}

void draw() {
  /*
  * draw your program!
  */
  if (selectMode == true) {
    cropX = constrain(mouseX, 0, width - tileWidth);
    cropY = constrain(mouseY, 0, width - tileWidth);

    image(img, 0, 0);
    noFill();
    stroke(255);
    rect(cropX, cropY, tileWidth, tileHeight);
  } else {
    int i = 0;
    for (int gridY = 0; gridY < tileCountY; gridY++) {
      for (int gridX = 0; gridX < tileCountY; gridX++) {
        image(imageTiles[i], gridX*tileWidth, gridY*tileHeight);
        i++;
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

void cropTiles() {
  tileWidth = width / tileCountY;
  tileHeight = height / tileCountX;
  tileCount = tileCountX * tileCountY;
  imageTiles = new PImage[tileCount];

  int i = 0;
  for (int gridY = 0; gridY < tileCountY; gridY++) {
    for (int gridX = 0; gridX < tileCountY; gridX++) {
      if (randomMode){
        cropX = (int) random(mouseX-tileWidth/2, mouseX+tileWidth/2);
        cropY = (int) random(mouseY-tileHeight/2, mouseY+tileHeight/2);
      }
      cropX = constrain(cropX, 0, width - tileWidth);
      cropX = constrain(cropX, 0, width - tileHeight);
      imageTiles[i++] = img.get(cropX, cropY, tileWidth, tileHeight);
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
  if (key == 'r'){
    randomMode = true;
  }
  if (key == '1'){
    tileCountY = 4;
    tileCountX = 4;
    cropTiles();
  }
  if (key == '2'){
    tileCountY = 10;
    tileCountX = 10;
    cropTiles();
  }
  if (key == '3'){
    tileCountY = 20;
    tileCountX = 20;
    cropTiles();
  }
}

void mouseMoved() {
  selectMode = true;
}

void mouseReleased(){
  selectMode = false; 
  cropTiles();
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
