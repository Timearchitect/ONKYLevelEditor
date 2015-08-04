abstract class Powerup implements Cloneable {
  PImage image;
  boolean regenerating, instant=true, toggle, homing, gravity;
  float angle, x, y, vx, vy, w=200, h=200, offsetX, offsetY;
  float  time, spawnTime;
  color obstacleColor= color(255);
  int upgradeLevel=int(random(4)), pulse;
  Powerup(int _x, int _y, int _time) {
    // super(_x, _y);
    time=_time;
    spawnTime=_time;
    x=_x;
    y=_y;
    w=100;
    h=100;
  
  }
  void display() {
    if (!instant) { 
      noStroke();
      fill(obstacleColor);
      ellipse(x+offsetX, y+offsetY, w+40, h+40);
    }
    image(image, x-w*0.5+offsetX, y-h*0.5+offsetY, w, h);
  }
}
class TokenPowerup extends Obstacle {
  TokenPowerup() {
    super();
    obstacleColor=color(255);
    image= tokenIcon;
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" valueble token used as ingame currency.";
    increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x+12, y+12, 75, 75);
  }
}

class InvisPowerup extends Obstacle {
  boolean first=true;
  InvisPowerup() {
    super();
    obstacleColor=color(255, 200, 0);
    image = superIcon;
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" grants player invinciblity.";
   increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
    void changeType(int _amount) {
    super.changeType(_amount);
  }
}

class LaserPowerup extends Obstacle {
  LaserPowerup() {
    super();
    image=laserIcon;
    obstacleColor=color(255, 0, 0);
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" grants player lasershooting.";
      increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
      void changeType(int _amount) {
    super.changeType(_amount);
  }
}

class SlowPowerup extends Obstacle {
  SlowPowerup() {
    super();
    obstacleColor=color(100, 100, 100);
    image=slowIcon;
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" grants player slowmotion.";
      increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
      void changeType(int _amount) {
    super.changeType(_amount);
  }
}
class LifePowerup extends Obstacle {
  LifePowerup() {
    super();
    //powerups.add( this);
    obstacleColor=color(50, 255, 50);
    image= lifeIcon;
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" grants player extra life.";
      increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
      void changeType(int _amount) {
    super.changeType(_amount);
  }
}
class TeleportPowerup extends Obstacle {
  int distance=900;
  boolean first=true;
  TeleportPowerup() {
    super();
    //powerups.add( this);
    obstacleColor=color(0, 50, 255);
    image= slashIcon;
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" grants player short teleport.";
      increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
      void changeType(int _amount) {
    super.changeType(_amount);
  }
}

class MagnetPowerup extends Obstacle {
  int range;
  MagnetPowerup() {
    super();
    obstacleColor=color(220, 0, 220);
    image=magnetIcon;
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" grants player token attraction.";
    increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
      void changeType(int _amount) {
    super.changeType(_amount);
  }
}

class RandomPowerup extends Obstacle {
  RandomPowerup() {
    super();
    w=100;
    h=100;
    image=randomIcon;
    tooltip=new String[maxType+1];
    tooltip[0]=" spawn random powerup.";
      increment=50;
  }
  RandomPowerup(int _x, int _y, int _time) {
    super(_x, _y);
    //icon= tokenIcon;
    //obstacleColor=color(100, 100, 100);
    switch(int(random(6))) {
    case 0:
      //powerups.add( new InvisPowerup( _x, _y, _time)); 
      break;
    case 1:
      //  powerups.add( new LaserPowerup( _x, _y, _time) );
      break;
    case 2:
      // powerups.add( new SlowPowerup( _x, _y, _time, false) );
      break;
    case 3:
      // powerups.add( new LifePowerup( _x, _y, _time) );
      break;
    case 4:
      // powerups.add( new  TeleportPowerup( _x, _y, _time, false) );
      break;
    case 5:
      // powerups.add( new  MagnetPowerup( _x, _y, _time, false) );
      break;
    default:
      // powerups.add( new TokenPowerup( _x, _y, _time));
    }
      increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
    void changeType(int _amount) {
    super.changeType(_amount);
  }
}

class PoisonPowerdown extends Obstacle {
  PoisonPowerdown() {
    super();
    obstacleColor=color(0, 255, 0);
    image=poisonIcon;
    w=100;
    h=100;
    tooltip=new String[maxType+1];
    tooltip[0]=" inflicts player with tokendrop curse.";
      increment=50;
  }
  void display() {
    super.display();
    /* if (!instant) { 
     noStroke();
     fill(obstacleColor);
     ellipse(x+offsetX, y+offsetY, w+40, h+40);
     }*/
    image(image, x, y, w, h);
  }
      void changeType(int _amount) {
    super.changeType(_amount);
  }
}

