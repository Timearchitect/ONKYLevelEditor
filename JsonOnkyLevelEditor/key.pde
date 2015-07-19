void keyPressed() {
  if (!mousePressed) {
    key= Character.toLowerCase(key);
    println(key);
    if (key=='a') {
    }
    Obstacle temp, temp2;
    switch(key) {
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
        exportJSON();
      } else { 
        println("Cancelled.");
      }

      break;
    case ''://ctrl+l
      fc.setDialogTitle("Load a json file");  

      fc.setFileFilter(fileFilter);
      fc.addChoosableFileFilter(fileFilter);
      returnVal = fc.showOpenDialog(this); 
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        File file = fc.getSelectedFile(); 
        myInputFile = file.getAbsolutePath();
        String[] sTemp= splitTokens(file.getName(), ".");
        courseName=sTemp[0];
       
        courseFilePath=myInputFile;
        println("filePath:"+courseFilePath );
        println("courseName:"+courseName+"  is loaded");

        background(255);
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
      break;
    case 's':
      list.get(0).changeType(-1);
      for (Obstacle o : selected)if (list.get(0).getClass()==o.getClass())o.type=list.get(0).type;
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
    case '':
      obstacles.clear();
      selected.clear();
      println("[all obstacle is deleted]");
      break;
    }
    // background(255);

    int amount=200;
    switch(keyCode) {
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
  for (Obstacle o : selected)obstacles.remove(o);
  selected.clear();
  println("[selected is deleted]");
}

