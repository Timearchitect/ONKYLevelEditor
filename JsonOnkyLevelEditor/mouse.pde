PVector diff= new PVector(0, 0);

void mousePressed() {
  searchFocusableObstacle();
  if (mouseButton==LEFT) {
    if (focus==null) addObstacle();
    searchFocusableObstacle();
  }
  if (mouseButton==RIGHT) {
    if (focus!=null) {
      obstacles.remove(focus);
      println("deleted");
    }
  }
  if (mouseButton==CENTER) {
    diff.set(cameraCoord.x-mouseX/scaleFactor, cameraCoord.y-mouseY/scaleFactor);
  }
}

void mouseDragged() {
  searchFocusableObstacle();
  if (mouseButton==LEFT) {
    if (focus==null)addObstacle();
    searchFocusableObstacle();
  }
  if (mouseButton==RIGHT) {
    if (focus!=null) {
      obstacles.remove(focus);
      println("deleted");
    }
  }
  if (mouseButton==CENTER) {
    cameraCoord.set(mouseX/scaleFactor+diff.x, mouseY/scaleFactor+diff.y);
  }
}
void mouseMoved() {
  searchFocusableObstacle();
}

void mouseReleased() {
  if (mouseButton==CENTER) {
    //  pCameraCoord=cameraCoord;
  }
}
void mouseWheel(MouseEvent event) {
  float pScaleFactor=scaleFactor;
  scaleFactor+=event.getCount()*0.02;
  if (pScaleFactor<scaleFactor)  cameraCoord.add((width*0.5-mouseX)*scaleFactor, (height*0.5-mouseY)*scaleFactor, 0);
  else  cameraCoord.sub((width*0.5-mouseX)*scaleFactor, (height*0.5-mouseY)*pScaleFactor, 0);

  scaleFactor=constrain(scaleFactor, 0.1, 2);
}

void searchFocusableObstacle() {
  if (focus!=null)focus.highLight=false;
  focus=null;
  for (Obstacle o : obstacles) { 
    if (mouseX-cameraCoord.x*scaleFactor<(o.x +o.w)*scaleFactor && mouseX-cameraCoord.x*scaleFactor>o.x*scaleFactor &&
      mouseY-cameraCoord.y*scaleFactor<(o.y +o.h)*scaleFactor && mouseY-cameraCoord.y*scaleFactor>o.y*scaleFactor)focus=o;
  }
  if (focus!=null)focus.highLight=true;
}

void addObstacle() {

  int interval=int(list.get(0).h*0.5);
  int xRounded = int(((mouseX/scaleFactor-cameraCoord.x) -interval*0.5) / interval ) * interval;
  int yRounded = int(((mouseY/scaleFactor-cameraCoord.y) -interval*0.5) / interval ) * interval;
  //obstacles.add(new Box(int(mouseX/scaleFactor-cameraCoord.x),int(mouseY/scaleFactor-cameraCoord.y)));
  //  if (selected!=null) {
  list.get(0).x=xRounded;
  list.get(0).y=yRounded;
  obstacles.add(list.get(0).clone());
  //  }
  //obstacles.add(new Box(xRounded, yRounded));
  println("added");
}

