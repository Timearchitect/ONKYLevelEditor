void keyPressed() {
  if (!mousePressed) {
    key= Character.toLowerCase(key);
    println(key);
    println(keyCode);
    if (key=='a') {
    }
    Obstacle temp, temp2;
    switch(key) {
    case '': // ctrl+h
      JOptionPane.showMessageDialog(frame, 
      "[ctrl+s] save course\n[ctrl+l & ctrl+o] load/open course\n[ctrl+d] delete all obstacles\n[ctrl+x] cut obstacles\n[ctrl+c] copy obstacles \n[ctrl+v] paste obstacles\n[ctrl+z] undo change \n[Mouse LeftClick] add Obstacle  \n[Mouse RightClick] delete\n"+
        "[Mouse middleButton] pan\n[Mouse scroll] zoom\n[Mouse doubleclick] change obstacle attribute\n[a] previous obstacle \n[d] next obstacle\n[w] previous type  \n[s] next type \n[h] hide grid.");
      break;
    case 'h':
      hide=!hide;
      break;
    case '': //ctrl+s
      JFileChooser fileChooser = new JFileChooser();
      fileChooser.setDialogTitle("Specify a file to save");  

      fileChooser.setFileFilter(fileFilter);
      fileChooser.addChoosableFileFilter(fileFilter); 
      File dir2 = new File(dataPath(""));
      fileChooser.setCurrentDirectory (dir2);
      int userSelection = fileChooser.showSaveDialog(this);
      if (userSelection == JFileChooser.APPROVE_OPTION) {
        //fc.getSelectedFile(); 
        File fileToSave = fileChooser.getSelectedFile();
        System.out.println("Save as file: " + fileToSave.getAbsolutePath());
        myInputFile = fileToSave.getAbsolutePath();
        courseFilePath=myInputFile;

        if ( !myInputFile.substring(myInputFile.length()-5, myInputFile.length()).equals(".json"))courseFilePath+=".json";

        println("filename:"+fileToSave.getName());
        String[] sTemp= splitTokens(fileToSave.getName(), ".");
        courseName=sTemp[0];
        println("filePath:"+courseFilePath );

        background(255);
        saveChanged=true;
        exportJSON();
      } else { 
        println("Cancelled.");
      }

      break;
    case '': //ctrl+o
    case ''://ctrl+l
      fc.setDialogTitle("Load a json file");  
      fc.setFileFilter(fileFilter);
      fc.addChoosableFileFilter(fileFilter);
      returnVal = fc.showOpenDialog(this); 
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        record(); //record undostate
        File file = fc.getSelectedFile(); 
        myInputFile = file.getAbsolutePath();
        String[] sTemp= splitTokens(file.getName(), ".");
        courseName=sTemp[0];

        courseFilePath=myInputFile;
        println("filePath:"+courseFilePath );
        println("courseName:"+courseName+"  is loaded");

        background(255);
        saveChanged=true;
        importJSON();
      } else { 
        println("Cancelled.");
      }

      break;
    case 'a':
      rotateListElement(list.size()-1);
      listOrder=(listOrder+list.size()-1)%list.size();
      println(listOrder);
      break;
    case 'd':
      rotateListElement(1);
      listOrder=(listOrder+1)%list.size();
      println(listOrder);
      break;
    case 'w':
      list.get(0).changeType(1);
      for (Obstacle o : selected)if (list.get(0).getClass()==o.getClass()) o.type=list.get(0).type;
      if(selected.size()>0)record(); //record undostate
      break;
    case 's':
      list.get(0).changeType(-1);
      for (Obstacle o : selected)if (list.get(0).getClass()==o.getClass())o.type=list.get(0).type;
       if(selected.size()>0)record(); //record undostate
      break;
    case '1':
      break;
    case '2':
      break;
    case '3':
      break;
    case '4':
      break;
    case '5':
      break;
    case '6':
      break;
    case '7':
      break;
    case '8':
      break;
    case '9':
      break;
    case '-':

      scaleFactor-=0.05;
      cameraCoord.sub((width*0.5-mouseX)*scaleFactor, (height*0.5-mouseY)*scaleFactor, 0);
      scaleFactor=constrain(scaleFactor, 0.1, 2);

      break;
    case '+':

      scaleFactor+=0.05;
      cameraCoord.add((width*0.5-mouseX)*scaleFactor, (height*0.5-mouseY)*scaleFactor, 0);
      scaleFactor=constrain(scaleFactor, 0.1, 2);

      break;
    case '':// ctrl +c
      println("ctrl+c");
      clipBoard.clear();
      clipBoardCoord.set(mouseX, mouseY);
      for (Obstacle s : selected)clipBoard.add(s.clone());
      for (Obstacle o : clipBoard) {
        o.x-=mouseX/scaleFactor-cameraCoord.x; // offsetx
        o.y-=mouseY/scaleFactor-cameraCoord.y; // offsety
      }
      break;
    case  '': // ctrl+x
      println("ctrl+x");
      record(); //record undostate
      clipBoard.clear();
      clipBoardCoord.set(mouseX, mouseY);
      clipBoard.addAll(selected);
      obstacles.removeAll(selected);
      selected.clear();
      for (Obstacle o : clipBoard) {
        o.x-=mouseX/scaleFactor-cameraCoord.x; // offsetx
        o.y-=mouseY/scaleFactor-cameraCoord.y; // offsety
      }
      break;
    case '':// ctrl +v
      println("ctrl+v");
      pasteing=true;
      // obstacles.addAll(clipBoard);
      break;
    case '': // ctrl+d

      returnVal=JOptionPane.showConfirmDialog(null, "Do you want to delete all Obstacles?", "Confirm", 
      JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
      if (returnVal == JOptionPane.NO_OPTION) {
        System.out.println("No button clicked");
      } else if (returnVal == JOptionPane.YES_OPTION) {
        record(); //record undostate
        deleteAllObstacle();
      } else if (returnVal == JOptionPane.CLOSED_OPTION) {
        System.out.println("Cancel");
      }

      break;
    case '': // ctrl +z
      undo();
      break;
    }
    // background(255);

    int amount=200;
    switch(keyCode) {
   /* case 65:
      println("select All");
      for (Obstacle o : obstacles) if (!selected.contains(o)) selected.add(o);
      break;*/
    case DELETE:
      deleteSelected();
      break;
    case BACKSPACE:
      deleteSelected();
      break;
    case UP:
      cameraCoord.add(0, amount, 0);
      break;
    case DOWN:
      cameraCoord.add(0, -amount, 0);
      break;
    case LEFT:
      cameraCoord.add(amount, 0, 0);
      break;
    case RIGHT:
      cameraCoord.add(-amount, 0, 0);
      break;
    }
  }
}

void deleteSelected() {
  saveChanged=false;
  for (Obstacle o : selected)obstacles.remove(o);
  selected.clear();
  println("[selected is deleted]");
}
void deleteAllObstacle() {
  saveChanged=false;
  obstacles.clear();
  selected.clear();
  println("[all obstacle is deleted]");
}
void record() {
  ArrayList<Obstacle> temp=new  ArrayList<Obstacle> ();
  for (Obstacle o : obstacles)temp.add(o.clone());
  undoState.add(temp);
  println("recorded:"+undoState.size());
}
void undo() {
  if (undoState.size()>0) {
    selected.clear();
    obstacles.clear();
    for (Obstacle o : undoState.get (undoState.size ()-1)) {
      obstacles.add(o);
    }
    // obstacles = undoState.get(undoState.size()-1).copy();
    undoState.remove(undoState.size()-1);
    println("ctrl+z");
  }
  println("undo states left:"+undoState.size());
}

