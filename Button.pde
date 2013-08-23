/*
* Button classes and the functionality the buttons invoke
 */

class Button {
  int side, x, y;
  String label;

  Button(String _label, int xMult) {
    side = 60;
    x = width-((side + 10)*xMult);
    y = side/4;
    label = _label;
  } 

  void display() {
    rectMode(CORNER);
    stroke(255);
    fill(0);
    textSize(14);
    textAlign(CENTER, CENTER);
    rect(x, y, side, side/2);
    fill(255);
    text(label, x+(side/2), y+(side/5));
  }

  boolean isHovered() {
    if (mouseX > x && mouseX < x+side && mouseY > y && mouseY < y+(side/2))
      return true;
    else 
      return false;
  }
}

// Multi-state button
class ToggleButton extends Button {
  String onLabel, offLabel;
  boolean isOn;

  ToggleButton(String _label, int xMult, String _offLabel) {
    super(_label, xMult);
    label = _label;
    onLabel = _label;
    offLabel = _offLabel;
  }
  void toggle() {
    isOn = !isOn; 
    if (isOn)
      label = offLabel;
    else
      label = onLabel;
  }
}

void initPlayer() {
  sb.init();
  t = firstBeatInd;
  try {
    audio.cue(0);
    audio.play();
  }
  catch(Exception e) {
    println("No audio to play.");
  }
}
void resetPlayer() {
  initPlayer();
  drawDots();

  try {
    audio.pause();
  }
  catch(Exception e) {
    println("No audio to pause.");
  }
}

void load() {
  // Pause drawing while we load the file
  initialize();
  selectInput("Load Graph", "loadBeats");
}

void loadBeats(File file) {
  String[] savedBeats = loadStrings(file.getAbsolutePath());
  beats = new Beat[savedBeats.length];
  for (int i = 0; i < savedBeats.length; i++) {
    String[] savedBeat = savedBeats[i].split(", ");
    beats[i] = new Beat(Float.parseFloat(savedBeat[0]), Float.parseFloat(savedBeat[1]), Boolean.parseBoolean(savedBeat[2]));
  }

  // Get ready to play
  isPlayable = true;
}

void save() {
  selectOutput("Save This Graph", "saveBeats");
}

void saveBeats(File file) {
  String[] savedBeats = new String[beats.length];
  String concatenator = ", ";
  for (int i = 0; i < beats.length; i++) {
    Beat beat = beats[i];
    String savedBeat = "" + beat.beat;
    savedBeat += concatenator + beat.rawTempo;
    savedBeat += concatenator + beat.isUserCreated;
    savedBeats[i] = savedBeat;
  }
  println(file.getName());
  saveStrings(file.getAbsolutePath(), savedBeats);
}

void setAudioFile() {
  selectInput("Select Audio File", "loadAudio");
}

// Load audio file
void loadAudio(File file) {
  String path = file.getAbsolutePath();
  try {
    audio = minim.loadFile(path);
    seconds = Math.round(audio.length()/1000);
    println("The audio is " + seconds + "s long.");
  }
  catch(Exception e) {
    println("No audio");
  }
}

void setImagesFolder() {
  selectFolder("Select Media Folder", "loadImages");
}

// Load images from selected folder
void loadImages(File folder) {
  for (int i = 0; i < folder.listFiles().length; i++) {
    String path = folder.getAbsolutePath() + "/" + nf(i, 4) + ".jpg";
    boolean isSuccess = true;
    images.add(loadImage(path));
  }
}

void setExportFolder() {
    selectFolder("Select Media Folder", "setExportPath");  
}

void setExportPath(File folder) {
  exportPath = folder.getAbsolutePath();
  println(exportPath);
}
