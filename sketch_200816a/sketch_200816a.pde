import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
String inputText = "Ihr naht euch wieder, schwankende Gestalten, Die früh sich einst dem trüben Blick gezeigt. Versuch ich wohl, euch diesmal festzuhalten? Fühl ich mein Herz noch jenem Wahn geneigt? Ihr drängt euch zu! nun gut, so mögt ihr walten, Wie ihr aus Dunst und Nebel um mich steigt; Mein Busen fühlt sich jugendlich erschüttert Vom Zauberhauch, der euren Zug umwittert. Ihr bringt mit euch die Bilder froher Tage, Und manche liebe Schatten steigen auf; Gleich einer alten, halbverklungnen Sage Kommt erste Lieb und Freundschaft mit herauf; Der Schmerz wird neu, es wiederholt die Klage.";
float fontSizeMax = 20;
float fontSizeMin = 10;
float spacing = 12;
float kerning = 0.5;

boolean fontSizeStatic = false;
boolean blackAndWhite = false;

PFont font;
PImage img;

void setup(){
  size(533, 769);
  smooth();

  font = createFont("Times", 10);

  img = loadImage("pic.png");
  println(img.width + " x " + img.height);
}

void draw() {
  /*
  * draw your program!
  */
  background(255);
  textAlign(LEFT);

  float x = 0, y = 10;
  int counter = 0;

  while (y < height) {
    int imgX = (int) map(x, 0, width, 0, img.width);
    int imgY = (int) map(y, 0, height, 0, img.height);

    color c = img.pixels[imgY*img.width + imgX];
    int greyscale = round(
      red(c) * 0.222 +
      green(c) * 0.707 +
      blue(c) * 0.071
    );

    pushMatrix();
    translate(x, y);

    if(fontSizeStatic) {
      textFont(font, fontSizeMax);
      if (blackAndWhite) fill(greyscale);
      else fill(c);
    } else {
      float fontSize = map(greyscale, 0, 255, fontSizeMax, fontSizeMin);
      fontSize = max(fontSize, 1);
      textFont(font, fontSize);
      if (blackAndWhite) fill(0);
      else fill(c);
    }

    char letter = inputText.charAt(counter);
    text(letter, 0, 0);
    float letterWidth = textWidth(letter) + kerning;

    x = x + letterWidth;
    popMatrix();

    if (x + letterWidth >= width) {
      x = 0;
      y = y + spacing;
    }

    counter++;
    if(counter > inputText.length() - 1) counter = 0;
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
  if (key == '1') fontSizeStatic = !fontSizeStatic;
  if (key == '2') blackAndWhite = !blackAndWhite;

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
  if(keyCode == UP) fontSizeMax += 2;
  if(keyCode == DOWN) fontSizeMax -= 2;

  if(keyCode == RIGHT) fontSizeMin += 2;
  if(keyCode == LEFT) fontSizeMin -= 2;
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
