

// All GWindow element declarations for main window
GWindow mainWindow;
GButton webcamToggle1, webcamToggle2, webcamToggle3, webcamToggle4; 
GButton playButton, recordButton, openButton; 
GCustomSlider radialAreaSlider; 
GTextField bpmField;

int radialSpacing, radialAreaBorder;

// This method initializes all elements of the main screen
public void mainGUI() {

  // setup for main window
  mainWindow = GWindow.getWindow(this, "Main Screen", ((width - windowWidth) / 2), ((height - windowHeight) / 2), windowWidth, windowHeight, JAVA2D);
  mainWindow.setActionOnClose(G4P.EXIT_APP);
  mainWindow.setAlwaysOnTop(true);
  mainWindow.addDrawHandler(this, "mainWindowDraw");
  mainWindow.addMouseHandler(this, "mainWindowMouse");
  mainWindow.addKeyHandler(this, "mainWindowKey");
  mainWindow.addData(new mainWinData());

  G4P.messagesEnabled(false);   // disable messages on all G4P windows
  G4P.setGlobalColorScheme(9);  // Custom scheme

  // start camera
  cam = new Capture(mainWindow, 160, 120);
  cam.start();

  //Load in a sound files wihin a given folder
  radialsMinim = new Minim(mainWindow);

  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  audioIn = radialsMinim.getLineIn(Minim.STEREO, 2048);
  // get an output we can playback the recording on
  audioOut = radialsMinim.getLineOut(Minim.STEREO);  

  // set main window data
  ((mainWinData)mainWindow.data).username = ((introWinData)introWindow.data).username;
  ((mainWinData)mainWindow.data).bCameraOn = true;
  ((mainWinData)mainWindow.data).bRadialsLoaded = false;
  ((mainWinData)mainWindow.data).BPM = 60;
  
  println("entering the thing");
  makeRadialArray(mainWindow, findSoundFilesInDirectory(sketchPath() + "/data"));
  ((mainWinData)mainWindow.data).bRadialsLoaded = true;
  ((mainWinData)mainWindow.data).lastRadialPosX = radials[radials.length - 1].posX;

  // Button declarations and handlers
  webcamToggle1 = new GButton(mainWindow, 45, 270, 80, 30, "Toggle Webcam");
  webcamToggle1.addEventHandler(this, "handleWebcamToggle1");
  webcamToggle1.setFont(Baskerville16);
  webcamToggle2 = new GButton(mainWindow, 215, 270, 80, 30, "Toggle Webcam");
  webcamToggle2.addEventHandler(this, "handleWebcamToggle2");
  webcamToggle2.setFont(Baskerville16);
  webcamToggle3 = new GButton(mainWindow, 45, 433, 80, 30, "Toggle Webcam");
  webcamToggle3.addEventHandler(this, "handleWebcamToggle3");
  webcamToggle3.setFont(Baskerville16);
  webcamToggle4 = new GButton(mainWindow, 215, 433, 80, 30, "Toggle Webcam");
  webcamToggle4.addEventHandler(this, "handleWebcamToggle4");
  webcamToggle4.setFont(Baskerville16);

  playButton = new GButton(mainWindow, 861, 55, 100, 42, "PLAY");
  playButton.addEventHandler(this, "handlePlay");
  playButton.setFont(Baskerville16);
  recordButton = new GButton(mainWindow, 1016, 55, 100, 42, "RECORD");
  recordButton.addEventHandler(this, "handleRecord");
  recordButton.setFont(Baskerville16);
  openButton = new GButton(mainWindow, 1172, 55, 100, 42, "OPEN FILE");
  openButton.addEventHandler(this, "handleOpen");
  openButton.setFont(Baskerville16);

  // Slider declarations and handlers
  radialAreaSlider = new GCustomSlider(mainWindow, centerGControlX(mainWindow, 220), (mainWindow.height - 100), 220, 40, null);
  radialAreaSlider.setLimits(0.0f, 0.0f, 1.0f);
  radialAreaSlider.setNumberFormat(G4P.DECIMAL, 2);
  radialAreaSlider.setShowDecor(false, false, false, false); //show: opaque, ticks, value, limits
  radialAreaSlider.addEventHandler(this, "handleRadialAreaSlider");

  // Text field declarations and handlers
  bpmField = new GTextField(mainWindow, windowWidth - 150, 545, 100, 36);
  bpmField.addEventHandler(this, "handleBPMTextField");
  bpmField.setNumeric(1, 500, -1);
  bpmField.tag = "bpm";
  bpmField.setFont(Baskerville24);
  bpmField.setText(str(((mainWinData)mainWindow.data).BPM));

  // reused label from intro window resized and moved
  squiggle = new GLabel(mainWindow, 138, 32, 414, 88);
  squiggle.setTextAlign(GAlign.LEFT, null);
  squiggle.setFont(Baskerville64);
  squiggle.setText("SQUIGGLE.io");
  squiggle.setVisible(true); 
    
  //printRadialsData();
}


/* default method for drawing to G4P main window
 *
 * @param app:   name of G4P window (automatically applied)
 * @param data:  G4P window data (automatically applied)
 */
public void mainWindowDraw(PApplet app, GWinData data) {
  mainWinData mainData = (mainWinData)data;  

  mainHeaderGUI(app, data);

  // check if cam is avaiable for data
  try {
  updateMainCams(app, data);
  } catch (Exception e) {
    println("Exception: " + e + " when trying to update cams");
  }

  // draw radials
  if (mainData.bRadialsLoaded) {
    for (int i = 0; i < radials.length; i++) {
      radials[i].update();
      radials[i].display(180, NO_COLOR);
    }
  }
}

/* method for drawing the header for mainWindow
 *
 * @param app:   name of G4P window
 * @param data:  G4P window data
 */
void mainHeaderGUI(PApplet app, GWinData data) {
  // main background
  app.background(#E8F4F8);
  //load logo
  app.image(logo, 31, 26, 100, 100);
  // decided to display frame rate, just for shits
  app.fill(0);
  app.textSize(12);
  app.textAlign(RIGHT, TOP);
  app.text(frameRate, windowWidth - 10, 10);
}


/* method for updating webcam data to the G4P window
 *
 * @param app:   name of G4P window 
 * @param data:  G4P window data
 */
void updateMainCams(PApplet app, GWinData data) {
  mainWinData mainData = (mainWinData)data; 

  if (mainData.bCameraOn) {
    // if the webcam data is available to read, get read
    if (cam.available()) {
      cam.read();
    }
    app.set(45, 147, cam);
  } else {
    // if the webcam is toggled off, turn space black and display the username
    app.fill(50);
    app.rect(45, 147, cam.width, cam.height);
    app.fill(255);
    app.textSize(32);
    app.textAlign(CENTER, CENTER);
    // if the username is larger than 9 characters, display the first 6 and "..."
    if (mainData.username.length() > 9) {
      app.text(mainData.username.substring(0, 6) + "...", 45 + (cam.width / 2), 147 + (cam.height / 2));
    } else {
      app.text(mainData.username, 45 + (cam.width / 2), 147 + (cam.height / 2));
    }
  }
}

// method for later so we can do auto formatting
void setMainGUIValues() {
  radialSpacing = 20;
  radialAreaBorder = 20;
}
