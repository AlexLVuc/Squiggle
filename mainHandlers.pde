
public void mainWindowMouse(PApplet app, GWinData data, MouseEvent event) {
  MyWinData mainData = (MyWinData)data;
  
  // once the mouse is released, make all Radial handles inactive
  if (event.getAction() == MouseEvent.RELEASE) {
    for (int i = 0; i < radials.length; i++) {
      radials[i].releaseHandleEvent();
    }
  }  
}

public void mainWindowKey(PApplet app, GWinData data, KeyEvent event) {
  MyWinData mainData = (MyWinData)data;
}


public void handleWebcamToggle1(GButton button, GEvent event) {
  println("webcamToggle1 - GButton >> GEvent." + event + " @ " + millis());
  if (cameraOn){
    cam.stop();
    cameraOn = false;
  }
  else {
    cam.start();
    cameraOn = true;
  }
} 

public void handleWebcamToggle2(GButton button, GEvent event) { 
  println("webcamToggle2 - GButton >> GEvent." + event + " @ " + millis());
} 

public void handleWebcamToggle3(GButton button, GEvent event) { 
  println("webcamToggle3 - GButton >> GEvent." + event + " @ " + millis());
} 

public void handleWebcamToggle4(GButton button, GEvent event) { 
  println("webcamToggle4 - GButton >> GEvent." + event + " @ " + millis());
} 

public void handlePlay(GButton button, GEvent event) {
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
}

public void handleRecord(GButton button, GEvent event) { 
  println("recordButton - GButton >> GEvent." + event + " @ " + millis());
} 

public void handleOpen(GButton button, GEvent event) { 
  println("openButton - GButton >> GEvent." + event + " @ " + millis());
} 

public void rpmSlider_change1(GCustomSlider source, GEvent event) { 
  println("custom_slider1 - GCustomSlider >> GEvent." + event + " @ " + millis());
} 
