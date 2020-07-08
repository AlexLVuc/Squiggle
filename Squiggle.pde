import g4p_controls.*;
import ddf.minim.*; 
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

// for saving to clipboard
import java.awt.*;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Clipboard;

//For MP3 and WAV file saving
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.io.BufferedWriter;

// objects for getting audio from mic and speakers
AudioInput audioIn;
AudioRecorder recorder;
AudioOutput audioOut;
AudioPlayer recording;

Minim mainMinim;
PImage logo;

// All GWindow element declarations for intro window
GWindow introWindow;
GButton joinSession, createSession, takeATour, clipboard, play, back;
GTextField roomCodeField, nameField;
GLabel squiggle, roomCodeLabel, nameLabel;

Font Baskerville64, Baskerville24, Baskerville22, Baskerville16;

int windowWidth, windowHeight;
int maxRadialDisplay = 100;
int minRadialDisplay = 20;

Radial[] radials;

void setup() {
  fullScreen();
  surface.setVisible(false);  
  windowWidth = 1280;
  windowHeight = 1080;
  
  mainMinim = new Minim(this);
  
  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  audioIn = mainMinim.getLineIn(Minim.STEREO, 2048);
  // get an output we can playback the recording on
  audioOut = mainMinim.getLineOut(Minim.STEREO);
  
  introGUI();

}


void draw() {
    
}


class MyWinData extends GWinData {
  boolean bJoin, bCreate, bTour;
  int butWidth;
  String sessionPassword;
}
