import processing.opengl.*;
import geomerative.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
RFont font;
String textTyped = "Type ...!";

boolean doSave = false;
int shapeSet = 0;
PShape module1, module2;

void setup(){
  size(1324, 350);
  surface.setResizable(true); 
  smooth();

  RG.init(this);
  font = new RFont("FreeSans.ttf", 200, RFont.LEFT);

  // RCommand.setSegmentStep(11);
  // RCommand.setSegmentator(RCommand.UNIFORMSTEP);

  RCommand.setSegmentLength(11);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

  // RCommand.setSegmentAngle(random(0,HALF_PI));
  // RCommand.setSegmentator(RCommand.ADAPTATIVE);
}

void draw() {
  /*
  * draw your program!
  */
  background(255);
  translate(20, 220);

  if(textTyped.length() > 0) {
    RGroup grp;
    grp = font.toGroup(textTyped);
    RPoint[] pnts = grp.getPoints();

    stroke(181, 157, 0);
    strokeWeight(1.0);
    for (int i = 0; i < pnts.length; i++) {
      float l = 5;
      line(pnts[i].x - l, pnts[i].y - l, pnts[i].x + l, pnts[i].y +l);
    }

    fill(0);
    noStroke();
    for (int i = 0; i < pnts.length; i++) {
      float diameter = 7;

      if(i % 2 == 0) {
        ellipse(pnts[i].x, pnts[i].y, diameter, diameter);
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

void keyReleased() {
  if (key != CODED) {
    switch(key) {
    case DELETE:
    case BACKSPACE:
      textTyped = textTyped.substring(0,max(0,textTyped.length()-1));
      break;
    case TAB:   
    case ENTER:
    case RETURN:
    case ESC:
      break;
    default:
      textTyped += key;
    }
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
