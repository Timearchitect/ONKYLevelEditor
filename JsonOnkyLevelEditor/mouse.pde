PVector diff= new PVector(0, 0);

void mousePressed() {
  //image(list.get(0).image, 50, height-120, 50, 50);
  //font i=1; i<list.size (); i++)image(list.get(i).image, 50+i*60, height-100, 50, 50);
  //image(list.get(list.size()-1).image, -10, height-100, 50, 50);


  if (mouseButton==LEFT && mouseY> height-100) {
    for (int i=0; i<list.size (); i++) { 
      if (mouseX > i*+60+50 && mouseX < i*+60+100) { 
        background(255); 
        println(i);
        rotateListElement(i);
        listOrder=(listOrder+i)%list.size();
      }

    }
   if(mouseX > -10 && mouseX< 50) rotateListElement(list.size()-1); // back 
  } else { 
    searchFocusableObstacle();
    if (mouseButton==LEFT) {
      if (focus==null) addObstacle();
      else {
        searchFocusableObstacle();
        select(focus);
        if (mouseEvent.getClickCount()==2) {  // double-click
          println("double-click");
          focus.edit();
        }
      }
    }
    if (mouseButton==RIGHT) {
      if (focus!=null) {
        removeObstacle();
      }
    }
    if (mouseButton==CENTER) {
      cursor(13);
      diff.set(cameraCoord.x-mouseX/scaleFactor, cameraCoord.y-mouseY/scaleFactor);
    }
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
      removeObstacle();
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
          cursor(0);

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
  saveChanged=false;
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
void removeObstacle() {
  saveChanged=false;
  obstacles.remove(focus);
  selected.remove(focus);
  println(focus.getClass().getSimpleName()+" deleted");
}
void select(Obstacle temp) {
  if (!selected.contains(temp))
    selected.add(focus);
  else selected.remove(focus);
}

