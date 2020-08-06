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
String joinedText;

String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß,.;:!? ";
int[] counters = new int[alphabet.length()];
boolean[] drawLetters = new boolean[alphabet.length()];

float charSize;
color charColor = 0;
int posX, posY;

boolean drawAlpha = true;
boolean drawLines = false;
boolean drawText = true;

void setup(){
  size(670, 800);
  String[] lines = loadStrings("faust_kurz.txt");
  joinedText = join(lines, "");

  font = createFont("Courier", 10);

  countCharacters();
}

void draw() {
  /*
  * draw your program!
  */
  textFont(font);
  background(255);
  noStroke();
  smooth();

  posX = 20;
  posY = 200;
  float oldX = 0;
  float oldY = 0;

  for (int i = 0; i < joinedText.length(); ++i) {
    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar);
    if (index < 0) continue;

    fill(87, 35, 129);
    textSize(18);

    float sortY = index * 20 + 40;
    float m = map(mouseX, 50,width-50, 0,1);
    float interY = lerp(posY, sortY, m);
    if (drawLetters[index]) {
      if (drawLines) {
        if (oldX!=0 && oldY!=0) {
          stroke(181, 157, 0, 100);
          line(oldX, oldY, posX, interY);
        }
        oldX = posX;
        oldY = interY;
      }
      if (drawText) text(joinedText.charAt(i), posX, interY);
    } else {
      oldX = 0;
      oldY = 0;
    }

    posX += textWidth(joinedText.charAt(i));

    if(posX >= width - 200 && uppercaseChar == ' ') {
      posY += 40;
      posX = 20;
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
  for (int i = 0; i < joinedText.length(); i++) {
    char c = joinedText.charAt(i);
    String s = str(c);
    s = s.toUpperCase();

    char uppercaseChar = s.charAt(0);

    int index = alphabet.indexOf(uppercaseChar);

    if(index >= 0) counters[index]++;
  }
}

void keyReleased() {
  if (key == '1') drawLines = !drawLines;
  if (key == '2') drawText = !drawText;

    if (key == '3') {
    for (int i = 0; i < alphabet.length(); i++) {
      drawLetters[i] = false;
    }
  }
  if (key == '4') {
    drawText = true;
    for (int i = 0; i < alphabet.length(); i++) {
      drawLetters[i] = true;
    }
  }
  String s = str(key).toUpperCase();
  char uppercaseKey = s.charAt(0);
  int index = alphabet.indexOf(uppercaseKey);
  if (index >= 0) {
    drawLetters[index] = !drawLetters[index];
  }

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
