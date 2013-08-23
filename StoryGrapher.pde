import processing.video.*;
import ddf.minim.*;

///////////////////////////
///////////////////////////
/////SETTINGS FOR YOU//////
///////////////////////////
///////////////////////////
float seconds = 90;
int fRate = 30;
int totalFrames = (int)seconds*fRate;
int maxNumberOfMedia = 1;



// Gatekeepers for drawing and playing modes
boolean isDrawable, isDrawing;
boolean isPlayable, isTiming;
boolean isExporting;
String exportPath;

// Rate at which we move across the screen
// Is automatically calculated based on
// duration of storyboard and width of graph
float t = 0; 
float tSpeed = 0;

// Storing data from your graph
Beat[] beats;
int firstBeatInd, lastBeatInd, numBeats;
// Managing moving through your content
Storyboard sb;

// Your content
ArrayList<PImage> images;
ArrayList<Movie> movies;
Minim minim;
AudioPlayer audio;


// Keeping track oftime
// elapsed since clicking
// Play button
float timer;
ToggleButton play;
Button clear;
Button load;
Button save;
Button export;
Button loadImages;
Button loadAudio;

// Highest point you can draw
int mouseYMin = 50;

void setup() {
  size(640, 480); 
  export = new Button("Export", 1);
  save = new Button("Save", 2);

  play = new ToggleButton("Play", 4, "Stop");
  clear = new Button("Clear", 5);

  loadAudio = new Button("Audio", 7);
  loadImages = new Button("Images", 8);
  load = new Button("Load", 9);

  imageMode(CENTER);
  frameRate(fRate);

  minim = new Minim(this);
  images = new ArrayList<PImage>();


  // Get images from Flickr or Google
  //images = getFlickr();
  //images = getGoogle();
  //File data = new File("data");
  // Or local data folder
  //loadMedia(data);
  println("HOW MANY IMAGES " + images.size());  
  sb = new Storyboard(images);
  initialize();
}

void draw() {

  // Drawing the storyboard graph
  if (isDrawable) {
    background(255);
    if (isDrawing) {
      if (mouseX >= 0 && mouseX < width && mouseY >= mouseYMin && mouseY < height) {
        beats[mouseX] = createBeat(mouseX, mouseY, true);
        isPlayable = true;
      }
    }
    drawDots();
  }
  else if (isTiming) {
    //Calculate time elapsed
    //Since beginning of storyboard
    String clock = "";
    int time = 0;
    time = int(timer/1000) + 1;
    clock = time + "s";
    textAlign(CENTER);
    textSize(48);
    float textWidth = textWidth(clock+5);

    if (play.isOn) {
      play();
      timer = timer + (millis() - timer);
    }
    // When stopped, show end-time
    else {
      fill(0);
      rectMode(CENTER);
      rect(50, 30, textWidth, 70);
    }
    // Display clock
    stroke(255);
    fill(255);
    text(clock, textWidth/2, 50);
  }

  clear.display();
  play.display();
  load.display();
  loadImages.display();
  loadAudio.display();
  save.display();
  export.display();
}

void initialize() {
  background(255);

  // Initialize beats array with 
  // a dot for every x-position
  beats = new Beat[width];
  for (int i = 0; i < beats.length; i++) {
    beats[i] = createBeat(i, mouseYMin, false);
  }

  // Allow drawing
  // Don't allow playing
  // Reset beats array to
  // "hasn't been interpolated yet"
  isDrawable = true;
  isPlayable = false;
  isTiming = false;
}


void play() {
  if (numBeats > 0) {
    sb.play();      
    Beat currentBeat = beats[getTIndex()];
    t += tSpeed;
    if(isExporting)
      saveFrame(exportPath + "/frame-##########.png");
    
    // Draw dot after you save frame
    currentBeat.drawDot(true);

    // If we're done, reset the player
    if (t > lastBeatInd)
      resetPlayer();

    // Update storyboard tempo
    // with next beat
    Beat nextBeat = beats[getTIndex()];
    sb.update(nextBeat.tempo);
  }
}

//////////////////////////////////////////
//////////////////////////////////////////
//////////// HELPER FUNCTIONS ////////////
//////////////////////////////////////////
//////////////////////////////////////////

int getTIndex() {
  return (int) Math.round(t);
}

Beat createBeat(float x, float y, boolean isUserCreated) {
  x = constrain(x, 0, width);
  y = constrain(y, mouseYMin, height);
  return new Beat(x, y, isUserCreated);
}

void drawDots() {
  background(255);
  for (int i = 0; i < beats.length; i++) {
    if (beats[i].isUserCreated)
      beats[i].drawDot(play.isOn);
  }
}

//////////////////////////////////////////
//////////////////////////////////////////
/////////////// INTERACTION //////////////
//////////////////////////////////////////
//////////////////////////////////////////
void mousePressed() {
  isDrawing = true;

  // Clear graph
  // Re-initialize beats array
  if (clear.isHovered() && !play.isOn)
    initialize();

  // Play or Stop storyboard
  else if (play.isHovered() && isPlayable) {
    if (!play.isOn) {
      playEvent();
    }
    else {
      resetPlayer();
    }    
    play.toggle();
  }
  else if (save.isHovered())
    save();
  else if (export.isHovered()) {
    setExportFolder();
    isExporting = true;
    playEvent();
  }

  else if (load.isHovered())
    load();

  else if (loadAudio.isHovered())
    setAudioFile();

  else if (loadImages.isHovered())
    setImagesFolder();
}

void playEvent() {
  initPlayer();
  isPlayable = true;
  isDrawable = false;
  timer = millis();
  isTiming = true;
}

void mouseReleased() {
  isDrawing = false;
  if (isDrawable)
    interpolate();

  if (play.isHovered() && isPlayable && !play.isOn)
    isDrawable = true;
}

void mouseDragged() {
  // ERASE
  if (isDrawable) {
    boolean isGoingRight = mouseX > pmouseX;
    if (isGoingRight) {
      for (int i = pmouseX + 1; i < mouseX; i++) {
        beats[i] = createBeat(i, mouseYMin, false);
      }
    }
    else {
      for (int i = pmouseX - 1; i > mouseX; i--) {
        beats[i] = createBeat(i, mouseYMin, false);
      }
    }
  }
}

