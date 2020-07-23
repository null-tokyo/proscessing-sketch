import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

int colorCount = 20;
int[] hueValues = new int[colorCount];
int[] saturationValues = new int[colorCount];
int[] brightnessValues = new int[colorCount];
int alphaValue = 27;

int actRandomSeed = 0;

void setup(){
  frameRate(30);
  size(800, 800, P3D); 
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
}

void draw() {
  background(0, 0, 100);
  randomSeed(actRandomSeed);

  // --- colors ---
  // create palette
  for (int i = 0; i < colorCount; ++i) {
    if( i % 2 == 0 ) {
      hueValues[i] = (int) random(170,180);
      saturationValues[i] = 100;
      brightnessValues[i] = (int) random(50,100);
    }else {
      hueValues[i] = (int) random(310,350);
      saturationValues[i] = 100;
      brightnessValues[i] = (int) random(50,100);
    }
  }

  // area tiling ---
  // count tiles

  int counter = 0;
  int rowCount = (int)random(5,30);
  float rowHeight = (float)height / (float)rowCount;

  for (int i = rowCount; i >= 0; i--) {
    // how many fragments
    int partCount = i+1;
    float[] parts = new float[0];

    for (int ii = 0; ii < partCount; ii++) {
      if(random(1.0) < 0.075) {
        int fragments = (int) random(2, 20);
        for (int iii = 0; iii < fragments; iii++) {
          parts = append(parts, random(2));
        }
      } else {
        parts = append(parts, random(2, 20));
      }
    }

    // add all subparts
    float sumPartsTotal = 0;
    for (int ii = 0; ii < partCount; ++ii) {
      sumPartsTotal += parts[ii];
    }

    // draw rect

    float sumPartsNow = 0;
    for (int ii = 0; ii < parts.length; ++ii) {
      sumPartsNow += parts[ii];

      if (random(1.0) < 0.45) {

        float x = map(sumPartsNow, 0, sumPartsTotal, 0, width);
        float y = rowHeight * i;
        float w = map(parts[ii], 0, sumPartsTotal, 0, width) * -1;
        float h = rowHeight * 1.5;

        beginShape();
        fill(0, 0, 100);
        vertex(x, y);
        vertex(x + w, y);
        
        // get component color values + alpha
        int index = counter % colorCount;
        fill(
          hueValues[index],
          saturationValues[index],
          brightnessValues[index],
          alphaValue
        );

        vertex(x + w, y + h);
        vertex(x, y + h);
        endShape(CLOSE);

        counter++;
      }
    }
  }
  actRandomSeed ++;


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

void mouseReleased() {
  actRandomSeed = (int) random(100000);
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
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
