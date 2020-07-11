/*
 * Default and custom handlers for G4P intro window elements
 * Creator: Michael Jamieson
 * Date: July 4, 2020
 */

public void introWindowMouse(PApplet app, GWinData data, MouseEvent event) {
  introWinData introData = (introWinData)data;
}

public void introWindowKey(PApplet app, GWinData data, KeyEvent event) {
  introWinData introData = (introWinData)data;
}

public void handleBtnJoinSession(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    ((introWinData)introWindow.data).bJoin = true;
  }
}

public void handleBtnCreateSession(GButton button, GEvent event) { 
  if (event == GEvent.CLICKED) {
    ((introWinData)introWindow.data).bCreate = true;
  }
}

public void handleBtnTakeATour(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    ((introWinData)introWindow.data).bTour = true;
  }
}

public void handleBtnClipboard (GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    StringSelection selection = new StringSelection(((introWinData)introWindow.data).sessionPassword);
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    clipboard.setContents(selection, selection);
  }
}

public void handleBtnPlay (GButton button, GEvent event) {
  introWindow.close();
  mainGUI();
}

public void handleBtnBack (GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    if (((introWinData)introWindow.data).bJoin || ((introWinData)introWindow.data).bCreate) {
      //
      ((introWinData)introWindow.data).bJoin = false;
      ((introWinData)introWindow.data).bCreate = false;
      ((introWinData)introWindow.data).sessionPassword = null;
      
      // Hide text fields, labels and buttons from join or create screen
      roomCodeLabel.setVisible(false);
      roomCodeField.setVisible(false);
      nameLabel.setVisible(false);
      nameField.setVisible(false);
      play.setVisible(false);
      back.setVisible(false);
      clipboard.setVisible(false);
      
      // added to fix error of user clicking "join session" after first clicking "create session"
      // and having the password already in the text field
      roomCodeField.setText("");  
    }
  }
}
