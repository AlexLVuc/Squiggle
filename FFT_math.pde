/*// copies the values in the samples array into the real array
  // in bit reversed order. the imag array is filled with zeros.
  private void bitReverseSamples(float[] samples, int startAt)
  {
    for (int i = 0; i < timeSize; ++i)
    {
      real[i] = samples[ startAt + reverse[i] ];
      imag[i] = 0.0f;
    }
  }
  
  private void fft()
  {
    for (int halfSize = 1; halfSize < real.length; halfSize *= 2)
    {
      // float k = -(float)Math.PI/halfSize;
      // phase shift step
      // float phaseShiftStepR = (float)Math.cos(k);
      // float phaseShiftStepI = (float)Math.sin(k);
      // using lookup table
      float phaseShiftStepR = cos(halfSize);
      float phaseShiftStepI = sin(halfSize);
      // current phase shift
      float currentPhaseShiftR = 1.0f;
      float currentPhaseShiftI = 0.0f;
      for (int fftStep = 0; fftStep < halfSize; fftStep++)
      {
        for (int i = fftStep; i < real.length; i += 2 * halfSize)
        {
          int off = i + halfSize;
          float tr = (currentPhaseShiftR * real[off]) - (currentPhaseShiftI * imag[off]);
          float ti = (currentPhaseShiftR * imag[off]) + (currentPhaseShiftI * real[off]);
          real[off] = real[i] - tr;
          imag[off] = imag[i] - ti;
          real[i] += tr;
          imag[i] += ti;
        }
        float tmpR = currentPhaseShiftR;
        currentPhaseShiftR = (tmpR * phaseShiftStepR) - (currentPhaseShiftI * phaseShiftStepI);
        currentPhaseShiftI = (tmpR * phaseShiftStepI) + (currentPhaseShiftI * phaseShiftStepR);
      }
    }
  }
  
  protected void fillSpectrum()
  {
    for (int i = 0; i < spectrum.length; i++)
    {
      spectrum[i] = (float) Math.sqrt(real[i] * real[i] + imag[i] * imag[i]);
    }

    if (whichAverage == LINAVG)
    {
      int avgWidth = (int) spectrum.length / averages.length;
      for (int i = 0; i < averages.length; i++)
      {
        float avg = 0;
        int j;
        for (j = 0; j < avgWidth; j++)
        {
          int offset = j + i * avgWidth;
          if (offset < spectrum.length)
          {
            avg += spectrum[offset];
          }
          else
          {
            break;
          }
        }
        avg /= j + 1;
        averages[i] = avg;
      }
    }
    else if (whichAverage == LOGAVG)
    {
      for (int i = 0; i < octaves; i++)
      {
        float lowFreq, hiFreq, freqStep;
        if (i == 0)
        {
          lowFreq = 0;
        }
        else
        {
          lowFreq = (sampleRate / 2) / (float) Math.pow(2, octaves - i);
        }
        hiFreq = (sampleRate / 2) / (float) Math.pow(2, octaves - i - 1);
        freqStep = (hiFreq - lowFreq) / avgPerOctave;
        float f = lowFreq;
        for (int j = 0; j < avgPerOctave; j++)
        {
          int offset = j + i * avgPerOctave;
          averages[offset] = calcAvg(f, f + freqStep);
          f += freqStep;
        }
      }
    }
  }*/
  
  
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
