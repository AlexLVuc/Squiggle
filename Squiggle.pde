import g4p_controls.*;
import processing.video.*;

// for FFT
import ddf.minim.*; 
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

// for saving to clipboard
import java.awt.*;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Clipboard;

// for MP3 and WAV file saving
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

Minim radialsMinim;
Minim mainMinim;
PImage logo;


int introButW = 411; 
int introButH = 68;

Capture cam;
boolean cameraOn;

Font Baskerville64, Baskerville24, Baskerville22, Baskerville16;

int windowWidth, windowHeight;
int maxRadialDisplay = 50;
int minRadialDisplay = 10;

Radial[] radials;

void setup() {
  // set the defualt window insisible
  fullScreen();
  surface.setVisible(false); 
  
  // anti-aliasing to [input number]x
  // onlny used for P3D or P2D renderers
  smooth(2);
  
  // set maximum fram rate to 120
  // I need to do this to display the framerate
  frameRate(120);
  windowWidth = 1280;
  windowHeight = 1080;
  
  // really not sure if we need this. I think we only need one minim per window, but I have each Radial having its own minim, 
  // so who knows
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
