import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global

int octaves = 4;
float falloff = 0.5;

int noiseMode = 1;

void setup(){
  size(512, 512);
  smooth();
  cursor(CROSS);
}

void draw() {
  /*
  * draw your program!
  */
  background(0);

  noiseDetail(octaves, falloff);

  int noiseXRange = mouseX / 10;
  int noiseYRange = mouseY / 10;

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float noiseX = map(x, 0, width, 0, noiseXRange);
      float noiseY = map(y, 0, height, 0, noiseYRange);
      float noiseValue = 0;
      if (noiseMode == 1) {
        noiseValue = noise(noiseX, noiseY) * 255;
      } else if (noiseMode == 2) {
        float n = noise(noiseX, noiseY) * 24;
        noiseValue = (n - int(n)) * 255;
      }
      pixels[x + y * width] = color(noiseValue);
    }
  }
  updatePixels();

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
  if(key == '1') noiseMode = 1;
  if(key == '2') noiseMode = 2;
  if(key == ' ') noiseSeed((int) random(100000));

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

void keyPressed() {
  if(keyCode == UP) falloff += 0.05;
  if(keyCode == DOWN) falloff -= 0.05;
  if (falloff > 1.0) falloff = 1.0;
  if (falloff < 0.0) falloff = 0.0;

  if (keyCode == LEFT) octaves--;
  if (keyCode == RIGHT) octaves++;
  if (octaves < 0) octaves = 0;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
