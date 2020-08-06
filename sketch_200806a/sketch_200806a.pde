import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
PFont font;
String[] lines;
String joinedText;

String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß,.;:!? ";
int[] counters = new int[alphabet.length()];

int posX, posY;
int tracking = 29;

int actRandomSeed = 0;

boolean drawAlpha = true;
boolean drawLines = true;
boolean drawEllipses = true;
boolean drawText = true;

void setup(){
  size(1400, 800);
  lines = loadStrings("faust_kurz.txt");
  joinedText = join(lines, " ");

  font = createFont("Courier", 10);

  countCharacters();
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100, 100);
  textFont(font);
  background(360);
  noStroke();
  smooth();
  textSize(20);

  posX = 80;
  posY = 300;
  for (int i = 0; i < joinedText.length(); i++) {

    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar);
    if (index < 0) continue;

    float charAlpha = 100;
    if (drawAlpha) charAlpha = counters[index];

    float my = map(mouseY, 50, height - 50, 0, 1);
    my = constrain(my, 0, 1);
    float charSize = counters[index] * my * 3;
    
    pushMatrix();
    translate(posX, posY);
    noStroke();
    fill(52, 100, 71, charAlpha);
    if (drawEllipses) ellipse(0, 0, charSize * 0.1, charSize * 0.1);
    popMatrix();

    posX += textWidth(joinedText.charAt(i));
    if (posX >= width-200) {
      posY += int(tracking+30);
      posX = 80;
    }
  }

  if (drawText) {
    posX = 80;
    posY = 300;

    randomSeed(actRandomSeed);

    for (int i = 0; i < joinedText.length(); i++) {

      String s = str(joinedText.charAt(i)).toUpperCase();
      char uppercaseChar = s.charAt(0);
      int index = alphabet.indexOf(uppercaseChar);
      if (index < 0) continue;

      float charAlpha = 100;
      if (drawAlpha) charAlpha = counters[index];

      float my = map(mouseY, 50,height-50, 0,1);
      my = constrain(my, 0, 1);
      float charSize = counters[index] * my * 3;

      float mx = map(mouseX, 50, width - 50, 0, 1);
      mx = constrain(mx, 0, 1);
      float lineLength = charSize;
      //float newPosX = lineLength;
      float newPosX = 0;
      float newPosY = -lineLength;
      
      pushMatrix();
      translate(posX, posY);
      stroke(273, 73, 51, charAlpha);
      if (drawLines) line(0, 0, newPosX, newPosY);
      fill(0, charAlpha);
      text(joinedText.charAt(i), newPosX, newPosY);
      popMatrix();

      posX += textWidth(joinedText.charAt(i));
      if(posX >= width - 200) {
        posY += int(tracking + 30);
        posX = 80;
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

void countCharacters() {
  for(int i = 0; i < joinedText.length(); i++) {
    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar);
    if(index >= 0) counters[index]++;
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
