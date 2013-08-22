// Manages display of your content
class Storyboard {
  ArrayList<PImage> scenes;
  int sceneIndex = -1;
  float counter, light, lightSpeed, rMult, gMult, bMult;
  float tempo = 1; // how quickly to advance through scene

  Storyboard(ArrayList<PImage> _scenes) {
    scenes = _scenes;
    init();
  }

  void init() {
    counter = 0;
    light = 0;

    // Weighting rgb channels randomly
    // to create different colors
    rMult = random(.5, 2);
    gMult = random(.5, 2);
    bMult = random(.5, 2);
  }

  void update(float _tempo) {
    tempo = _tempo;

    // Set lightspeed so that it takes 
    // 1/2 the entire duration of the scene
    // to go from black to white
    lightSpeed = 255/(totalFrames/tempo);
    sceneIndex++;
    if (sceneIndex > images.size()-1)
      sceneIndex = 0;
  }

  void display(boolean isOn) {
    background(0);
    if (isOn)
      light+=lightSpeed;
    else
      light-=lightSpeed;

    // Just "Color-Shift" mode
    if(scenes.size() <= 0) {
      noStroke();
      fill(light*rMult, light*gMult, light*bMult);
      rect(0, 0, width, height);
    }
    // Cycling through images
    else {
      PImage thisScene = images.get(sceneIndex);
      tint(255, light);
      image(thisScene, width/2, height/2, thisScene.width, thisScene.height);
    }

  }

  // Play scene
  void play() {
    checkForEndOfScene();


    // Do something half-way through the scenes
    if (counter < totalFrames/2)
      display(true);
    else
      display(false);
    counter+=tempo;
  }


  // Are we done? If so, re-init counter
  // and other things
  void checkForEndOfScene() {
    if (counter > totalFrames) {
      init();
    }
  }
}

