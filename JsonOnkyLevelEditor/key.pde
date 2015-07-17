void keyPressed() {
  key= Character.toLowerCase(key);
  if (key=='a') {
  }
    Obstacle temp,temp2;
  switch(key) {

  case 'a':
    background(255);
    exportJSON();
    break;
  case '0':
    background(255);

    break;
  case '1':
    background(255);
     temp=list.get(1);
     temp2=list.get(0);
    list.set(0,temp);
    list.set(1,temp2);

    break;
  case '2':
    background(255);
      temp=list.get(2);
     temp2=list.get(0);
    list.set(0,temp);
    list.set(2,temp2);
    break;
  case '3':
    background(255);
    break;
  case '4':
    background(255);
    break;
  case '5':
    background(255);
    break;
  case '6':
    background(255);
    break;
  case '7':
    background(255);
    break;
  case '8':
    background(255);
    break;
  case '9':
    background(255);
    break;
  }

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

