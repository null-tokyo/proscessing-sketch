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
  joinedText = join(lines, "");

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
  randomSeed(actRandomSeed);


  for (int i = 0; i < joinedText.length(); ++i) {
  } 

  for (int i = 0; i < joinedText.length(); ++i) {
    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar);
    if (index < 0) continue;

    fill(87, 35, 129);
    textSize(18);

    text(joinedText.charAt(i), posX, posY);

    posX += textWidth(joinedText.charAt(i));

    if(posX >= width - 200 && uppercaseChar == ' ') {
      posY += int(tracking + 30);
      posX = 80;
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
