void drawRectangularWaveForm() {
  //Draw the reduced waveform to the screen using rectangles
  fill(190);
  noStroke();
  for (int i=0; i<reducedSamples.length; i++) {
    rect((i * rectWidth) + bord, (height / 2) - reducedSamples[i] * amplitudeScalingFactor, rectWidth, reducedSamples[i] * amplitudeScalingFactor);
  }
}

void drawSplineWaveForm() {
  //Draw waveform using splines
  noFill();
  stroke(0);
  strokeWeight(2);
  beginShape(); 
  for (int i = 0; i < numOfCurvePoints; i++) {
    float x = (i * (maxSamples / numOfCurvePoints) * rectWidth + (rectWidth / 2)) + bord;
    float y = (height / 2) - reducedSamples[int(i * curvePointsScalingFactor)] * amplitudeScalingFactor;   
    if (i == 0) curveVertex((rectWidth / 2) + bord, (height / 2) - reducedSamples[0] * amplitudeScalingFactor);
    if (i == numOfCurvePoints - 1) curveVertex(x, y);
    curveVertex(x, y);
  }
  endShape();
}

void drawRadialSplineWaveForm() {
  float min = floor(min(reducedSamples));
  float max = ceil(max(reducedSamples));
  //printFloatArray(reducedSamples);
  noFill();
  stroke(0);
  strokeWeight(2);
  beginShape(); 
  for (int i = 0; i < numOfCurvePoints; i++) {
    float r = map(reducedSamples[i], min, max, shift, amplitudeScalingFactor);
    float x = waveFormCenterX + (r * cos(radians(((360.0 / numOfCurvePoints) * i) - 90)));
    float y = waveFormCenterY + (r * sin(radians(((360.0 / numOfCurvePoints) * i) - 90)));
    if (i == 0) curveVertex(x, y);
    if (i == numOfCurvePoints - 1) {
      r = map(reducedSamples[0], min, max, shift, amplitudeScalingFactor);
      x = waveFormCenterX + (r * cos(radians(-90)));
      y = waveFormCenterY + (r * sin(radians(-90)));
      curveVertex(x, y);
    }
    curveVertex(x, y);
  }
  endShape();
}

void drawRectangularWaveFormPosition() {
  float posx = map(player.position(), 0, player.length(), bord, float(maxSamples) * rectWidth + bord);
  stroke(0, 200, 0);
  strokeWeight(1);
  line(posx, bord*2, posx, height - bord*2);
}

void drawRadialWaveFormPosition() { 
  float pos = map(player.position(), 0, player.length(), 0, maxSamples);
  float x2 = waveFormCenterX + (amplitudeScalingFactor * cos(radians(((360.0 / maxSamples) * pos) - 90)));
  float y2 = waveFormCenterY + (amplitudeScalingFactor * sin(radians(((360.0 / maxSamples) * pos) - 90)));
  stroke(0, 200, 0);
  strokeWeight(1);
  line(waveFormCenterX, waveFormCenterY, x2, y2);
}
