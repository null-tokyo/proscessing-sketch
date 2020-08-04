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
String textTyped = "";

PShape shapeSpace, shapeSpace2, shapePeriod, shapeComma;
PShape shapeQuestionmark, shapeExclamationmark, shapeReturn;

int centerX = 0, centerY = 0, offsetX = 0, offsetY = 0;
float zoom = 0.75;

int actRandomSeed = 6;

void setup(){
  size(displayWidth, displayHeight);

  surface.setResizable(true);

  // text to begin with
  textTyped += "Ich bin der Musikant mit Taschenrechner in der Hand!\n\n";
  textTyped += "Ich addiere\n";
  textTyped += "Und subtrahiere, \n\n";
  textTyped += "Kontrolliere\nUnd komponiere\nUnd wenn ich diese Taste drück,\nSpielt er ein kleines Musikstück?\n\n";
  
  textTyped += "Ich bin der Musikant mit Taschenrechner in der Hand!\n\n";
  textTyped += "Ich addiere\n";
  textTyped += "Und subtrahiere, \n\n";
  textTyped += "Kontrolliere\nUnd komponiere\nUnd wenn ich diese Taste drück,\nSpielt er ein kleines Musikstück?\n\n";
  
  centerX = width / 2;
  centerY = height / 2;

  font = createFont("miso-bold.ttf", 10);

  shapeSpace = loadShape("space.svg");
  shapeSpace2 = loadShape("space2.svg");
  shapeComma = loadShape("comma.svg"); 
  shapeExclamationmark = loadShape("exclamationmark.svg");
  shapeQuestionmark = loadShape("questionmark.svg");
  shapeReturn = loadShape("return.svg");

  cursor(HAND);
}

void draw() {
  /*
  * draw your program!
  */
  background(255);
  smooth();
  noStroke();
  textAlign(LEFT);

  if (mousePressed == true) {
    centerX = mouseX - offsetX;
    centerY = mouseY - offsetY;
  }

  randomSeed(actRandomSeed);
  translate(centerX,centerY);
  scale(zoom);

  for (int i = 0; i < textTyped.length(); i++) {
    float fontSize = 25;
    textFont(font, fontSize);
    char letter = textTyped.charAt(i);
    float letterWidth = textWidth(letter);

    switch(letter) {
      case ' ':
        int dir = floor(random(0, 2));
        if(dir == 0) {
          shape(shapeSpace, 0, 0);
          translate(1.9, 0);
          rotate(PI/4);
        }
        if(dir == 1) {
          shape(shapeSpace, 0, 0);
          translate(19, -5);
          rotate(-PI/4);
        }
        break;
      case ',':
        shape(shapeComma, 0, 0);
        translate(34, 15);
        rotate(PI/4);
        break;
      case '.':
        shape(shapePeriod, 0, 0);
        translate(56, 54);
        rotate(-PI/2);
        break;
      case '!':
        shape(shapeExclamationmark, 0, 0);
        translate(42, -17.4);
        rotate(-PI/4);
        break;
      case '?':
        shape(shapeQuestionmark, 0, 0);
        translate(42, -18);
        rotate(-PI/4);
        break;
      case '\n': // return  
        shape(shapeReturn, 0, 0);
        translate(0, 10);
        rotate(PI);
        break;
      default:
        fill(0);
        text(letter, 0, 0);
        translate(letterWidth, 0);
    }
  }

  fill(0);
  if (frameCount/6 % 2 == 0) rect(0, 0, 15, 2);

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

void mousePressed(){
  offsetX = mouseX-centerX;
  offsetY = mouseY-centerY;
}

void keyReleased() {
  if (keyCode == ALT) actRandomSeed++;
  println(actRandomSeed);
}

void keyPressed() {
  // if (key == DELETE || key == BACKSPACE) background(255);
  // if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  // if (key == 'g' || key == 'g') {
  //   gifExport = new GifMaker(this, timestamp()+".gif");
  //   gifExport.setRepeat(0);
  //   gifExport.setQuality(10);
  //   gifExport.setDelay(1);
  //   startGifFrame = frameCount;
  //   saveGif = true;
  // }

  if(key != CODED) {
    switch(key) {
      case DELETE:
      case BACKSPACE:
        textTyped = textTyped.substring(0, max(0, textTyped.length() - 1));
      case TAB:
        break;
      case ENTER:
      case RETURN:
        // enable linebreaks
        textTyped += "\n";
      break;
      default:
        textTyped += key;
    }
  }

    // zoom
  if (keyCode == UP) zoom += 0.05;
  if (keyCode == DOWN) zoom -= 0.05;  
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
