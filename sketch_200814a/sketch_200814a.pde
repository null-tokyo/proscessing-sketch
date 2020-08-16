import processing.opengl.*;
import gifAnimation.*;
import java.util.Calendar;

// Gif Setting
GifMaker gifExport;
boolean saveGif = false;
int startGifFrame = 0;
int gifSecond = 3;

//Global
PImage[] images;
String[] imageNames;
int imageCount;

CollageItem[] layer1Items, layer2Items, layer3Items;

void setup(){
  size(1024, 768);
  imageMode(CENTER);
  background(255);

  File dir = new File(sketchPath(""), "../footage");

  if (dir.isDirectory()) {
    String[] contents = dir.list();
    images = new PImage[contents.length];
    imageNames = new String[contents.length];
    for (int i = 0; i < contents.length; i++) {

      if(contents[i].charAt(0) == '.') continue;
      else if(contents[i].toLowerCase().endsWith(".png")) {
        File childFile = new File(dir, contents[i]);
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();
        println(imageCount + " " + contents[i] + " " + childFile.getPath());
        imageCount++;
      }
    }
  }

  layer1Items = generateCollageItems(
    "layer1",
    100,
    0,
    height/2,
    TWO_PI,
    height,
    0.1,0.5,
    0,0
  );
  layer2Items = generateCollageItems(
    "layer2",
    150,
    0,
    height/2,
    TWO_PI,
    height,
    0.1,0.3,
    -PI/6,PI/6
  );
  layer3Items = generateCollageItems(
    "layer3",
    110,
    0,
    height/2,
    TWO_PI,
    height,
    0.1,0.2,
    0,0
  );

  drawCollageItems(layer1Items);
  drawCollageItems(layer2Items);
  drawCollageItems(layer3Items);
}

void draw() {
  /*
  * draw your program!
  */

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

class CollageItem {
  float a = 0;
  float l = 0;
  float rotation = 0;
  float scaling = 1;
  int indexToImage = -1;
}

CollageItem[] generateCollageItems(
  String thePrefix,
  int theCount,
  float theAngle,
  float theLength,
  float theRangeA,
  float theRangeL,
  float theScaleStart,
  float theScaleEnd,
  float theRotationStart,
  float theRotationEnd
) {
  int[] indexes = new int[0];
  for (int i = 0; i < imageNames.length; i++) {
    if (imageNames[i] != null) {
      if (imageNames[i].startsWith(thePrefix)) {
        indexes = append(indexes, i);
      }
    }
  }

  CollageItem[] items = new CollageItem[theCount];
  for (int i = 0; i < items.length; i++) {
    items[i] = new CollageItem();
    items[i].indexToImage = indexes[i % indexes.length];
    items[i].a = theAngle + random(-theRangeA * 0.5, theRangeA * 0.5);
    items[i].l = theLength + random(-theRangeL * 0.5, theRangeL * 0.5);
    items[i].scaling = random(theScaleStart, theScaleEnd);
    items[i].rotation = items[i].a + HALF_PI + random(theRotationStart, theRotationEnd);
  }

  return items;
}

void drawCollageItems(CollageItem[] theItems) {
  for (int i = 0; i < theItems.length; i++) {
    pushMatrix();
    float newX = width/2 + cos(theItems[i].a) * theItems[i].l;
    float newY = height/2 + sin(theItems[i].a) * theItems[i].l;
    translate(newX, newY);
    rotate(theItems[i].rotation);
    scale(theItems[i].scaling);
    image(images[theItems[i].indexToImage], 0, 0);
    popMatrix();
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
