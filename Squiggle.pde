import ddf.minim.*; 
import ddf.minim.analysis.*; 
Minim minim;  //Used for audio sampling
AudioSample sample;  //Also used for audio sampling??
AudioPlayer player;
FFT fft;

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
  loadAudioSample("Shaker"); 
  loadAudioFile("Shaker");
  /*Print the sample rate, total samples and file duration in milliseconds
   *TODO:
   *  calculated number of samples and actual samples are different??
   */
  printLoadedAudioSampleInfo(sample);
  printLoadedAudioFileInfo(player); 

  rectWidth = (((width / 2) - (float(bord) * 2)) / float(maxSamples));

  reduceWaveForm();
  drawRectangularWaveForm();
  drawSplineWaveForm();
  drawRadialSplineWaveForm();
  //getFFTSpectrumValues();

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
  stroke(0);
  strokeWeight(1);
  fill(120);
  textSize(32);
  rect(curveButtonDownX, curveButtonDownY, buttonSize, buttonSize);
  rect(curveButtonUpX, curveButtonUpY, buttonSize, buttonSize);
  fill(0);
  text(numOfCurvePoints, curveTextX, curveTextY);
}

void mousePressed() {
  if (mouseX >= curveButtonDownX && mouseX <= curveButtonDownX + buttonSize && mouseY >= curveButtonDownY && mouseY <= curveButtonDownY + buttonSize) {
    numOfCurvePoints-=10;
    curveButtonPressed = true;
  }
  if (mouseX >= curveButtonUpX && mouseX <= curveButtonUpX + buttonSize && mouseY >= curveButtonUpY && mouseY <= curveButtonUpY + buttonSize) {
    numOfCurvePoints+=10;
    if (numOfCurvePoints > maxSamples) numOfCurvePoints = maxSamples;
    curveButtonPressed = true;
  }
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
  println("Total number of Samples: " + round((file.sampleRate() * (file.length() / 1000.0))) + " samples\n");
}

void printLoadedAudioFileInfo(AudioPlayer file) {
  println("AUDIO FILE INFO");
  println("Length of file: " + (file.length() / 1000.0) + " seconds");
  println("Buffer size: " + round(file.bufferSize()) + "\n");
}

void reduceWaveForm() {
  /* Create arrays for both channels of the track
   *Samples values:
   *  between -1 and 1
   */
  float[] leftSamples = sample.getChannel(AudioSample.LEFT);
  float[] rightSamples = sample.getChannel(AudioSample.RIGHT);//new float[leftSamples.length];//
  println(leftSamples.length);
  println(rightSamples.length);
  printFloatArray(leftSamples);
  printFloatArray(rightSamples);
  
  //saveStrings("leftSamples.txt", getStringArray(leftSamples));
  //saveStrings("rightSamples.txt", getStringArray(rightSamples));

  float totalSamples = leftSamples.length;
  float reducingFactor = totalSamples / maxSamples;

  /*Creates a summed mono channel of both left and rigth channels
   *Makes manipulation easier later 
   *Sample Values:
   *  between -1 and 1
   */
  float[] summedSamples = new float[leftSamples.length];
  for (int i=0; i<leftSamples.length; i ++) {
    summedSamples[i] = leftSamples[i] + rightSamples[i];
  }

  /*Reduce the summedSamples to the maximum by taking the average of the samples over the reducing factor
   *Sample values:
   *  between 0 and 1
   *TODO: 
   *  save this new reduced list to a file for easier loading on subsequent startups
   */
  float average = 0;
  int curArraySpot = 0;
  for (int i=0; i<summedSamples.length; i++) {
    average += summedSamples[i];
    if ( i % int(reducingFactor) == 0 && i!=0) {  //Must cast reducing factor to int to make math work
      reducedSamples[curArraySpot] = average / reducingFactor;
      curArraySpot++;
      average = 0;
      if (curArraySpot == maxSamples - 1) break;
    }
  }
}


//https://www.nti-audio.com/en/support/know-how/fast-fourier-transform-fft#:~:text=Strictly%20speaking%2C%20the%20FFT%20is,divided%20into%20its%20frequency%20components.&text=Over%20the%20time%20period%20measured,contains%203%20distinct%20dominant%20frequencies.
/*void getFFTSpectrumValues() {
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.forward(player.mix);
  
  float[] spectrumReal = new float[fft.specSize()];
  float[] spectrumImag = new float[fft.specSize()];
  spectrumReal = fft.getSpectrumReal();
  spectrumImag = fft.getSpectrumImaginary();
  saveStrings("spectrumReal.txt", getStringArray(spectrumReal));
  saveStrings("spectrumImag.txt", getStringArray(spectrumImag));
  
  
  for (int i = 0; i < fft.specSize(); i++)
  {
    positionArray[pos] = player.position();
    pos++;
    if (fft.getBand(i) > fft.getBand(maxBand)) maxBand = i;
  }
  sampleSpectrum[spectrumPos] = maxBand;
  spectrumPos++;
  maxBand = 0;
  if (spectrumPos == 1024) {
    spectrumPos = 0;
    FFTcomplete = true;
  }
}*/

String[] getStringArray(float[] array) {
  String[] stringa = new String[array.length];
  for(int i=0; i<array.length; i++){
    stringa[i] = String.valueOf(array[i]);
  }
  return stringa;
}
