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
boolean[] drawLetters = new boolean[alphabet.length()];

float charSize;
color charColor = 0;
int posX = 20;
int posY = 50;

boolean drawGreyLines = true;
boolean drawColoredLines = true;
boolean drawText = true;

void setup(){
  size(1200, 800);
  lines = loadStrings("faust_kurz.txt");
  joinedText = join(lines, "");

  font = createFont("Courier", 10);

  for (int i = 0; i < alphabet.length(); i++) {
    drawLetters[i] = true;
  }

  countCharacters();
}

void countCharacters() {
  for (int i = 0; i < joinedText.length(); ++i) {
    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar); 
    if(index >=  0) counters[index]++;
  }
}

void draw() {
  /*
  * draw your program!
  */
  colorMode(HSB, 360, 100, 100, 100);
  textFont(font);
  background(360);
  noStroke();
  fill(0);
  smooth();

  translate(50, 0);

  posX = 0;
  posY = 200;

  float[] sortPositionsX = new float[alphabet.length()];
  float[] oldPositionsX = new float[alphabet.length()];
  float[] oldPositionsY = new float[alphabet.length()];
  float oldX = 0;
  float oldY = 0;

  // draw counters
  //if(mouseX >= width - 50) {
    textSize(10);
    for (int i = 0; i < alphabet.length(); i++) {
      textAlign(LEFT);
      text(alphabet.charAt(i), -15, i * 20 + 40);
      textAlign(RIGHT);
      text(counters[i], -20, i * 20 + 40);
    }
  //}

  textAlign(LEFT);
  textSize(18);


  for (int i = 0; i < joinedText.length(); i++) {
    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar);
    if(index < 0) continue;

    float m = map(mouseX, 59, width - 50, 0, 1);
    m = constrain(m, 0, 1);

    float sortX = sortPositionsX[index];
    float interX = lerp(posX, sortX, m);

    float sortY = index * 20 + 40;
    float interY = lerp(posY, sortY, m);

    if(drawLetters[index]) {
      if(drawGreyLines) {
        if (oldX != 0 && oldY != 0) {
          stroke(0, 10);
          line(oldX, oldY, interX, interY);
        }
        oldX = interX;
        oldY = interY;
      }
      if(drawColoredLines) {
        if(oldPositionsX[index] != 0 && oldPositionsY[index] != 0) {
          stroke(index*10, 80, 60, 50);
          line(oldPositionsX[index], oldPositionsY[index], interX, interY);
        }
        oldPositionsX[index] = interX;
        oldPositionsY[index] = interY;
      }
      text(joinedText.charAt(i), posX, posY);
    }

    sortPositionsX[index] += textWidth(joinedText.charAt(i));
    posX += textWidth(joinedText.charAt(i));
    if (posX >= width-200 && uppercaseChar == ' ') {
      posY += 40;
      posX = 0;
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
    if (key == '1') drawGreyLines = !drawGreyLines;

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