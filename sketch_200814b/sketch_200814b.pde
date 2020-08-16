import processing.video.*;
import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
Movie movie;

int tileCountX = 12;
int tileCountY = 16;
float tileWidth, tileHeight;
int imageCount = tileCountX*tileCountY;
int currentImage = 0;
int gridX = 0;
int gridY = 0;

void setup(){
  size(1024, 1024);
  smooth();
  background(0);

  String path = "movie.mp4";
  movie = new Movie(this, path);
  movie.play();

  tileWidth = width / (float)tileCountX;
  tileHeight = height / (float)tileCountY;
}

void draw() {
  /*
  * draw your program!
  */
  float posX = tileWidth * gridX;
  float posY = tileHeight * gridY;

  float moviePos = map(currentImage, 0, imageCount, 0, movie.duration());
  movie.jump(moviePos);
  movie.read();
  image(movie, posX, posY, tileWidth, tileHeight);

  gridX++;
  if (gridX >= tileCountX) {
    gridX = 0;
    gridY++;
  }

  currentImage ++;
  if (currentImage >= imageCount) noLoop();
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
