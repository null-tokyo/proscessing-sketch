import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
boolean doSave = false;

String textTyped = "Type slow and fats!";
float[] fontSizes = new float[textTyped.length()];
float minFontSize = 15;
float maxFontSize = 800;
float newFontSize = 0;

int pMillis;
float maxTimeDelta = 5000.0;

float spacing = 2;
float tracking = 0;
PFont font;

void setup(){
  size(800, 600);
  surface.setResizable(true);
  font = createFont("Arial",10);

  smooth();
  noCursor();

  for (int i = 0; i < textTyped.length(); i++) {
    fontSizes[i] = minFontSize;
  }

  pMillis = millis();
}

void draw() {
  /*
  * draw your program!
  */
  background(255);
  textAlign(LEFT);
  fill(0);
  noStroke();

  spacing = map(mouseY, 0, height, 0, 120);
  translate(0, 200 + spacing);

  float x = 0;
  float y = 0;
  float fontSize = 20;

  for (int i = 0; i < textTyped.length(); i++) {
    fontSize = fontSizes[i];
    textFont(font, fontSize);
    char letter = textTyped.charAt(i);
    float letterWidth = textWidth(letter) + tracking;

    if( x + letterWidth >  width ) {
      x = 0;
      y += spacing;
    }

    text(letter, x, y);
    x += letterWidth;
  }

  float timeDelta = millis() - pMillis;
  newFontSize = map(timeDelta, 0,maxTimeDelta, minFontSize,maxFontSize);
  newFontSize = min(newFontSize, maxFontSize);

  fill(200, 30, 40);
  if(frameCount / 10 % 2 == 0) fill(255);
  rect(x, y, newFontSize / 2, newFontSize/ 20);

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
  if(key != CODED) {
    switch (key) {
      case DELETE:
      case BACKSPACE:
        if(textTyped.length() > 0) {
          textTyped = textTyped.substring(0, max(0,textTyped.length()-1));
        }
        break;
      case TAB:
      case ENTER:
      case RETURN:
      case ESC:
        break;
      default:
        textTyped += key;
        fontSizes = append(fontSizes, newFontSize);
    }

    pMillis = millis();
  }
//   if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
//   if (key == 'g' || key == 'g') {
//     gifExport = new GifMaker(this, timestamp()+".gif");
//     gifExport.setRepeat(0);
//     gifExport.setQuality(10);
//     gifExport.setDelay(1);
//     startGifFrame = frameCount;
//     saveGif = true;
//   }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
