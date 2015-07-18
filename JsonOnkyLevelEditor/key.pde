void keyPressed() {
  key= Character.toLowerCase(key);
  if (key=='a') {
  }
  Obstacle temp, temp2;
  switch(key) {
  case 'h':
    hide=!hide;
    break;
  case '': //ctrl+s
    background(255);
    exportJSON();
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
  case 'l':
    importJSON();
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
  }
  // background(255);

  int amount=200;
  switch(keyCode) {

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

