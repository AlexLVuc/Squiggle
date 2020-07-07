import g4p_controls.*;
import ddf.minim.*; 
import ddf.minim.analysis.*;

import java.awt.*;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Clipboard;

FFT fft;

// All GWindow element declarations
GWindow introWindow;
GButton joinSession, createSession, takeATour, clipboard, play, back;
GTextField roomCodeField, nameField;
GLabel squiggle, roomCodeLabel, nameLabel;

PImage logo;
Font Baskerville64, Baskerville24, Baskerville22, Baskerville16;
int windowWidth, windowHeight;

int maxRadialDisplay = 200;
int minRadialDisplay = 40;

Radial shaker;

void setup() {
  fullScreen();
  surface.setVisible(false);
  windowWidth = 1280;
  windowHeight = 1080;
  introGUI();

}


void draw() {
  shaker.display(720, 1);
}


class MyWinData extends GWinData {
  boolean bJoin, bCreate, bTour; //, bHoveringClipboard;
  int butWidth;
  String sessionPassword;
}

/*String[] getStringArray(float[] array) {
  String[] stringa = new String[array.length];
  for(int i=0; i<array.length; i++){
    stringa[i] = String.valueOf(array[i]);
  }
  return stringa;
}*/
