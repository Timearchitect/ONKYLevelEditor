abstract class Obstacle implements Cloneable {  
  float impactForce, x, y, vx, vy, w=200, h=200;
  PVector coord, vel, accel, size;
  color obstacleColor;
  int hitBrightness, defaultHealth=1, health=defaultHealth, type;
  String tooltip="";
  boolean randomized, stretchable, unBreakable, regenerating, underlay, highLight;
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
  public Obstacle clone() {  
    try {
      return (Obstacle)super.clone();
    }
    catch(CloneNotSupportedException e) {
      return null;
    }
  }
}

class Box extends Obstacle {
  int type, count;
  Box() {
    super();
    obstacleColor = color(180, 140, 50);
    defaultHealth=2;
    randomized=true;
    type=int(random(3));
    switch(type) {
    case 0:
      image=Box;
      break;
    case 1:
      image=brokenBox;
      break;
    case 2:
      image=brokenBox;
      break;
    default:
      image=mysteryBox;
    }
    tooltip=" standard breakable obstacle.";
  }
  Box(int _x, int _y) {
    super(_x, _y);
    obstacleColor = color(180, 140, 50);
    defaultHealth=2;
    type=int(random(3));
    switch(type) {
    case 0:
      image=Box;
      break;
    case 1:
      image=brokenBox;
      break;
    case 2:
      image=brokenBox;
      break;
    default:
      image=mysteryBox;
    }
  }
  Box(int _x, int _y, int _type) {
    this(_x, _y);
    type=_type;
  }
  Box(int _x, int _y, int _type, boolean _regenerating) {
    this(_x, _y, _type);
    regenerating=_regenerating;
  }

  void display() {
    image(image, x, y, w, h);
    super.display();
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
    tooltip=" slowing breakable obstacle.";
  }
  Tire(int _x, int _y) {
    super(_x, _y);
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
    if (health==5) {
      image=ironBox;
    } else if (health>2) {
      image=ironBox2;
    } else {
      image=ironBox3;
    }
    tooltip=" standard unbreakable obstacle.";
  }
  IronBox(int _x, int _y) {
    super(_x, _y);
    obstacleColor = color(200);
    tx=_x;
    ty=_y;
    defaultHealth=5;
    health=defaultHealth;
    if (health==5) {
      image=ironBox;
    } else if (health>2) {
      image=ironBox2;
    } else {
      image=ironBox3;
    }
  }
  IronBox(int _x, int _y, boolean _regenerating) {
    this(_x, _y);
    regenerating=_regenerating;
  }
  void display() {
    image(image, x, y, w, h);
    super.display();
  }
}

class PlatForm extends Obstacle {
  boolean hanging;
  PlatForm() {
    super();
    image=Vines;
    w=100;
    h=100;
    defaultHealth=4;
    obstacleColor = color(255, 50, 50);
    tooltip=" legacy breakable platform obstacle.";
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
    w=100;
    h=100;
    defaultHealth=4;
    obstacleColor = color(182, 69, 0);
    tooltip=" standard breakable platform obstacle.";
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
    w=100;
    h=100;
    image=glass;
    obstacleColor = color(0, 150, 255, 100);
    defaultHealth=1;
    tooltip=" breakable dodad.";

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
        tooltip=" unbreakable enemy.";
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
    tooltip=" breakable dodad.";

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
  }
  Grass(int _x, int _y, int _w, int _h) {
    super(_x, _y);
    w=_w;
    h=_h;
    image=Grass;

    obstacleColor = color(128, 181, 113);
    unBreakable=true;
    tooltip=" unbreakable none interactive ground obstacle.";

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
  Water(int _x, int _y, int _w, int _h) {
    super(_x, _y);
    w=_w;
    h=_h;
    obstacleColor = color(81, 104, 151);
    unBreakable=true;
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
  String text;
  boolean trigg;
  Sign() {
    super();

    image=sign;
    obstacleColor = color(220, 180, 90);
    defaultHealth=1;
    //text=_text;
    underlay=true;
  }
  Sign(int _x, int _y, String _text) {
    super(_x, _y);
    obstacleColor = color(220, 180, 90);
    w=200;
    h=200;
    defaultHealth=1;
    text=_text;
    image=sign;

    underlay=true;
  }
  Sign(int _x, int _y, String _text, boolean _trigg) {
    this(_x, _y, _text);
    trigg=_trigg;
  }

  void display() {
    super.display();

    image(image, x, y, w, h);
    fill(0);
    textSize(30);
    textAlign(CENTER);
    //text(text, x+w*0.5, y+h*0.3);
  }
}
class Snake extends Obstacle {
  int debrisCooldown, totalFrames=3;
  float count;
  int snakeSpeed = -int(random(16)+1);
  PImage animSprite[]=new PImage[totalFrames];
  Snake(int _x, int _y) {
    super(_x, _y);
    obstacleColor = color(0, 255, 50);
    w=82*2;
    h=35*2;
    defaultHealth=1;
  }
  void display() {
    super.display();

    if (count%30<10)image( animSprite[0], x+w*.5, y-30, w, h);
    else if (count%30<20)image(animSprite[2], x+w*.5, y-40, w, h);
    else image(animSprite[1], x+w*.5, y-20, w, h);
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
  }
  Barrel(int _x, int _y) {
    super(_x, _y+67);
    obstacleColor = color(180, 120, 50);
    w=67*2;
    h=67*2;
    defaultHealth=1;
    health=defaultHealth;
    vx=-2;
  }
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
  }
  Rock(int _x, int _y) {
    super(_x, _y);
    image=rock;
    obstacleColor = color(150);
    defaultHealth=7;
  }
  void display() {
    super.display();

    image(image, x, y, w, h);
  }
}
class stoneSign extends Obstacle {
  int debrisCooldown;
  String text;
  stoneSign() {
    super();
    obstacleColor = color(150);
    image=rockSign;
    defaultHealth=5;
    //text=_text;
    w=400;
    h=200;
    underlay=true;
  }
  stoneSign(int _x, int _y, String _text) {
    super(_x, _y);
    obstacleColor = color(150);
    w=400;
    h=200;
    image=rockSign;

    defaultHealth=5;
    text=_text;
    underlay=true;
  }

  void display() {
    super.display();
    image(image, x, y, w, h);
    fill(0);
    textSize(30);
    textAlign(CENTER);
    //text(text, x+w*0.5, y+h*0.5);
  }
}

