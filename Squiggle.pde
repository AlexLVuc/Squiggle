import g4p_controls.*;
import ddf.minim.*; 
import ddf.minim.analysis.*; 
Minim minim;  //Used for audio sampling
AudioSample sample;  //Also used for audio sampling??
AudioPlayer player;
FFT fft;

int maxRadialDisplay = 200;
int minRadialDisplay = 40;
/*SUBJECT TO CHANGE
 *Choose a maximum number of samples for a file so that displaying 
 *the waveforms can be standardized
 */
int maxSamples = 720;
int numOfCurvePoints = 720;
float[] reducedSamples = new float[maxSamples];
float[] reducedFrequency = new float[maxSamples];
float[] sampleSpectrum = new float[1024];
float[] positionArray = new float[100000];
int pos = 0;

float curvePointsScalingFactor = float(maxSamples) / float(numOfCurvePoints);
int maxBand = 0;
int spectrumPos = 0;
boolean FFTcomplete = false;

/*SUBJECT TO CHANGE:
 *  
 */
int bord = 50;
int amplitudeScalingFactor = 200;
float rectWidth;
float waveFormCenterX;
float waveFormCenterY;
float shift = 40;

int buttonSize = 20;
int curveButtonDownX, curveButtonUpX;
int curveButtonDownY, curveButtonUpY, curveTextY;
int curveTextX;
boolean curveButtonPressed = false;

void setup() {
  fullScreen();
  //size(256, 256); //Size of screen
  background(255);

  //Load in a sound file by passing the name of the mp3 file
  Radial shaker = new Radial(this, "Shaker", "Shaker", MP3, width - (width / 4), height / 2);
  println(shaker.fileName + ".mp3");
  loadAudioFile("Shaker");
  /*Print the sample rate, total samples and file duration in milliseconds
   *TODO:
   *  calculated number of samples and actual samples are different??
   */
  printLoadedAudioSampleInfo(sample);
  printLoadedAudioFileInfo(player); 

  rectWidth = (((width / 2) - (float(bord) * 2)) / float(maxSamples));

  
  drawRectangularWaveForm();
  drawSplineWaveForm();
  //drawRadialSplineWaveForm();
  //getFFTSpectrumValues();
  //shaker.display(720, 1);

  curveButtonDownX = bord;
  curveButtonUpX = 200;
  curveTextX = 100;
  curveButtonDownY = height-45;
  curveButtonUpY = height-45;
  curveTextY = height-30;
  waveFormCenterX = width - (width / 4);
  waveFormCenterY = height / 2;
  fill(120);
  rect(curveButtonDownX, curveButtonDownY, buttonSize, buttonSize);
  rect(curveButtonUpX, curveButtonUpY, buttonSize, buttonSize);

  textSize(32);
  fill(0);
  strokeWeight(1);
  text(numOfCurvePoints, curveTextX, curveTextY);
}


void draw() {
  background(255); 
  if (curveButtonPressed) {
    curveButtonPressed = false;
  }
  drawRectangularWaveForm();
  drawSplineWaveForm();
  drawRadialSplineWaveForm();
  //drawRectangularWaveFormPosition();
  //drawRadialWaveFormPosition();

}

void mousePressed() {

}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      player.pause();
      player.rewind();
    }
  }
  if (key == ' ') {
    if (player.isPlaying()) {
      player.pause();
    } else {
      if (player.position() == player.length() - 1) {
        //saveStrings("positions.txt", getStringArray(positionArray));
        //pos=0;
        player.rewind();
      }
      player.play();
    }
  }
}

void loadAudioSample(String fileName) {
  minim = new Minim(this);
  sample = minim.loadSample(fileName + ".mp3");
}

void loadAudioFile(String fileName) {
  player = minim.loadFile(fileName + ".mp3");
}

void printLoadedAudioSampleInfo(AudioSample file) {
  file.getMetaData();
  println("AUDIO SAMPLE INFO");
  println("Number of Channels: ");
  println("Sample Rate of file: " + file.sampleRate() + " per second");
  println("Length of file: " + (file.length() / 1000.0) + " seconds");
  println("Total number of Samples: " + round((file.sampleRate() * (file.length() / 1000.0))));
  println("Number of channels: " + sample.type() + "\n");
}

void printLoadedAudioFileInfo(AudioPlayer file) {
  println("AUDIO FILE INFO");
  println("Length of file: " + (file.length() / 1000.0) + " seconds");
  println("Buffer size: " + round(file.bufferSize()) + "\n");
}

String[] getStringArray(float[] array) {
  String[] stringa = new String[array.length];
  for(int i=0; i<array.length; i++){
    stringa[i] = String.valueOf(array[i]);
  }
  return stringa;
}
