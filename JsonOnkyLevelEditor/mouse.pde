PVector diff= new PVector(0, 0);

void mousePressed() {

  if (mouseButton==LEFT && mouseY> height-100) {  // toolbar
    for (int i=0; i<list.size (); i++) { 
      if (mouseX > i*+60+50 && mouseX < i*+60+100) { 
        background(255); 
        println(i);
        rotateListElement(i);
        listOrder=(listOrder+i)%list.size();
      }
    }
    if (mouseX > -10 && mouseX< 50) rotateListElement(list.size()-1); // back
  } else { 
    searchFocusableObstacle();
    if (mouseButton==LEFT) {  // regular left
      if (pasteing) { // paste Mode
        record(); //record undostate
        paste();
        pasteing=false;
      } else {
        if (focus==null) {
          record(); //record undostate
          addObstacle();
        } else {
          searchFocusableObstacle();
          select(focus);
          if (mouseEvent.getClickCount()==2) {  // double-click edit attributes
            println("double-click");
            record(); //record undostate
            focus.edit();
            for (Obstacle o : selected)o.text=focus.text;
          }
        }
      }
    }
    if (mouseButton==RIGHT) {// regular right
      if (pasteing) { // paste Mode cancel
        pasteing=false;
      } else {
        if (focus!=null) { // remove obstacle
          record(); //record undostate
          removeObstacle();
        } else {
          selected.clear();
        }
      }
    }
    if (mouseButton==CENTER) {// regular middle
      cursor(13);
      diff.set(cameraCoord.x-mouseX/scaleFactor, cameraCoord.y-mouseY/scaleFactor);
    }
  }
}

void mouseDragged() {
  searchFocusableObstacle();
  if (mouseButton==LEFT) {
    if (focus==null) {
      addObstacle();
    } else {
      stretch();
    }
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
  if (mouseButton==LEFT) {
    if (focus!=null) {          
      record(); //record undostate
      GridInline();
    }
  }
}
void mouseWheel(MouseEvent event) {
  float pScaleFactor=scaleFactor;
  scaleFactor+=event.getCount()*0.02;
  if (pScaleFactor<scaleFactor)  cameraCoord.add((width*0.5-mouseX)*scaleFactor, (height*0.5-mouseY)*scaleFactor, 0);
  else  cameraCoord.sub((width*0.5-mouseX)*scaleFactor, (height*0.5-mouseY)*scaleFactor, 0);

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
  // int interval=int(list.get(0).h*0.5);
  int interval=int(list.get(0).increment);
  int xRounded = int(((mouseX/scaleFactor-cameraCoord.x) -interval*0.25) / interval ) * interval;
  int yRounded = int(((mouseY/scaleFactor-cameraCoord.y) -interval*0.25) / interval ) * interval;
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
void stretch() {
  if (focus.stretchable) {
    int scalex=int(mouseX/scaleFactor-cameraCoord.x);
    int scaley=int(mouseY/scaleFactor-cameraCoord.y);
    int margin=25;
    //    println(scalex +" :mouseX | x: "+focus.x);
    if (scalex-margin<focus.x) {
      focus.w+=focus.x-scalex+margin;
      focus.x=scalex-margin;
    }
    if (scalex+margin>focus.x+focus.w) {
      focus.w=scalex+margin-focus.x;
    }
    if (scaley-margin<focus.y) {
      focus.h+=focus.y-scaley+margin;
      focus.y=scaley-margin;
    }
    if (scaley+margin>focus.y+focus.h) {
      focus.h=scaley+margin-focus.y;
    }
  }
}
void GridInline() {
  int interval=50;
  focus.x = round((focus.x -interval*0.25) / interval ) * interval;
  focus.y = round((focus.y -interval*0.25) / interval ) * interval;
  focus.w = round((focus.w -interval*0.25) / interval ) * interval;
  focus.h = round((focus.h -interval*0.25) / interval ) * interval;
} 
void paste() {
  for (Obstacle o : clipBoard) {
    Obstacle temp =o.clone();
    temp.x+=mouseX/scaleFactor-cameraCoord.x;
    temp.y+=mouseY/scaleFactor-cameraCoord.y;

    //int interval=int(temp.h*0.5);
    int interval=int(temp.increment);
    if (interval<50)interval=50;
    int xRounded = round((temp.x -interval*0.25) / interval ) * interval;
    int yRounded = round((temp.y -interval*0.25) / interval ) * interval;
    temp.x=xRounded;
    temp.y=yRounded;
    obstacles.add(temp);
  }
}

