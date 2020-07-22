int colorCount = 20;
int[] hueValues = new int[colorCount];
int[] saturationValues = new int[colorCount];
int[] brightnessValues = new int[colorCount];

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
}

void draw() {
  // ------ colors ------
  // create palette
  for (int i=0; i<colorCount; i++) {
    if (i%2 == 0) {
      hueValues[i] = 195 + (int) random(50,100);
      saturationValues[i] = 100;
      brightnessValues[i] = (int) random(random(80,100), 100);
    } 
    else {
      hueValues[i] = 195;
      saturationValues[i] = (int) random(random(0,50), random(50,100));
      brightnessValues[i] = 100;
    }
  }
  
  // ------ area tiling -----
  // count tiles
  int counter = 0;
  // row count and row height
  int rowCount = (int) random(5, 40);
  float rowHeight = (float)height / (float)rowCount;
  
  for(int i = 0; i < rowCount; i++) {
    // seperate each line in parts
    // how many fragments
    int partCount = i + 1;
    float[] parts = new float[0];
    
    for(int ii = 0; ii < partCount; ii++) {
      if (random(1.0) < 0.075) {
        // take care of big values      
        int fragments = (int)random(2,random(2, 10));
        partCount = partCount + fragments; 
        for(int iii=0; iii<fragments; iii++) {
          parts = append(parts, random(2));
        }              
      }  
      else {
        parts = append(parts, random(2,10));   
      }
    }
    
    // add all sub parts
    float sumPartsTotal = 0;
    for(int ii = 0; ii < partCount; ii++) {
      sumPartsTotal += parts[ii];
    }
    
    // draw rects
    float sumPartsNow = 0;
    for(int ii = 0; ii < partCount; ii++) {
      // get Component color values
      int index = counter % colorCount;
      fill(
        hueValues[index],
        saturationValues[index],
        brightnessValues[index]
      );
      
      sumPartsNow += parts[ii];
      rect(
        map(sumPartsNow, 0, sumPartsTotal, 0, width),
        rowHeight*i,
        map(parts[ii], 0, sumPartsTotal, 0, width)*-1,
        rowHeight
      );
      
      counter++;
    }
  }
  
  noLoop();
}

void mouseReleased(){
  loop();
}
