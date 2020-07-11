

// All GWindow element declarations for main window
GWindow mainWindow;
GButton webcamToggle1, webcamToggle2, webcamToggle3, webcamToggle4; 
GButton playButton, recordButton, openButton; 
GCustomSlider rpmSlider; 

// This method initializes all elements of the main screen
public void mainGUI() {

  // setup for main window
  mainWindow = GWindow.getWindow(this, "Main Screen", ((width - windowWidth) / 2), ((height - windowHeight) / 2), windowWidth, windowHeight, JAVA2D);
  mainWindow.setActionOnClose(G4P.EXIT_APP);
  mainWindow.addDrawHandler(this, "mainWindowDraw");
  mainWindow.addMouseHandler(this, "mainWindowMouse");
  mainWindow.addKeyHandler(this, "mainWindowKey");
  mainWindow.addData(new mainWinData());

  G4P.messagesEnabled(false);   // disable messages on all G4P windows
  G4P.setGlobalColorScheme(9);  // Custom scheme

  cam = new Capture(mainWindow, 160, 120);
  cam.start();
  ((mainWinData)mainWindow.data).bCameraOn = true;

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
  rpmSlider = new GCustomSlider(mainWindow, 850, 490, 220, 40, "grey_blue");
  rpmSlider.setLimits(0.5, 0.0, 1.0);
  rpmSlider.setNumberFormat(G4P.DECIMAL, 2);
  rpmSlider.setOpaque(false);
  rpmSlider.addEventHandler(this, "rpmSlider_change1");

  squiggle = new GLabel(mainWindow, 138, 32, 414, 88);
  squiggle.setTextAlign(GAlign.LEFT, null);
  squiggle.setFont(Baskerville64);
  squiggle.setText("SQUIGGLE.io");
  squiggle.setVisible(true);

  //Load in a sound files wihin a given folder
  radialsMinim = new Minim(mainWindow);
  makeRadialArray(mainWindow, findSoundFilesInDirectory(sketchPath() + "/data"));
  
  String[] cams = Capture.list();
  if (cams.length != 0) {
    println("Available cameras: " + cams.length);
    for (int i = 0; i < cams.length; i++) {
      println("Name: " + cams[i]);
    }
  } else {
    println("No cams available");
  }
}

public void mainWindowDraw(PApplet app, GWinData data) {
  mainWinData mainData = (mainWinData)data;  
  app.background(#E8F4F8);

  // check if cam is avaiable for data
  updateMainCams(app, data);

  // draw radials
  for (int i = 0; i < radials.length; i++) {
    radials[i].update();
    radials[i].display(180, NO_COLOR);
  }
}

void mainHeaderGUI(PApplet app, GWinData data) {
  app.image(logo, 31, 26, 100, 100);
  // Line under logo
  app.strokeWeight(2);
  app.stroke(#69D2E7);
  app.line(315, 286, 315 + 711, 286);

  // decided to display frame rate, just for shits
  app.fill(0);
  app.text(frameRate, 20, 20);
}

void updateMainCams(PApplet app, GWinData data) {
  mainWinData mainData = (mainWinData)data; 

  if (mainData.bCameraOn) {
    // if the webcam data is available to read, get read
    if (cam.available()) {
      cam.read();
    }
    app.set(45, 147, cam);
  } else {
    app.fill(0);
    app.rect(45, 147, cam.width, cam.height);
  }
}
