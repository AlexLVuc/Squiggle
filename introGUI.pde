/*
 * Methods for drawing to the intro window
 * Creator: Michael Jamieson
 * Date: July 4, 2020
 */

//This method initializes all elemts of the intro screen
public void introGUI() {
  //Load in logo png from data folder  
  logo = loadImage("Squiggle_Logo.png");

  // Bring in required fonts for intro window
  Baskerville64 = getFont("fonts/BASKVILL.TTF", Font.PLAIN, 64);
  Baskerville24 = getFont("fonts/BASKVILL.TTF", Font.PLAIN, 24);
  Baskerville22 = getFont("fonts/BASKVILL.TTF", Font.PLAIN, 22);
  Baskerville16 = getFont("fonts/BASKVILL.TTF", Font.PLAIN, 16);

  G4P.setCtrlMode(GControlMode.CORNER);  //Set dimensioning to x1, y1, w, h
  G4P.setGlobalColorScheme(9);  // Custom scheme

  //Setup for the intro window
  //introWindow = GWindow.getWindow(this, "Intro Screen", ((width - windowWidth) / 2), ((height - windowHeight) / 2), windowWidth, windowHeight, JAVA2D);
  introWindow = GWindow.getWindow(this, "Intro Screen", 0, 0, width, height, JAVA2D);
  introWindow.setActionOnClose(G4P.CLOSE_WINDOW);
  introWindow.setAlwaysOnTop(true);
  introWindow.addDrawHandler(this, "introWindowDraw");
  introWindow.addMouseHandler(this, "introWindowMouse");
  introWindow.addKeyHandler(this, "introWindowKey");
  introWindow.addData(new MyWinData());
  ((MyWinData)introWindow.data).bJoin = false;
  ((MyWinData)introWindow.data).bCreate = false;
  ((MyWinData)introWindow.data).bTour = false;
  ((MyWinData)introWindow.data).sessionPassword = null;

  // Button declarations and handlers
  joinSession = new GButton(introWindow, centerGControlX(introWindow, introButW), 315, introButW, introButH, "Join Session");
  joinSession.addEventHandler(this, "handleBtnJoinSession");
  joinSession.setFont(Baskerville24);
  createSession = new GButton(introWindow, centerGControlX(introWindow, introButW), 411, introButW, introButH, "Create Session");
  createSession.addEventHandler(this, "handleBtnCreateSession");
  createSession.setFont(Baskerville24);
  takeATour = new GButton(introWindow, centerGControlX(introWindow, introButW), 507, introButW, introButH, "Take a Tour");
  takeATour.addEventHandler(this, "handleBtnTakeATour");
  takeATour.setFont(Baskerville24);
  clipboard = new GButton(introWindow, 842, 354, 189, 27, "Copy to Clipboard");
  clipboard.addEventHandler(this, "handleBtnClipboard");
  clipboard.setFont(Baskerville16);
  clipboard.setVisible(false);
  play = new GButton(introWindow, 631, 499, 101, 41, "PLAY");
  play.addEventHandler(this, "handleBtnPlay");
  play.setFont(Baskerville16);
  play.setVisible(false);
  back = new GButton(introWindow, 10, 10, 80, 30, "BACK");
  back.addEventHandler(this, "handleBtnBack");
  back.setFont(Baskerville16);
  back.setVisible(false);

  // Text field declarations
  roomCodeField = new GTextField(introWindow, 528, 348, 304, 40);
  roomCodeField.tag = "roomCode";
  roomCodeField.setFont(Baskerville24);
  roomCodeField.setPromptText("Input Room Code");
  roomCodeField.setVisible(false);
  nameField = new GTextField(introWindow, 528, 443, 304, 40);
  nameField.tag = "name";
  nameField.setFont(Baskerville24);
  nameField.setPromptText("Input Your Name");
  nameField.setVisible(false);

  // Label declarations
  squiggle = new GLabel(introWindow, 512, 184, 414, 88);
  squiggle.setTextAlign(GAlign.LEFT, null);
  squiggle.setFont(Baskerville64);
  squiggle.setText("SQUIGGLE.io");
  roomCodeLabel = new GLabel(introWindow, 502, 302, 141, 34);
  roomCodeLabel.setTextAlign(GAlign.LEFT, null);
  roomCodeLabel.setFont(Baskerville22);
  roomCodeLabel.setText("Room Code");
  roomCodeLabel.setVisible(false);
  nameLabel = new GLabel(introWindow, 502, 401, 70, 34);
  nameLabel.setTextAlign(GAlign.LEFT, null);
  nameLabel.setFont(Baskerville22);
  nameLabel.setText("Name");
  nameLabel.setVisible(false);


  //Load in a sound files wihin a given folder
  makeRadialArray(introWindow, findSoundFilesInDirectory(sketchPath() + "/data"));
  
}

/* default method for drawing to G4P intro window
 *
 * @param app:   name of G4P window (automatically applied)
 * @param data:  G4P window data (automatically applied)
 */
public void introWindowDraw(PApplet app, GWinData data) {
  MyWinData introData = (MyWinData)data;
  introHeaderGUI(app, data); 

  if (introData.bJoin) {
    introJoinSessionGUI(app, data);
  } 
  else if (introData.bCreate) {
    introCreateSessionGUI(app, data);
  } 
  else if (introData.bTour) {
  } 
}

/* method for drawing the header of the intro window
 * this includes: logo, name, and underline
 *
 * @param app:   name of G4P window (automatically applied)
 * @param data:  G4P window data (automatically applied)
 */
void introHeaderGUI(PApplet app, GWinData data) {
  MyWinData introData = (MyWinData)data;
  //background color
  app.background(#E8F4F8);
  // Logo
  app.image(logo, 405, 178, 100, 100);
  // Line under logo
  app.strokeWeight(2);
  app.stroke(#69D2E7);
  app.line(315, 286, 315 + 711, 286);

  // decided to display frame rate, just for shits
  app.fill(0);
  app.text(frameRate, 20, 20);
}

/* method for drawing the main intro window
 *
 * @param app:   name of G4P window (automatically applied)
 * @param data:  G4P window data (automatically applied)
 */
void introMainGUI(PApplet app, GWinData data) {
  MyWinData introData = (MyWinData)data;

  // Make buttons from main screen visible
  joinSession.setVisible(true);
  createSession.setVisible(true);
  takeATour.setVisible(true);  

  roomCodeLabel.setVisible(false);
  roomCodeField.setVisible(false);
  nameLabel.setVisible(false);
  nameField.setVisible(false);
  play.setVisible(false);
  back.setVisible(false);
  clipboard.setVisible(false);
}

/* method for drawing the join session screen of the intro window
 *
 * @param app:   name of G4P window (automatically applied)
 * @param data:  G4P window data (automatically applied)
 */
void introJoinSessionGUI(PApplet app, GWinData data) {
  MyWinData introData = (MyWinData)data;

  // Hide buttons from main screen
  joinSession.setVisible(false);
  createSession.setVisible(false);
  takeATour.setVisible(false);

  // Make text fields, labels and buttons visible
  roomCodeLabel.setVisible(true);
  roomCodeField.setVisible(true);
  nameLabel.setVisible(true);
  nameField.setVisible(true);
  play.setVisible(true);
  back.setVisible(true);
}

/* method for drawing the create session screen of the intro window
 *
 * @param app:   name of G4P window (automatically applied)
 * @param data:  G4P window data (automatically applied)
 */
void introCreateSessionGUI(PApplet app, GWinData data) {
  MyWinData introData = (MyWinData)data;

  // Hide buttons from main screen
  joinSession.setVisible(false);
  createSession.setVisible(false);
  takeATour.setVisible(false);

  // Make text fields, labels and buttons visible
  roomCodeLabel.setVisible(true);
  roomCodeField.setVisible(true);
  nameLabel.setVisible(true);
  nameField.setVisible(true);
  play.setVisible(true);
  back.setVisible(true);
  clipboard.setVisible(true);

  // If a room code has not been made, make one and save it to the window data
  if (((MyWinData)introWindow.data).sessionPassword == null)  ((MyWinData)introWindow.data).sessionPassword = makeSessionPassword();

  // Add room code into text field
  roomCodeField.setText(((MyWinData)introWindow.data).sessionPassword);
  
  
}
