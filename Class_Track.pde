/* 
 * Class made for creating, saving and handling tracks
 * Creator: Michael Jamieson
 * Date: July 14, 2020
 */

class Track {

  PApplet app;
  ArrayList<Radial> trackRadials;  // list of radials in a track
  int posX, posY, w, h, trackLength, numOfTimeStamps;
  boolean bPlaying;
  int startOfPlay = 0;
  float trackPos = 0;
  float[] timeStamps;


  /* Contructor for a Track object
   * 
   * @param app_:  PApplet (or window) the Track exists on
   * @param x:     x position of top left of track
   * @param y:     y position of top left of track
   * @param w_:    width of track
   * @param h_:    height of track
   */
  Track(PApplet app_, int x, int y, int w_, int h_) {
    app = app_;
    posX = x;
    posY = y;
    w = w_;
    h = h_;

    trackRadials = new ArrayList<Radial>();
    trackLength = 10 * 1000; // 10 seconds default, represented in ms
    numOfTimeStamps = 5;
    bPlaying = false;
    
    timeStamps = new float[numOfTimeStamps];
    float temp = trackLength / (numOfTimeStamps + 1);
    for (int i = 0; i < numOfTimeStamps; i++) {
      timeStamps[i] = temp * (i + 1);
    }

    
  }


  /* method for adding a Radial to a track
   *
   * @param r:  Radial to be added
   */
  void addRadial(Radial r) {
    Radial nR = new Radial(r.app, r.name, r.fileName, r.fileType, r.curPosX, r.curPosY, r.others, true);
    for (int i = 0; i < r.maxArraySize; i++) {
      nR.sampleArray[i] = r.sampleArray[i];
      nR.frequencyArray[i] = r.frequencyArray[i];
    }
    nR.BPM = r.BPM;
    nR.rateControl.value.setLastValue(r.curRC);
    trackRadials.add(nR);
  }

  /* method for updating Track data
   * check for whether the track is playing
   * check if Radials within a track should be playing
   */
  void update() {
    if (bPlaying) {
      // check if end of track has been reached
      if ((millis() - startOfPlay) >= trackLength) {
        bPlaying = false;
        println("stopped playing");
      } else {
        // check if any Radial should be playing
        for (int i = trackRadials.size() - 1; i >= 0; i--) {
          if (int(trackPos) == trackRadials.get(i).curPosX) {
            trackRadials.get(i).play();
          }
        }
      }
    }
  }

  /* method for displaying all Track info
   *
   * @param displayPoints:  number of data points used in drawing each Radial
   * @param colorScheme:    colorscheme for Each Radial
   */
  void display(int displayPoints, int colorScheme) {
    app.stroke(1);
    app.noFill();
    app.rect(posX, posY, w, h);
    
    drawTrackTimeStamps();

    try {
      for (int i = trackRadials.size() - 1; i >= 0; i--) {
        trackRadials.get(i).update();
        trackRadials.get(i).display(displayPoints, colorScheme);
      }
    } 
    catch (Exception e) {
      println("Exception: " + e);
    }

    if (bPlaying) {
      drawTrackPosition();
    }
  }
  
  void drawTrackTimeStamps() {
    float spacing = w / (numOfTimeStamps + 1);
    for (int i = 0; i < timeStamps.length; i++) {
      float tempX = (posX + (spacing * (i + 1)));
      app.textSize(10);
      app.textAlign(CENTER);
      app.fill(0);
      app.text(nf(timeStamps[i] / 1000, 0, 1) + "s", tempX, posY + h + 13);
      
      app.strokeWeight(2);
      app.stroke(200);
      app.line(tempX, posY, tempX, posY + h);
    }
    
  }
  
  // method for drawing the position within a track 
  void drawTrackPosition() {
    trackPos = map(millis() - startOfPlay, 0, trackLength, posX, posX + w);
    app.stroke(0, 200, 0);
    app.strokeWeight(1);
    app.line(trackPos, posY, trackPos, posY + h);
  }

  /* method for checking if mouse is over the track
   *
   * @param x:  x position of mouse
   * @param y:    y position of mouse
   */
  boolean overTrack(int x, int y) {
    if (x >= posX && x <= (posX + w) && y >= posY && y <= (posY + h)) {
      return true;
    } else {
      return false;
    }
  }
}
