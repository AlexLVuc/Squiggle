void printFloatArray(float[] array){
  for (int i = 0; i < array.length; i++) {
    println(array[i]);
  }
}

void printLoadedAudioSampleInfo(AudioSample file) {
  file.getMetaData();
  println("AUDIO SAMPLE INFO");
  println("Number of Channels: ");
  println("Sample Rate of file: " + file.sampleRate() + " per second");
  println("Length of file: " + (file.length() / 1000.0) + " seconds");
  println("Total number of Samples: " + round((file.sampleRate() * (file.length() / 1000.0))));
  println("Number of channels: " + file.type() + "\n");
}

void printLoadedAudioFileInfo(AudioPlayer file) {
  println("AUDIO FILE INFO");
  println("Length of file: " + (file.length() / 1000.0) + " seconds");
  println("Buffer size: " + round(file.bufferSize()) + "\n");
}
