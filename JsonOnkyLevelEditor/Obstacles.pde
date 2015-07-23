abstract class Obstacle implements Cloneable {  
  float impactForce, x, y, vx, vy, w=200, h=200;
  PVector coord, vel, accel, size;
  color obstacleColor;
  int increment=100,hitBrightness, defaultHealth=1, health=defaultHealth, type, maxType;
  String[] tooltip;
  String text="";
  boolean marked, randomized, stretchable, unBreakable, regenerating, underlay, highLight;
  PImage image;
  Obstacle() {
    health=defaultHealth;
    x=0;
    y=0;
    println( this.getClass().getSimpleName()+" created");
  }
  Obstacle(int _x, int _y) {
    x=_x;
    y=_y;
    health=defaultHealth;
  }
  void update() {
  }
  void display() {
    // noStroke();
    //  fill(obstacleColor);
    // rect(x, y, w, h);
    if (highLight)highLight();
  }
  void highLight() {
    stroke(255);
    strokeWeight(10);
    noFill();
    rect(x, y, w, h);
  }
  void changeType(int _amount) {
    type+=_amount;
    if (type>maxType)type=0;
    if (type<0)type=maxType;
  }
  public Obstacle clone() {  
    try {
      return (Obstacle)super.clone();
    }
    catch(CloneNotSupportedException e) {
      return null;
    }
  }
  void changeImage() {
  }
  void edit() {
  }
}

class Box extends Obstacle {
  int  count;
  Box() {
    super();
    maxType=3;
    obstacleColor = color(180, 140, 50);
    defaultHealth=2;
    randomized=true;
    type=0;
    //type=int(random(3));
    image=Box;
    tooltip=new String[maxType+1];
    tooltip[0]=" standard breakable obstacle.";
    tooltip[1]=" standard breakable obstacle skin.";
    tooltip[2]=" standard breakable obstacle with 3 tokens.";
    tooltip[3]=" standard breakable obstacle with random powerup.";
  }

  void changeType(int _amount) {
    super.changeType(_amount);
    changeImage();
  }
  void display() {
    changeImage();
    image(image, x, y, w, h);
    super.display();
  }
  void changeImage() {
    switch(type) {
    case 1:
      image=brokenBox;
      break;
    case 2:
      image=brokenBox;
      break;
    case 3:
      image=mysteryBox;
      break;
    default:
      image=Box;
    }
  }
}

class Tire extends Obstacle {
  float radianer, offset;
  Tire() {
    super();
    obstacleColor = color(0, 0, 0);
    defaultHealth=3;
    image=Tire;
    switch(int(random(4))) {
    case 0:
      radianer = HALF_PI;
      break;
    case 1:
      radianer = PI;
      break;
    case 2:
      radianer = PI+HALF_PI;
      break;
    case 3:
      radianer = PI*2;
      break;
    }
    tooltip=new String[maxType+1];
    tooltip[0]=" slowing breakable obstacle.";
  }

  void display() {
    pushMatrix();
    translate(x+w*0.5+random(-offset, offset), y+h*0.5+random(-offset, offset));
    rotate(radianer);
    image(image, -w*0.5-10, -h*0.5-10, w+20, h+20);
    popMatrix();
    //image(image, x, y, w, h);
    super.display();
  }
}
class IronBox extends Obstacle {
  int tx, ty, invis;
  IronBox() {
    super();
    obstacleColor = color(200);
    defaultHealth=5;
    health=defaultHealth;
    maxType=2;
    image=ironBox;
    tooltip=new String[maxType+1];
    tooltip[0]=" standard unbreakable obstacle.";
    tooltip[1]=" standard unbreakable obstacle damaged.";
    tooltip[2]=" standard unbreakable obstacle very damaged.";
  }
  void display() {
    changeImage();
    image(image, x, y, w, h);
    super.display();
  }
  void changeType(int _amount) {
    super.changeType(_amount);
    changeImage();
  }
  void changeImage() {
    switch(type) {
    case 1:
      image=ironBox2;
      break;
    case 2:
      image=ironBox3;
      break;
    default:
      image=ironBox;
    }
  }
}

class PlatForm extends Obstacle {
  boolean hanging;
  PlatForm() {
    super();
    image=Vines;
    w=50;
    h=50;
    defaultHealth=4;
    obstacleColor = color(255, 50, 50);
    tooltip=new String[maxType+1];
    tooltip[0]=" legacy breakable platform obstacle.";
    stretchable=true;
    increment=50;
  }
  PlatForm(int _x, int _y, int _w, int _h) {
    super(_x, _y);
    w=_w;
    h=_h;
    defaultHealth=4;
    obstacleColor = color(255, 50, 50);
  }
  PlatForm(int _x, int _y, int _w, int _h, boolean _hanging) {
    this( _x, _y, _w, _h);
    hanging=_hanging;
  }
  void display() {
    super.display();
    if (hanging) {
      stroke(200, 200, 200);
      strokeWeight(6);
      line(x, -1000, x, y);
      line(x+w, -1000, x+w, y);
      strokeWeight(1);
    }
    noStroke();
    fill(obstacleColor);
    rect(x, y, w, h);
  }
}

class Lumber extends Obstacle {
  boolean hanging;
  Lumber() {
    super();
    image=lumber;
    w=50;
    h=50;
    defaultHealth=4;
    obstacleColor = color(182, 69, 0);
    tooltip=new String[maxType+1];
    tooltip[0]=" standard breakable platform obstacle.";
    stretchable=true;
    increment=50;
  }
  Lumber(int _x, int _y, int _w, int _h) {
    super(_x, _y);
    w=_w;
    h=_h;
    defaultHealth=4;
    obstacleColor = color(182, 69, 0);
  }
  Lumber(int _x, int _y, int _w, int _h, boolean _hanging) {
    this( _x, _y, _w, _h);
    hanging=_hanging;
  }
  void display() {
    super.display();
    image(image, x, y, w, h);
    if (hanging) {
      for (int i= 0; i > -1000; i-=40) {
        image(Vines, x, y-80+i, 32, 80);
        image(Vines, x+w-32, y-80+i, 32, 80);
      }
    }
  }
}

class Glass extends Obstacle {
  Glass() {
    super();
    w=50;
    h=50;
    image=glass;
    obstacleColor = color(0, 150, 255, 100);
    defaultHealth=1;
    tooltip=new String[maxType+1];
    tooltip[0]=" breakable dodad.";
    stretchable=true;
  }
  Glass(int _x, int _y, int _w, int _h) {
    super(_x, _y);
    w=_w;
    h=_h;
    image=glass;
    obstacleColor = color(0, 150, 255, 100);
    defaultHealth=1;
  }
  Glass(int _x, int _y, int _w, int _h, boolean _regenerating) {
    this(_x, _y, _w, _h);
    regenerating=_regenerating;
  }
  void display() {
    super.display();
    image(image, x, y, w, h);
  }
}
class Block extends Obstacle {
  int invis;
  float ay=2;
  boolean scale;
  Block() {
    super();
    image=Block;
    obstacleColor = color(100, 100, 100);
    w=200;
    h=200;
    defaultHealth=20;
    tooltip=new String[maxType+1];
    tooltip[0]=" unbreakable enemy.";
  }
  Block(int _x, int _y) {
    super(_x, _y);
    obstacleColor = color(100, 100, 100);
    w=200;
    h=200;
    defaultHealth=20;
  }
  Block(int _x, int _y, int _vx, int _vy) {
    this(_x, _y);
    vx=_vx;
    vy=_vy;
  }

  void display() {
    super.display();
    if (invis>0)image(BlockSad, x, y, w, h);
    else image(Block, x, y, w, h);
    image(image, x, y, w, h);
  }
}

class Bush extends Obstacle {
  int debrisCooldown;
  Bush() {
    super();
    obstacleColor = color(0, 255, 50);
    image=Bush;
    w=100;
    h=100;
    health=1;
    tooltip=new String[maxType+1];
    tooltip[0]=" breakable dodad.";
  }
  Bush(int _x, int _y) {
    super(_x, _y);
    obstacleColor = color(0, 255, 50);
    w=100;
    h=100;
    image=Bush;
    health=1;
  }
  void display() {
    super.display();
    image(image, x, y, w, h);
  }
}
class Grass extends Obstacle {
  int margin=25;
  Grass() {
    super();
    image=Grass;
    obstacleColor = color(128, 181, 113);
    unBreakable=true;
    tooltip=new String[maxType+1];
    tooltip[0]=" unbreakable none interactive ground obstacle.";
    increment=50;
  }
  Grass(int _x, int _y, int _w, int _h) {
    super(_x, _y);
    w=_w;
    h=_h;
    image=Grass;
    obstacleColor = color(128, 181, 113);
    unBreakable=true;
  }
  void display() {
    super.display();
    fill(obstacleColor);
    noStroke();
    rect(x, y, w, 1000);
    image(image, x, y-margin, w, h);
  }
}
class Water extends Obstacle {
  int debrisCooldown, totalFrames=4;
  float count;
  PImage animSprite[]=new PImage[totalFrames];
  Water() {
    super();
    obstacleColor = color(81, 104, 151);
    unBreakable=true;
    for (int i=0; i<totalFrames; i++) {
      animSprite[i]=cutSprite(i);
    }
    image=animSprite[0];
    tooltip=new String[maxType+1];
    tooltip[0]=" water obstacle calls respawn on contact unless you on top of obstacle.";
  }

  PImage cutSprite (int index) {
    final int interval= 50, imageWidth=50, imageheight=50;
    return waterSpriteSheet.get(index*(interval+1), 0, imageWidth, imageheight);
  }
  void display() {
    super.display();
    count++;
    noStroke();
    fill(obstacleColor);
    rect(x, y+50, w, 1000);
    if (count%60<10)image(animSprite[0], x, y-50, w, h);
    else if (count%60<20)image(animSprite[1], x, y-50, w, h);
    else if (count%60<30)image(animSprite[2], x, y-50, w, h);
    else if (count%60<40)image(animSprite[3], x, y-50, w, h);
    else if (count%60<50)image(animSprite[2], x, y-50, w, h);
    else image(animSprite[1], x, y-50, w, h);
  }
}
class Sign extends Obstacle {
  int debrisCooldown;
  boolean trigg;
  Sign() {
    super();
    image=sign;
    obstacleColor = color(220, 180, 90);
    defaultHealth=1;
    //text=_text;
    underlay=true;
    tooltip=new String[maxType+1];
    tooltip[0]="sign obstacle.";
  }
  void display() {
    super.display();
    image(image, x, y, w, h);
    fill(0);
    textSize(30);
    textAlign(CENTER);
    text(text, x+w*0.5, y+h*0.3);
  }
  void edit() {
    text=JOptionPane.showInputDialog("Input sign text: ");
    if (text==null)text="";
  }
}
class Snake extends Obstacle {
  int debrisCooldown, totalFrames=3;
  float count;
  int snakeSpeed = -int(random(16)+1);
  PImage animSprite[]=new PImage[totalFrames];
  Snake() {
    super();
    obstacleColor = color(0, 255, 50);
    w=82*2;
    h=35*2;
    defaultHealth=1;
    for (int i=0; i<totalFrames; i++) {
      animSprite[i]=cutSprite(i);
    }
    image=animSprite[0];
    tooltip=new String[maxType+1];
    tooltip[0]="inflict poison powerdown effect.";
  }
  PImage cutSprite (int index) {
    final int interval= 82, imageWidth=82, imageheight=35;
    return Snake.get(index*(interval+1), 0, imageWidth, imageheight);
  }
  void display() {
    super.display();
    count++;
    if (count%30<10)image( animSprite[0], x, y-30, w, h);
    else if (count%30<20)image(animSprite[2], x, y-40, w, h);
    else image(animSprite[1], x, y-20, w, h);
  }
}

class Barrel extends Obstacle {
  float angle;
  Barrel() {
    super();
    obstacleColor = color(180, 120, 50);
    image=Barrel;
    defaultHealth=1;
    health=defaultHealth;
    vx=-2;
    tooltip=new String[maxType+1];
    tooltip[0]="moving/rolling breakable obstacle.";
  }
  /* Barrel(int _x, int _y) {
   super(_x, _y+67);
   obstacleColor = color(180, 120, 50);
   w=67*2;
   h=67*2;
   defaultHealth=1;
   health=defaultHealth;
   vx=-2;
   }*/
  void display() {
    super.display();
    angle--;
    pushMatrix();
    translate(x+w*0.5, y+h*0.5);
    rotate(radians(angle));
    image( image, -w*0.5, -w*0.5, w, h);
    popMatrix();
  }
}

class Rock extends Obstacle {
  int invis;
  Rock() {
    super();
    image=rock;
    obstacleColor = color(150);
    defaultHealth=7;
    tooltip=new String[maxType+1];
    tooltip[0]="unbreakable high health obstacle.";
  }
  void display() {
    super.display();
    image(image, x, y, w, h);
  }
}
class stoneSign extends Obstacle {
  int debrisCooldown;
  stoneSign() {
    super();
    obstacleColor = color(150);
    image=rockSign;
    defaultHealth=5;
    w=400;
    h=200;
    underlay=true;
    tooltip=new String[maxType+1];
    tooltip[0]="unbreakable large sign obstacle.";
  }
  void display() {
    super.display();
    image(image, x, y, w, h);
    fill(0);
    textSize(30);
    textAlign(CENTER);
    text(text, x+w*0.5, y+h*0.5);
  }
  void edit() {
    text=JOptionPane.showInputDialog("Input sign text: ");
    if (text==null)text="";
  }
}

