
int WAV = 0;
int MP3 = 1;

class Radial {

  // constant value of the number of points to reduce a sound file to
  final int maxArraySize = 720;
  
  PApplet app;
  Minim radialMinim;
  AudioPlayer sound;
  int posX, posY, fileType;
  String name, fileName, filePath;
  float[] sampleArray, frequencyArray;

  /* Contructor for a radial object
   * 
   * @param Name:      name of radial file to eb displayed
   * @param FileName:  file name of sound file
   * @param posx:      x position of center of radial
   * @param posy:      y position of center of radial
   */
  Radial(PApplet app_, String name_, String fileName_, int fileType_, int posx_, int posy_) {
    app = app_;
    radialMinim = new Minim(app);
    name = name_;
    fileName = fileName_;
    fileType = fileType_;
    filePath = ""; //NEED TO CHANGE  
    if (!checkForArrayFile(fileName)) {
      createArrayFile(createSampleArray(), "s_");
      createArrayFile(createFrequencyArray(fileName), "f_");
    }
    sampleArray = createArrayFromFile("s_");
    frequencyArray = createArrayFromFile("f_");
    posX = posx_;
    posY = posy_;
    if (fileType == MP3) { 
      sound = radialMinim.loadFile(fileName + ".mp3");
    } else {
      sound = radialMinim.loadFile(fileName + ".wav");
    }
  }

  boolean checkForArrayFile(String filePath) {
    
    println("Array data files not found");
    return false;
  }

  /* method for creating a file containing float values of the radial
   *
   * @param array[]:   float array to be written to the file
   * @param filePath:  path of the file being written to (starting in the skecth folder)
   */
  void createArrayFile(float[] array, String filePrefix) {
    println("Creating array file at:\t" + sketchPath() + "data\\" + filePrefix + fileName + ".txt");
    PrintWriter output = createWriter("data\\" + filePrefix + fileName + ".txt");
    for (int i = 0; i < array.length; i++) {
      output.println(array[i]);
    }
    output.flush();
    output.close();
  }

  /* method for creating a float array from a txt file data
   *
   * @param filePath:  path of the file being written to (starting in the data folder)
   */
  float[] createArrayFromFile(String filePrefix) {
    println("Creating array from file at:\t" + sketchPath() + "data\\" + filePrefix + fileName + ".txt");
    float[] returnArray = new float[maxArraySize];

    // read the data from the specified file and convert to float array
    String[] fileData = loadStrings(filePrefix + fileName + ".txt");
    for (int i = 0; i < fileData.length; i++) {
      returnArray[i] = float(fileData[i]);
    }
    return returnArray;
  }
  
  /* method for displaying a radial
   *
   * @param displayPoints:  number of data points used in drawing the radial
   * @param colorScheme:    colorscheme for frequency data
   *
   * TODO: add mapping for color schemes
   */
  void display(int displayPoints, int colorScheme) {
    float r, x, y;
    float arrayMin = floor(min(sampleArray));
    float arrayMax = ceil(max(sampleArray));
    app.noFill();
    app.stroke(0);
    app.strokeWeight(2);
    app.beginShape(); 
    
    for (int i = 0; i < displayPoints; i++) {
      // map the radius of the point between the max and min values of the file, 
      // and the max and min display range
      r = map(sampleArray[i], arrayMin, arrayMax, minRadialDisplay, maxRadialDisplay);
      x = posX + (r * cos(radians(((360.0 / displayPoints) * i) - 90.0)));
      y = posY + (r * sin(radians(((360.0 / displayPoints) * i) - 90.0)));
      
      // if this is the first point, add an extra vertex handle
      if (i == 0) {
        app.curveVertex(x, y);
      }
      // if we are at the end, make the final point the same as the first point
      if (i == (displayPoints - 1)) {
        r = map(sampleArray[0], arrayMin, arrayMax, minRadialDisplay, maxRadialDisplay);
        x = posX + (r * cos(radians(-90)));
        y = posY + (r * sin(radians(-90)));
        app.curveVertex(x, y);
      }
      app.curveVertex(x, y);
    }
    app.endShape();
  }

  // method for reducing the samples in an mp3 or wav file to 720 values
  float[] createSampleArray() {
    float[] reducedSamples = new float[maxArraySize];
    println("Loading sample from:\t" + sketchPath() + "\\data\\" + fileName);
    // load in the audio file as a sample
    AudioSample tempSample;
    if (fileType == MP3) {     
      tempSample = radialMinim.loadSample(fileName + ".mp3");
    } else {
      tempSample = radialMinim.loadSample(fileName + ".wav");
    }

    // If the file only has a mono track, then you only need one array of values
    // If the file has stereo audio, take both channels and average the values from both
    float[] leftSamples = tempSample.getChannel(AudioSample.LEFT);
    float[] summedSamples = new float[leftSamples.length];
    if (tempSample.type() == 1) {
      for (int i = 0; i < leftSamples.length; i++) {
        summedSamples[i] = leftSamples[i];
      }
    } else {
      float[] rightSamples = tempSample.getChannel(AudioSample.RIGHT);
      for (int i = 0; i < leftSamples.length; i++) {
        summedSamples[i] = leftSamples[i] + rightSamples[i];
      }
    }

    // Reduce the summedSamples to arraySize by taking the average of the samples over the reducing factor
    float totalSamples = leftSamples.length;
    float reducingFactor = totalSamples / float(maxArraySize);
    float average = 0;
    int curArraySpot = 0;

    for (int i = 0; i < summedSamples.length; i++) {
      average += summedSamples[i];
      if ( i % int(reducingFactor) == 0 && i!=0) {  //Must cast reducing factor to int to make math work
        reducedSamples[curArraySpot] = average / reducingFactor;
        curArraySpot++;
        average = 0;
        if (curArraySpot == maxArraySize - 1) break;
      }
    }

    return reducedSamples;
  }
  
  float[] createFrequencyArray (String fileName) {
    float[] temp = new float[maxArraySize];
    return temp;
  }
} 
