import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
float x = 0;
float y = 0;
float stepSize = 5.0;

PFont font;
String letters = "ゴーシュもセロのきょろきょろ諸君らへ丁稚を向い下なくた。またしばらく下手たたにとって長椅子たた。変だでのたもまし実はゴーシュの元気汁のなかからはもう無理たましと、これじゃゴーシュへ云えれのないう。見過ぎ何は顔がひどいまして明方の病院のケース汁をある第万汗がいの病気がなってはじめうなら。かぶれもさっきなっがしまっだ。風は万行っゴーシュのように叩きけれどもやっまし。かぎは狸療だり何を呆ればいただいた。かっこうは金がぐっすりになってセロに意地悪のようを終るて狸を出てすっかり狸をやめています。夜通しやっと鳥が勢がついて行きたろでし。";
int fontSizeMin = 3;
float angleDistortion = 0.0;

int counter = 0;

void setup(){
  size(displayWidth, displayHeight);
  background(255);
  smooth();
  cursor(CROSS);

  x = mouseX;
  y = mouseY;

  font = createFont("NotoSerifJP-SemiBold",10);

  textFont(font, fontSizeMin);
  textAlign(LEFT);
  fill(0);

  String[] fontList = PFont.list();
  printArray(fontList);
}

void draw() {
  if(mousePressed) {
    float d = dist(x, y, mouseX, mouseY);
    textFont(font, fontSizeMin + d / 2);
    char newLetter = letters.charAt(counter);
    stepSize = textWidth(newLetter);

    if(d > stepSize) {
      float angle = atan2(mouseY-y, mouseX-x);

      pushMatrix();
      translate(x, y);
      rotate(angle + random(angleDistortion));
      text(newLetter, 0, 0);
      popMatrix();
      counter++;
      if (counter > letters.length()-1) counter = 0;

      x = x + cos(angle) * stepSize;
      y = y + sin(angle) * stepSize; 

      // x = mouseX;
      // y = mouseY;
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

void mousePressed() {
  x = mouseX;
  y = mouseY;
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
