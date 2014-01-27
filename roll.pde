// Roll Gui Sketch
// Use in Conjunction with Roll.ino loaded onto an Arduino

/**
  * This sketch demonstrates how to use an <code>AudioRecorder</code> to record audio to disk. 
  * Press 'r' to toggle recording on and off and the press 's' to save to disk. 
  * The recorded file will be placed in the sketch folder of the sketch.
  */

import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String inString;
String snareHit, kickHit;
String finalString;
Minim         minim;
AudioOutput   out;
AudioRecorder recorder;
AudioSample kick;
AudioSample snare;

int lf = 10;      // ASCII linefeed

void setup()
{
  size(512, 200, P3D);
  
  minim = new Minim(this);

  out = minim.getLineOut();
  
  // create a recorder that will record from the input to the filename specified, using buffered recording
  // buffered recording means that all captured audio will be written into a sample buffer
  // then when save() is called, the contents of the buffer will actually be written to a file
  // the file will be located in the sketch's root folder.
  recorder = minim.createRecorder(out, "myrecording.wav", true);
  kick = minim.loadSample( "BD.mp3", // filename
                            512      // buffer size
                         );
   if ( kick == null ) println("Didn't get kick!");
   snare = minim.loadSample( "SD.wav", 512);
  if ( snare == null ) println("Didn't get snare!");
  
  //kick.patch( out );
  snareHit = "Snare";
  kickHit = "Kick";
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil(lf);
  
  textFont(createFont("Arial", 12));
}

void draw()
{
  background(0); 
  stroke(255);
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
   
   
     // read it and store it in val
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line(i, 50  + out.left.get(i)*50,  i+1, 50  + out.left.get(i+1)*50);
    line(i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50);
  }
  for (int i = 0; i < kick.bufferSize() - 1; i++)
  {
    float x1 = map(i, 0, kick.bufferSize(), 0, width);
    float x2 = map(i+1, 0, kick.bufferSize(), 0, width);
    line(x1, 50 - kick.mix.get(i)*50, x2, 50 - kick.mix.get(i+1)*50);
    line(x1, 150 - snare.mix.get(i)*50, x2, 150 - snare.mix.get(i+1)*50);
  }
  if ( recorder.isRecording() )
  {
    text("Currently recording...", 5, 15);
  }
  else
  {
    text("Not recording.", 5, 15);
  }
}

void keyReleased()
{
  if ( key == 'r' ) 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording). 
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    }
    else 
    {
      recorder.beginRecord();
    }
  }
  if ( key == 's' )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // in the case of buffered recording, if the buffer is large, 
    // this will appear to freeze the sketch for sometime
    // in the case of streamed recording, 
    // it will not freeze as the data is already in the file and all that is being done
    // is closing the file.
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    println("Done saving.");
  }
}

void keyPressed() 
{
  if ( key == 'z' ) snare.trigger();
  if ( key == 'x' ) kick.trigger();
}

void serialEvent(Serial p)
{
    inString = (myPort.readString());
    finalString = trim(inString);
    if(finalString != null)
   {
  
    if(finalString.equals(snareHit) )
    {
      snare.trigger();
    }
  
  
    if(finalString.equals(kickHit))
    {
      kick.trigger();
    }
   }
}



