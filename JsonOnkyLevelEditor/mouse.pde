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
        if (focus==null) { // regular add
          record(); //record undostate
          addObstacle();
        } else { // select 
          searchFocusableObstacle();
          select(focus);
          if (focus.directed)directing=true; // directing velocity
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
    if ( focus==null) {
      if (!directing) addObstacle();
    } else {
      stretch();
    }
    direct();
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
      // removeSameOverlapTiles();
    }
    directing=false;
    streching=false;
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
  boolean add=true;
  int interval=int(list.get(0).increment);

  // int xRounded = int(((mouseX/scaleFactor-cameraCoord.x) -interval*0.25) / interval ) * interval;
  // int yRounded = int(((mouseY/scaleFactor-cameraCoord.y) -interval*0.25) / interval ) * interval;
  // int xRounded=interval * int((mouseX/scaleFactor-cameraCoord.x-interval*0.5) / interval + 0.5);
 // int yRounded=interval * int((mouseY/scaleFactor-cameraCoord.y-interval*0.5) / interval + 0.5);
 // int xRounded=int(interval * int((mouseX/scaleFactor-cameraCoord.x-interval*0.5) / interval + 0.5)-interval*0.5);
  //int yRounded=int(interval * int((mouseY/scaleFactor-cameraCoord.y-interval*0.5) / interval + 0.5)-interval*0.5);
 //  int xRounded=interval * int((mouseX/scaleFactor-cameraCoord.x-interval*1) / interval + 0.5);
  //int yRounded=interval * int((mouseY/scaleFactor-cameraCoord.y-interval*1) / interval + 0.5);
   int xRounded=interval * int((mouseX/scaleFactor-cameraCoord.x-list.get(0).w*0.5) / interval + 0.5);
  int yRounded=interval * int((mouseY/scaleFactor-cameraCoord.y-list.get(0).h*0.5) / interval + 0.5);
  list.get(0).x=xRounded;
  list.get(0).y=yRounded;
  if (obstacles.size()>0) {
    println( "list: "+list.get(0).x +" : "+list.get(0).y );
    for (int i = 0; i<obstacles.size (); i++) {
      println( "obstacle: "+obstacles.get(i).x +" : "+obstacles.get(i).y );
      if (obstacles.get(i).x == list.get(0).x && obstacles.get(i).y == list.get(0).y  ) {
        add=false;
      }
    }
  } 
  if (add)obstacles.add(list.get(0).clone());
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
void  direct() {
  if (focus!=null && focus.directed) {
    println("direct");
    int sx=int(int(mouseX/scaleFactor-cameraCoord.x)-focus.x-focus.w*0.5);
    int sy=int(int(mouseY/scaleFactor-cameraCoord.y)-focus.y-focus.h*0.5);
    focus.vx=sx*directionScale;
    focus.vy=sy*directionScale;
  }
  for (Obstacle s : selected) {
    if (s.directed) {
      println("direct");
      int scalex=int(int(mouseX/scaleFactor-cameraCoord.x)-s.x-s.w*0.5);
      int scaley=int(int(mouseY/scaleFactor-cameraCoord.y)-s.y-s.h*0.5);
      s.vx=scalex*directionScale;
      s.vy=scaley*directionScale;
    }
  }
}


void GridInline() {
  focus.x = round((focus.x) / focus.increment ) * focus.increment;
  focus.y = round((focus.y) / focus.increment ) * focus.increment;
  focus.w = round((focus.w) / focus.increment ) * focus.increment;
  focus.h = round((focus.h) / focus.increment ) * focus.increment;
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

/*void removeSameOverlapTiles() {
 println("!!!!!!!!!");
 if (obstacles.size()>0) {
 for (int i = obstacles.size ()-1; i>=0; i--) {
 for (int j = obstacles.size ()-1; j>=0; j--) {
 println(list.get(0).getClass());
 if (obstacles.get(i)!=obstacles.get(j)&& list.get(0).getClass().isInstance(obstacles.get(i))) {
 if (obstacles.get(i).x+obstacles.get(i).w >= obstacles.get(j).x && obstacles.get(j).x+obstacles.get(j).w > obstacles.get(i).x) {
 //obstacles.remove(i);
 obstacles.get(i).dead=true;
 println("stacked/ overlaped removed");
 }
 }
 }
 }
 for (int i = obstacles.size ()-1; i>=0; i--) {
 if (obstacles.get(i).dead)obstacles.remove(i);
 }
 }
 }
 */
