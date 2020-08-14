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
      if (contents[i].charAt(0) == '.') continue;
      else if (contents[i].toLowerCase().endsWith(".png")) {
        File childFile = new File(dir, contents[i]);
        images[imageCount] = loadImage(childFile.getPath());
        imageNames[imageCount] = childFile.getName();
        imageCount++;
      }
    }
  }

  layer1Items = generateCollageItems("layer1", (int) random(50, 200), width / 2, height / 2, width, height, 0.1, 0.5, 0, 0);
  layer2Items = generateCollageItems("layer2", (int) random(25, 300), 200, height * 0.75, width, 150, 0.1, random(0.3,0.8), -PI / 2, PI / 2);
  layer3Items = generateCollageItems("layer3", (int) random(50, 300), width / 2, height * 0.66, width, height * 0.66, 0.1, random(0.4,0.8), -0.05, 0.05);

  drawCollageItems(layer1Items);
  drawCollageItems(layer2Items);
  drawCollageItems(layer3Items);
}

void draw() {
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
  float x = 0, y = 0;
  float rotation = 0;
  float scaling = 1;
  int indexToImage = -1;
}

CollageItem[] generateCollageItems(String thePrefix, int theCount, float thePosX, float thePosY, float theRangeX, float theRangeY, float theScaleStart, float theScaleEnd, float theRotationStart, float theRotationEnd) {
  int[] indexes = new int[0];
  for (int i = 0; i < imageNames.length; ++i) {
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
    items[i].x = thePosX + random(-theRangeX / 2, theRangeX / 2);
    items[i].y = thePosY + random(-theRangeY / 2, theRangeY / 2);
    items[i].scaling = random(theScaleStart, theScaleEnd);
    items[i].rotation = random(theRotationStart, theRotationEnd);
  }

  return items;
}

void drawCollageItems(CollageItem[] theItems) {
  for (int i = 0 ; i < theItems.length; i++) {
    pushMatrix();
    translate(theItems[i].x, theItems[i].y);
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
