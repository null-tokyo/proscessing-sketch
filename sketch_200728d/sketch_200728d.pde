import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
float tileCountX = 5;
float tileCountY = 5;

int count = 10;
int colorStep = 20;

int lineWeight = 0;
int strokeColor = 0;

color backgroundColor = 0;

int drawMode = 1;


void setup(){
  frameRate(30);
  size(800, 800);
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100, 100);
  strokeWeight(0.5);
  strokeCap(ROUND);

  tileCountX = mouseX / 30 + 1;
  tileCountY = mouseY / 30 + 1;

  background(backgroundColor);

  for (int gridY = 0; gridY < tileCountY; gridY++) {
    for (int gridX = 0; gridX < tileCountX; gridX++) {
      float tileWidth = width / tileCountX;
      float tileHeight = height / tileCountY;
      float posX = tileWidth * gridX;
      float posY = tileHeight * gridY;

      float x1 = tileWidth / 2;
      float y1 = tileHeight / 2;

      float x2 = 0;
      float y2 = 0;

      pushMatrix();
      translate(posX, posY);

      for (int side = 0; side < 4; side++) {
        for (int i = 0; i < count; i++) {
          if(side == 0){     
            x2 += tileWidth/count;
            y2 = 0;
          }
          if(side == 1){     
            x2 = tileWidth;
            y2 += tileHeight/count;
          }
          if(side == 2){     
            x2 -= tileWidth/count;
            y2 = tileHeight;
          }
          if(side == 3){     
            x2 = 0;
            y2 -= tileHeight/count;
          }


          switch(drawMode){
            case 1:
              backgroundColor = 360;
              stroke(0);
              break;
            case 2:
              backgroundColor = 360;
              stroke(0);
              strokeWeight(lineWeight);
              break;
            case 3:
              backgroundColor = 360;
              stroke(strokeColor);
              strokeWeight(mouseX/100);
              break;
            }
          
          line(x1, y1, x2, y2);
        }
      }

      popMatrix();
    }
  }

  // save ggridYf animation
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
  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == '3') drawMode = 3;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%3$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
