import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;
import geomerative.*;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
char typedKey = 'a';
float spacing = 20;
float spaceWidth = 150;
int fontSize = 200;
float lineSpacing = fontSize * 1.5;
float stepSize = 2;
float danceFactor = 1;
float letterX = 50;
float textW = 50;
float letterY = lineSpacing;

RFont font;
RGroup grp;
RPoint[] pnts;

boolean freeze = false;

void setup(){
  size(1200, 800);
  background(255);
  smooth();

  frameRate(15);

  RG.init(this);
  font = new RFont("FreeSans.ttf", fontSize, RFont.LEFT);

  RCommand.setSegmentLength(25);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

  grp = font.toGroup(typedKey+"");
  textW = grp.getWidth();
  pnts = grp.getPoints();

  background(255);
}

void draw() {
  /*
  * draw your program!
  */
  noFill();
  pushMatrix();

  translate(letterX, letterY);

  if (mousePressed) danceFactor = map(mouseX, 0,width, 1,3);
  else danceFactor = 1;

  if (grp.getWidth() > 0) {
    for (int i = 0; i < pnts.length; ++i) {
      pnts[i].x += random(-stepSize,stepSize)*danceFactor;
      pnts[i].y += random(-stepSize,stepSize)*danceFactor; 
    }

    strokeWeight(0.08);

    beginShape();
    curveVertex(pnts[pnts.length - 1].x, pnts[pnts.length - 1].y);
    for (int i = 0; i < pnts.length; ++i) {
      curveVertex(pnts[i].x, pnts[i].y);
    }
    curveVertex(pnts[0].x, pnts[0].y);
    curveVertex(pnts[1].x, pnts[1].y);
    endShape();


    strokeWeight(0.1);
    stroke(0);
    beginShape();
    for (int i = 0; i < pnts.length; ++i) {
      vertex(pnts[i].x, pnts[i].y);
      ellipse(pnts[i].x, pnts[i].y, 7, 7);
    }
    vertex(pnts[0].x, pnts[0].y);
    endShape();
  }

  popMatrix();

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


void keyPressed() {
  if (key != CODED) {
    switch(key) {
    case ENTER:
    case RETURN:
      grp = font.toGroup(""); 
      letterY += lineSpacing;
      textW = letterX = 20;
      break;
    case ESC:
    case TAB:
      break;
    case BACKSPACE:
    case DELETE:
      background(255);
      grp = font.toGroup(""); 
      textW = letterX = 0;
      letterY = lineSpacing;
      freeze = false;
      loop();
      break;
    case ' ':
      grp = font.toGroup(""); 
      letterX += spaceWidth;
      freeze = false;
      loop();
      break;
    default:
      typedKey = key;
      // add to actual pos the letter width
      textW += spacing;
      letterX += textW;
      grp = font.toGroup(typedKey+"");
      textW = grp.getWidth();
      pnts = grp.getPoints(); 
      freeze = false;
      loop();
    }
  } 
}
// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
