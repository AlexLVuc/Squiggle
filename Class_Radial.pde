/*
 * Class made creating, saving and handling radials
 * Creator: Michael Jamieson
 * Date: July 7, 2020
 */

public final int timeToClick = 80;

// file type declarations
public final int WAV = 0;
public final int MP3 = 1;

// color declarations for displaying Radial
public final int NO_COLOR = 0;
public final int COLOR = 1;
public final int DEUTERANOMLAY = 2;
public final int PROTANOMLAY = 3;
public final int PROTANOPIA = 4;
public final int TRITANOMALY = 5;
public final int TRITANOPIA = 6;

class Radial {

  // constant value of the number of points to reduce a sound file to
  final int maxArraySize = 720;

  PApplet app;
  Minim radialMinim;
  AudioPlayer sound;
  String name, fileName, filePath;
  int posX, posY, fileType, soundLength;
  float[] sampleArray, frequencyArray;
  Radial[] others;

  boolean bOverHandle = false;
  boolean bPressHandle = false;
  boolean bActiveHandle = false;
  boolean bOtherActiveHandle = false;
  boolean bFirstTimeValue = false;
  float lastHandlePressTime = 0;
  int handleRadius = maxRadialDisplay;

  /* Contructor for a radial object
   * 
   * @param app_:       PApplet (or window) the Radial exists on
   * @param name_:      name of radial file to eb displayed
   * @param fileName_:  file name of sound file
   * @param fileType_:  file type of sound file
   * @param posx_:      x position of center of radial
   * @param posy_:      y position of center of radial
   */
  Radial(PApplet app_, String name_, String fileName_, int fileType_, int posx_, int posy_, Radial[] others_) {
    app = app_;
    name = name_;
    fileName = fileName_;
    fileType = fileType_;
    posX = posx_;
    posY = posy_;
    filePath = ""; //NEED TO CHANGE
    others = others_;

    // NOT SURE IF NEEDED
    radialMinim = new Minim(app);

    // check for data array files
    if (!checkForArrayFile("_s")) {
      createArrayFile(createSampleArray(), "_s");
    }
    if (!checkForArrayFile("_f")) {
      createArrayFile(createFrequencyArray(), "_f");
    }
    sampleArray = createArrayFromFile("_s");
    frequencyArray = createArrayFromFile("_f");

    // load the correct file type into the player
    if (fileType == MP3) { 
      sound = radialMinim.loadFile(fileName + ".mp3");
    } else {
      sound = radialMinim.loadFile(fileName + ".wav");
    }

    // AudioSample.length() does not equal AudioSample.position() at the end of the sound,
    // so we work around it
    sound.cue(sound.length());
    soundLength = sound.position();
  }

  /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   *
   *  METHODS FOR RADIAL FILES
   *
   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   */

  /* method for checkign whether an array data file exists
   *
   * @param fileSuffix:  suffix of the file being written to
   */
  boolean checkForArrayFile(String fileSuffix) {
    File f = new File(sketchPath() + "/data/" + fileName + fileSuffix + ".txt");
    if (f.exists()) {
      println(fileName + fileSuffix + ".txt found");
      return true;
    } else {
      println(fileName + fileSuffix + ".txt not found");
      return false;
    }
  }

  /* method for creating a file containing float values of the radial
   *
   * @param array[]:   float array to be written to the file
   * @param filePath:  path of the file being written to (starting in the skecth folder)
   */
  void createArrayFile(float[] array, String fileSuffix) {
    println("Creating array file at:\t" + sketchPath() + "data\\" + fileName + fileSuffix + ".txt");
    PrintWriter output = createWriter("data\\" + fileName + fileSuffix + ".txt");
    for (int i = 0; i < array.length; i++) {
      output.println(array[i]);
    }
    output.flush();
    output.close();
  }

  /* method for creating a file containing float values of the radial
   *
   * @param array[]:   int array to be written to the file
   * @param filePath:  path of the file being written to (starting in the skecth folder)
   */
  void createArrayFile(int[] array, String fileSuffix) {
    println("Creating array file at:\t" + sketchPath() + "data\\" + fileName + fileSuffix + ".txt");
    PrintWriter output = createWriter("data\\" + fileName + fileSuffix + ".txt");
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
  float[] createArrayFromFile(String fileSuffix) {
    println("Creating array from file at:\t" + sketchPath() + "data\\" + fileName + fileSuffix + ".txt");
    float[] returnArray = new float[maxArraySize];

    // read the data from the specified file and convert to float array
    String[] fileData = loadStrings(fileName + fileSuffix + ".txt");
    for (int i = 0; i < fileData.length; i++) {
      returnArray[i] = float(fileData[i]);
    }
    return returnArray;
  }

  // method for reducing the samples in an mp3 or wav file to 720 values
  float[] createSampleArray() {
    float[] reducedSamples = new float[maxArraySize];

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

  // method for reducing the samples in an mp3 or wav file to 720 values
  int[] createFrequencyArray () {
    int[] frequencyArray = new int[maxArraySize];
    int maxBand = 0;

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

    // choose the number of samples to analyze per chunk
    // !!MUST BE A POWER OF 2!!
    int fftSize = 1024;
    float[] fftSamples = new float[fftSize];

    // the number of analysis' that will be done
    int totalChunks = (summedSamples.length / fftSize);
    int[] fftValues = new int[totalChunks];

    FFT fft = new FFT(fftSize, tempSample.sampleRate());

    println("summedSamples size: " + summedSamples.length);
    for (int i = 0; i < totalChunks; i++) {
      int curChunkIndex = i * fftSize;

      // if we are at the end of the samples we might not have enough 
      // sample values to fill an analysis array
      int chunkSize = min((summedSamples.length - curChunkIndex), fftSize);

      // copy chunk into our analysis array
      // copy fftSize samples from summedSamples from curChunkIndex to fftSamples starting at position 0 
      println("index: " + curChunkIndex + "\tfftSize: " + fftSize);
      System.arraycopy( summedSamples, curChunkIndex, fftSamples, 0, fftSize);

      // if the chunk was smaller than the fftSize, we need to pad the analysis buffer with zeroes        
      if ( chunkSize < fftSize ) {
        java.util.Arrays.fill( fftSamples, chunkSize, fftSamples.length - 1, 0.0 );
      }

      // analyze the array
      fft.forward(fftSamples);

      // find the max value of the fft
      for (int j = 0; j < (fftSize / 2); j++) {
        if (fft.getBand(j) > fft.getBand(maxBand)) {
          maxBand = j;
        }
      }
      fftValues[i] = maxBand;
      maxBand = 0;
    }

    // find the ratio between the number of chunks analyzed and 720
    float scalingFactor = float(totalChunks) / float(maxArraySize);

    // fill the final array
    for (int i = 0; i < maxArraySize; i++) {
      frequencyArray[i] = fftValues[int(i * scalingFactor)];
    }
    return frequencyArray;
  }

  /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   *
   *  METHODS FOR DRAWING AND 
   *  INTERACTING WITH RADIAL
   *
   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   */

  /* method for creating a float array from a txt file data
   *
   * @param n:  number of points used to display the Radial
   * @param c:  color scheme used to display the Radial
   */
  void display(int n, int c) {
    if (n > 720) {
      n = 720;
    }
    drawRadial(n, c);
    if (bOverHandle || bPressHandle) {
      app.noFill();
      app.stroke(0);
      app.circle(posX, posY, handleRadius*2);
    }
    if (sound.isPlaying()) {
      drawRadialPosition();
    }
  }

  /* method for updating Radial data
   * check for whether the handle has been hovered or clicked
   * update the x and y of the Radial while the handle is pressed
   */
  void update() {   
    // go through all other Radials in the array to see if any are active
    for (int i = 0; i < others.length; i++) {
      if (others[i].bActiveHandle) {
        bOtherActiveHandle = true;
        break;
      } else {
        bOtherActiveHandle = false;
      }
    }

    // if there are no other active handles, run updates 
    if (!bOtherActiveHandle) {
      overHandleEvent();
      pressHandleEvent();
    }

    if (bPressHandle) {
      // dont't update the postition until we are sure they arent trying to play the Radial sound      
      if ((millis() - lastHandlePressTime) > timeToClick) {
        // update the center draw position to a position on the screen
        posX = keepOnScreen(app.mouseX, handleRadius, (windowWidth - handleRadius));
        posY = keepOnScreen(app.mouseY, handleRadius, (windowHeight - handleRadius));
      }
    }
  }

  /* method for displaying a radial
   *
   * @param displayPoints:  number of data points used in drawing the radial
   * @param colorScheme:    colorscheme for frequency data
   *
   * TODO: add mapping for color schemes
   */
  void drawRadial(int displayPoints, int colorScheme) {
    float rc, gc, bc;
    float r, x, y;
    float arrayMin = floor(min(sampleArray));
    float arrayMax = ceil(max(sampleArray));
    app.noFill();
    app.strokeWeight(2);
    app.beginShape(); 

    for (int pPos = 0; pPos < displayPoints; pPos++) {
      if (colorScheme == 0) {
        rc = 0;
        gc = 0;
        bc = 0;
      } 
      else if (colorScheme == 1) {
        rc = map(frequencyArray[pPos], 0, 512, 0, 85);
        gc = map(frequencyArray[pPos], 0, 512, 86, 170);
        bc = map(frequencyArray[pPos], 0, 512, 171, 255);
      }  else {
        rc = 0;
        gc = 0;
        bc = 0;
      }
      app.stroke(rc, gc, bc);
      // map the radius of the point between the max and min values of the file, 
      // and the max and min display range
      r = map(sampleArray[pPos], arrayMin, arrayMax, minRadialDisplay, maxRadialDisplay);
      x = posX + (r * cos(radians(((360.0 / displayPoints) * pPos) - 90.0)));
      y = posY + (r * sin(radians(((360.0 / displayPoints) * pPos) - 90.0)));

      // if this is the first point, add an extra vertex handle
      if (pPos == 0) {
        app.curveVertex(x, y);
      }
      // if we are at the end, make the final point the same as the first point
      if (pPos == (displayPoints - 1)) {
        r = map(sampleArray[0], arrayMin, arrayMax, minRadialDisplay, maxRadialDisplay);
        x = posX + (r * cos(radians(-90)));
        y = posY + (r * sin(radians(-90)));
        app.curveVertex(x, y);
      }
      app.curveVertex(x, y);
    }
    app.endShape();
  }

  // method for drawing the position of the player on the Radial
  void drawRadialPosition() { 
    float pos = map(sound.position(), 0, soundLength, 0, maxArraySize);
    float x2 = posX + (handleRadius * cos(radians(((360.0 / maxArraySize) * pos) - 90)));
    float y2 = posY + (handleRadius * sin(radians(((360.0 / maxArraySize) * pos) - 90)));
    app.stroke(0, 200, 0);
    app.strokeWeight(1);
    app.line(posX, posY, x2, y2);
  }

  // event method for handling if the mouse is over the handle
  void overHandleEvent() {
    if (overHandle()) {
      bOverHandle = true;
    } else {
      bOverHandle = false;
    }
  }

  // event method for handling if the handle is pressed
  void pressHandleEvent() {
    if (bOverHandle && app.mousePressed || bActiveHandle) {
      bPressHandle = true;
      bActiveHandle = true;
      if (!bFirstTimeValue) {   
        lastHandlePressTime = millis();
        bFirstTimeValue = true;
      }
    } else {
      bPressHandle = false;
    }
  }

  // method for handling if the handle has been released
  void releaseHandleEvent() {
    bActiveHandle = false;

    // if the Radial was clicked instead of held play the sound
    if ((millis() - lastHandlePressTime) < timeToClick) {
      if (sound.isPlaying()) {
        pause();
      } else {
        play();
      }
    }
    bFirstTimeValue = false;
  }

  // method for checking if mouse position is over the handle
  boolean overHandle() {
    if (sqrt(sq(app.mouseX - posX) + sq(app.mouseY - posY)) <= handleRadius) {
      return true;
    } else {
      return false;
    }
  }

  // method for keeping the handle on screen as its being dragged
  int keepOnScreen(int mousePos, int minPos, int maxPos) { 
    return  min(max(mousePos, minPos), maxPos);
  }


  /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   *
   *  METHODS FOR PLAYING RADIAL SOUND
   *
   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   */

  // play the sound
  void play() {
    sound.play(0);
  }

  //pause the sound
  void pause() {
    sound.pause();
  }
} 
