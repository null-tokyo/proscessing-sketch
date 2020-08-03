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
String letter ="A";

void setup(){
  size(800, 800);
  background(255);
  fill(0);
  smooth();

  font = createFont("Arial", 12);
  textFont(font);
  textAlign(CENTER, CENTER);
}

void draw() {
}

void mouseMoved() {
  background(255);
  textSize((mouseX - width / 2) * 5 + 1);
  text(letter, width / 2, mouseY);
}

void mouseDragged() {
  textSize((mouseX - width / 2) * 5 + 1);
  text(letter, width / 2, mouseY);
}

void keyReleased() {
  if (key != CODED && (int)key > 32) letter = str(key);
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
