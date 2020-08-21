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

color arcColor = color(0, 130, 164, 100);

float tileSize = 40;
int gridResolutionX, gridResolutionY;
boolean debugMode = true;
PShape arrow;

void setup(){
  size(800, 800);
  cursor(CROSS);

  gridResolutionX = round(width / tileSize);
  gridResolutionY = round(height / tileSize);

  smooth();
  arrow = loadShape("arrow.svg");
}

void draw() {
  /*
  * draw your program!
  */
  background(255);

  noiseDetail(octaves, falloff);  
  float noiseXRange = mouseX / 100.0;
  float noiseYRange = mouseY / 100.0;

  for (int gY = 0; gY <= gridResolutionY; ++gY) {
    for (int gX = 0; gX <= gridResolutionX; ++gX) {
      float posX = tileSize * gX;
      float posY = tileSize * gY;

      float noiseX = map(gX, 0, gridResolutionX, 0, noiseXRange);
      float noiseY = map(gY, 0, gridResolutionY, 0, noiseYRange);

      float noiseValue = noise(noiseX, noiseY);
      float angle = noiseValue * TWO_PI;

      pushMatrix();
      translate(posX, posY);

      if (debugMode) {
        noStroke();
        ellipseMode(CENTER);
        fill(noiseValue*255);
        ellipse(0,0,tileSize*0.25,tileSize*0.25);
      }
      
      // arc
      noFill();
      strokeCap(SQUARE);
      strokeWeight(1);
      stroke(arcColor);
      arc(0, 0, tileSize * 0.75, tileSize * 0.75, 0, angle);

      // arrow
      stroke(0);
      strokeWeight(0.75);
      rotate(angle);
      shape(arrow,0,0,tileSize*0.75,tileSize*0.75);
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
