/*
 * Functions for completeing various tasks
 * Creator: Michael Jamieson
 * Date: July 4, 2020
 */

/* method for creating a java.awt front from ttf file
 *
 * @param ttf_name:  name of ".ttf" file
 * @param style:     style of font
 * @param size:      size of font
 */
public Font getFont(String ttf_name, int style, float size) {
  InputStream is = createInput(ttf_name);
  Font awtfont = null;
  try {
    awtfont = Font.createFont(Font.TRUETYPE_FONT, is).deriveFont(style, size);
  }
  catch(Exception e) {
    println("Failed to load font " + ttf_name);
  }
  return awtfont;
}

// method for making a random 8 digit session password
String makeSessionPasswordPort() {
  String password = "";
  int temp;
  for (int i = 0; i < 8; i++) {
    temp = int(random(0, 3));
    switch (temp) {
    case 0:
      password += (char) int(random(48, 58));
      break;
    case 1:
      password += (char) int(random(65, 91));
      break;
    case 2:
      password += (char) int(random(97, 123));
      break;
    }
  } 
  return password;
}

// returns the center x value of the window
int centerX(PApplet app) {
  return app.width / 2;
}

// returns the center y value of the window
int centerY(PApplet app) {
  return app.height / 2;
}

// method for centering a G4P control horizontally given it's width
int centerGControlX(PApplet app, int w) {
  return centerX(app) - (w / 2);
}

// method for centering a G4P control vertically given it's height
int centerGControlY(PApplet app, int h) {
  return centerX(app) - (h / 2);
}

// method for printing a float array
// probably not that useful in the long run
void printFloatArray(float[] array) {
  for (int i = 0; i < array.length; i++) {
    println(array[i]);
  }
}

// print metadata of an AudioSample
// this is more in depth data than the player holds
void printLoadedAudioSampleInfo(AudioSample file) {
  file.getMetaData();
  println("AUDIO SAMPLE INFO");
  println("Number of Channels: ");
  println("Sample Rate of file: " + file.sampleRate() + " per second");
  println("Length of file: " + (file.length() / 1000.0) + " seconds");
  println("Total number of Samples: " + round((file.sampleRate() * (file.length() / 1000.0))));
  println("Number of channels: " + file.type() + "\n");
}

// print data of an AudioPlayer
// this is less data than the AudioSample
void printLoadedAudioFileInfo(FilePlayer file) {
  println("AUDIO FILE INFO");
  println("Length of file: " + (file.length() / 1000.0) + " seconds");
}


/* method that mfills the radials array with all sound files within a directory
 *
 * @param app:        name of G4P window radials is drawn on
 * @param arrayList:  arrayList of soundFile objects of all sound files in a directory
 */
void makeRadialArray(PApplet app, ArrayList<soundFile> arrayList) {
  radials = new Radial[arrayList.size()];
  for (int i = arrayList.size() - 1; i >= 0; i--) {
    soundFile file = arrayList.get(i);
    radials[i] = new Radial(app, file.name, file.name, file.fileType, (maxRadialRadius * ((2 * i) + 1)) + (radialSpacing * i) + radialAreaBorder, 900, radials, false);
    arrayList.remove(i);
  }
}


/* method that makes an arrayList of all mp3 or wav files in a directory
 *
 * @param path:  path of folder you are searching
 */
ArrayList<soundFile> findSoundFilesInDirectory(String path) {
  // list of files in directory
  File[] files = getFilesFromDirectory(path);
  // array list for variable number of sound files within directory
  ArrayList<soundFile> tempFiles = new ArrayList<soundFile>();

  for (int i = 0; i < files.length; i++) {
    File f = files[i]; 

    // check if file 
    if (!f.isDirectory()) {
      String fNameFull = f.getName();
      int fNameLength = fNameFull.length();
      String fExt = fNameFull.substring(fNameLength - 4, fNameLength);
      String fName = fNameFull.substring(0, fNameLength - 4);
      if (fExt.equals(".mp3") || fExt.equals(".wav")) {
        println("Name: " + fName + "\tfile ext.: " + fExt);
        println("adding to list");
        // add to the array list
        tempFiles.add(new soundFile(fName, fExt));
      }
    }
  }
  println(tempFiles.size());
  return tempFiles;
}


/* method that returns all the files in a directory as an array of File objects
 *
 * @param dir:  directory of folder you are searching
 */
File[] getFilesFromDirectory(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// class for saving info about sound files when searching through directories
class soundFile {
  String name;
  int fileType;

  soundFile(String name_, String fileType_) {
    name = name_;
    if (fileType_.equals(".mp3")) {
      fileType = MP3;
    } else if (fileType_.equals(".wav")) {
      fileType = WAV;
    }
  }
}

void printRadialsData() {
  for (int i = 0; i < radials.length; i++) {
    print("Name: " + radials[i].name);
    print("\tFile name: " + radials[i].fileName + (radials[i].fileType == MP3 ? ".mp3" : ".wav"));
    println("\tBPM: " + radials[i].BPM);
  }
}

void initializeFolderSelectValues(String path, int recursion) {
  // get all files within a folder
  File folder = new File(path);
  File[] files = folder.listFiles();
  // go through all files
  for (int i = 0; i < files.length; i++) {
    // check if file is a directory
    if (files[i].isDirectory()) {
      int pathLength = path.length();
      int tempLength = files[i].getPath().length();
      String folderName = "";
      if (recursion != 0) {
        for (int j = 0; j < recursion; j++) {
          folderName += ">";
        }
        folderName += files[i].getPath().substring(pathLength + 1, tempLength);
      } else {
        folderName += files[i].getPath().substring(pathLength, tempLength);
      }
      folderSelectList.addItem(folderName);
      // recursively enter the folder and check for any folders within
      initializeFolderSelectValues(files[i].getPath(), recursion + 1);
    }
  }
}
