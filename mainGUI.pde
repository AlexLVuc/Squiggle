

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

  G4P.messagesEnabled(false);   // disable messages on all G4P windows
  G4P.setGlobalColorScheme(9);  // Custom scheme

  cam = new Capture(mainWindow, 320, 240);
  cam.start();
  cameraOn = true;

  // Button declarations and handlers
  webcamToggle1 = new GButton(mainWindow, 20, 250, 80, 30, "Toggle Webcam");
  webcamToggle1.addEventHandler(this, "handleWebcamToggle1");
  webcamToggle1.setFont(Baskerville16);
  webcamToggle2 = new GButton(mainWindow, 260, 250, 80, 30, "Toggle Webcam");
  webcamToggle2.addEventHandler(this, "handleWebcamToggle2");
  webcamToggle2.setFont(Baskerville16);
  webcamToggle3 = new GButton(mainWindow, 20, 530, 80, 30, "Toggle Webcam");
  webcamToggle3.addEventHandler(this, "handleWebcamToggle3");
  webcamToggle3.setFont(Baskerville16);
  webcamToggle4 = new GButton(mainWindow, 260, 530, 80, 30, "Toggle Webcam");
  webcamToggle4.addEventHandler(this, "handleWebcamToggle4");
  webcamToggle4.setFont(Baskerville16);

  playButton = new GButton(mainWindow, 800, 30, 100, 50, "PLAY");
  playButton.addEventHandler(this, "handlePlay");
  playButton.setFont(Baskerville16);
  recordButton = new GButton(mainWindow, 920, 30, 100, 50, "RECORD");
  recordButton.addEventHandler(this, "handleRecord");
  recordButton.setFont(Baskerville16);
  openButton = new GButton(mainWindow, 1040, 30, 100, 50, "OPEN FILE");
  openButton.addEventHandler(this, "handleOpen");
  openButton.setFont(Baskerville16);

  // Slider declarations and handlers
  rpmSlider = new GCustomSlider(mainWindow, 850, 490, 220, 40, "grey_blue");
  rpmSlider.setLimits(0.5, 0.0, 1.0);
  rpmSlider.setNumberFormat(G4P.DECIMAL, 2);
  rpmSlider.setOpaque(false);
  rpmSlider.addEventHandler(this, "rpmSlider_change1");

  //Load in a sound files wihin a given folder
  radialsMinim = new Minim(mainWindow);
  makeRadialArray(mainWindow, findSoundFilesInDirectory(sketchPath() + "/data"));
  
}

public void mainWindowDraw(PApplet app, GWinData data) {
  MyWinData mainData = (MyWinData)data;  

  // check if cam is avaiable for data
  if (cam.available()) {
    app.background(#E8F4F8); // only update background if webcam is ready to update
    cam.read();
    app.set(10, 10, cam);
  }
  
  // draw radials
  for (int i = 0; i < radials.length; i++) {
    radials[i].update();
    radials[i].display(180, NO_COLOR);
  }
}
