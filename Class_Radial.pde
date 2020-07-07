
int WAV = 0;
int MP3 = 1;

class Radial {

  // constant value of the number of points to reduce a sound file to
  final int maxArraySize = 720;

  int posX, posY, fileType;
  String name, fileName;
  float[] sampleArray, frequencyArray;

  /* Contructor for a radial object
   * 
   * @param Name:      name of radial file to eb displayed
   * @param FileName:  file name of sound file
   * @param posx:      x position of center of radial
   * @param posy:      y position of center of radial
   */
  Radial(String Name, String FileName, int FileType, int posx, int posy) { 
    name = Name;
    fileName = FileName;
    fileType = FileType;
    sampleArray = new float[maxArraySize];
    frequencyArray = new float[maxArraySize];
    posX = posx;
    posY = posy;
  }

  boolean checkForArrayFile() {
    return false;
  }

  void createArrayFile() {
  }

  float[] createArrayFromFile(String filePath) {
    float[] temp = new float[maxArraySize];
    return temp;
  }

  void display(int displayPoints) {
  }


  /* method for reducing the samples in an mp3 or wav file to 720 values
   *
   * @param fileName:    file name of sound file
   * @param bufferSize:  desired buffer size of sample loading
   */
  float[] reduceSoundFile(String fileName, int bufferSize) {
    float[] reducedSamples = new float[maxSamples];

    // load in the audio file as a sample
    Minim minim = new Minim(this);
    AudioSample sample;
    if (fileType == 1) {     
      sample = minim.loadSample(fileName + ".mp3", bufferSize);
    } else {
      sample = minim.loadSample(fileName + ".wav", bufferSize);
    }

    // If the file only has a mono track, then you only need one array of values
    // If the file has stereo audio, take both channels and average the values from both
    float[] leftSamples = sample.getChannel(AudioSample.LEFT);
    float[] summedSamples = new float[leftSamples.length];
    if (sample.type() == 1) {
      for (int i = 0; i < leftSamples.length; i++) {
        summedSamples[i] = leftSamples[i];
      }
    } else {
      float[] rightSamples = sample.getChannel(AudioSample.RIGHT);
      for (int i = 0; i < leftSamples.length; i++) {
        summedSamples[i] = leftSamples[i] + rightSamples[i];
      }
    }

    // Reduce the summedSamples to arraySize by taking the average of the samples over the reducing factor
    float totalSamples = leftSamples.length;
    float reducingFactor = totalSamples / float(maxArraySize);
    float average = 0;
    int curArraySpot = 0;

    for (int i = 0; i < summedSamples.length; i++) {
      average += summedSamples[i];
      if ( i % int(reducingFactor) == 0 && i!=0) {  //Must cast reducing factor to int to make math work
        reducedSamples[curArraySpot] = average / reducingFactor;
        curArraySpot++;
        average = 0;
        if (curArraySpot == maxArraySize - 1) break;
      }
    }

    return reducedSamples;
  }
} 
