ArrayList<Obstacle> obstacles= new ArrayList<Obstacle>();
ArrayList<Obstacle> list= new ArrayList<Obstacle>();
int listOrder;
boolean hide;

Obstacle focus=null;
PImage  randomIcon, poisonIcon, slashIcon, laserIcon, superIcon, tokenIcon, lifeIcon, slowIcon, magnetIcon;
PImage Tire, Vines, rockSign, rock, lumber, glass, Bush, Box, brokenBox, mysteryBox, Leaf, rockDebris, Block, BlockSad, ironBox, ironBox2, ironBox3;
PImage  sign, Grass, waterSpriteSheet, Snake, Barrel;
float scaleFactor=0.5;
PVector cameraCoord= new PVector(0, 0);
//PVector pCameraCoord= new PVector(0, 0);
PVector defaultCourseSize= new PVector(2200, 1000);


JSONObject json= new JSONObject();
JSONObject course= new JSONObject();
int difficultyLevel=0, randomLevel=4;


String courseName ="testCourse";
void setup() {
  size( 1080, 720); // horisontal
  loadImages();
  list.add(new Box());
  list.add(new Tire());
  list.add(new IronBox());
  list.add(new Glass());
  list.add(new Block());
  list.add(new Bush());
  list.add(new Grass());
  list.add(new Lumber());
  list.add(new PlatForm());
  list.add(new Snake());
    list.add(new Water());
  list.add(new Sign());
  list.add(new Barrel());
  list.add(new Rock());
  list.add(new stoneSign());
  list.add(new TokenPowerup());
  list.add(new LifePowerup());
  list.add(new LaserPowerup());
  list.add(new TeleportPowerup());
  list.add(new InvisPowerup());
  list.add(new MagnetPowerup());
  list.add(new RandomPowerup());
  list.add(new PoisonPowerdown());
}

void draw() {
  background(100);
  pushMatrix();
  scale(scaleFactor);
  translate(cameraCoord.x, cameraCoord.y);
  displayCourseSize();
  for (Obstacle o : obstacles)  o.display();
  popMatrix();
  if (!hide) showGrid();
  fill(255);
  if (focus!=null) { 
    rect(50, 50, focus.w*0.5, focus.h*0.5);
    image(focus.image, 50, 50, focus.w*0.5, focus.h*0.5);
    fill(255);
    textSize(18);
    textAlign(LEFT);
    text(" Coord: "+ int(focus.x)+" , " +int(focus.y), 50, 80+focus.h*0.5);
    text(" Size: "+ int(focus.w)+" , " +int(focus.h), 50, 100+focus.h*0.5);
    text(" Tooltip: "+ focus.tooltip, 50, 120+focus.h*0.5);
    text(" Class: "+ focus.getClass().getSimpleName(), 50, 40);
  } else {
    rect(50, 50, 100, 100);
  }

  displayToolbar();
  displayDebug();
}


void loadImages() {
  //icons
  randomIcon = loadImage("icon/randomIcon.png");
  poisonIcon = loadImage("icon/poison.png");
  slowIcon = loadImage("icon/slowpower.png");
  slashIcon = loadImage("icon/slashpower.png");
  laserIcon = loadImage("icon/laserpower2.png");
  tokenIcon = loadImage("icon/token2.png");
  superIcon = loadImage("icon/speedpower.png");
  lifeIcon = loadImage("icon/oneup.png");
  magnetIcon = loadImage("icon/magnet.png");

  //Obstacle graphics
  rockSign=loadImage("stoneSign.png");
  rock=loadImage("rock.png");
  Snake=loadImage("snake.png");
  Barrel=loadImage("barrel.png");
  Tire= loadImage("tire.png");
  ironBox = loadImage("metalBox1.png");
  ironBox2= loadImage("metalBox2.png");
  ironBox3= loadImage("metalBox3.png");
  Box= loadImage("woodenBox.png");
  glass = loadImage("glass.png");
  brokenBox= loadImage("woodenBoxBroken.png");
  mysteryBox= loadImage("mysteryWoodenBox.png");
  Grass= loadImage("grasstile.png");
  Bush = loadImage("bush.png");
  sign= loadImage("sign.png");
  Vines = loadImage("vines.png");
  lumber= loadImage("lumber22.png");
  //lumberR= loadImage("lumber33.png");
  //lumberL= loadImage("lumber11.png");
  //Wood= loadImage("wood.png");
  waterSpriteSheet= loadImage("watertile.png");
  Block = loadImage("blockMad.png");
  BlockSad = loadImage("blockSad.png");
}
void displayCourseSize() {
  fill(0);
  textSize(30);
  text("courseSize: "+int(defaultCourseSize.x) +" , " +int(defaultCourseSize.y), 0, -50 );
  fill(255, 255, 0, 100);
  rect(0, 0, defaultCourseSize.x, defaultCourseSize.y);
}
void showGrid() {
  float interval=200;
  stroke(0, 255, 0);
  strokeWeight(2);
  for (int i=0; i< (width); i+=interval*scaleFactor) {
    float xLine=i+((cameraCoord.x)%interval)*scaleFactor;
    line(xLine, 0, xLine, height);
  }
  for (int i=0; i< (height); i+=interval*scaleFactor) {
    float yLine=i+((cameraCoord.y)%interval)*scaleFactor;
    line(0, yLine, width, yLine);
  }
}
void displayToolbar() {
  stroke(255);
  strokeWeight(20);
  rect(50, height-120, 50, 50);
  image(list.get(0).image, 50, height-120, 50, 50);
  for ( int i=1; i<list.size (); i++)image(list.get(i).image, 50+i*60, height-100, 50, 50);
  image(list.get(list.size()-1).image, -10, height-100, 50, 50);
  noStroke();
}
void displayDebug() {
  fill(0);
  textSize(30);
  text(obstacles.size()+" obstacles", 100, height-15);
}
Obstacle getObstacleOnClassName(String name) {
  Obstacle temp=null;
  for (Obstacle e : list) {
    if (name.equals(e.getClass().getSimpleName())) temp=e.clone();
  }
  println(temp.getClass().getSimpleName()+ "is found");
  return temp;
}
void importJSON() {
  JSONObject json = loadJSONObject(courseName+".json");
  //  println(json);
  JSONObject testCourse= json.getJSONObject("testCourse");
  JSONObject courseProperties= testCourse.getJSONObject("courseProperties");
  println( "courseSize: "+ courseProperties.getInt("courseSize")) ;
  println( "difficultyLevel: "+ courseProperties.getInt("difficultyLevel")) ;
  println( "randomAmount: "+ courseProperties.getInt("randomAmount")) ;

  println(testCourse.size());
  println(testCourse.keys());
  String[] obstacle = splitTokens(testCourse.keys().toString(), ",[] ");
  println(obstacle);
  for (int i = 0; i < testCourse.size ()-1; i++) {
    if (!obstacle[i].equals("courseProperties")) {
      JSONObject element = testCourse.getJSONObject(obstacle[i]);
      println(element);

      Obstacle correspondingObstacle= getObstacleOnClassName(element.getString("class"));
      correspondingObstacle.x=element.getInt("xCoord");
      correspondingObstacle.y=element.getInt("yCoord");
      obstacles.add(correspondingObstacle);
    }
  }
  println("[loaded at data/"+courseName+".json}");
}

void exportJSON() {
  json.setJSONObject(courseName, course);

  JSONObject courseProperties = new JSONObject();
  courseProperties.setString("name", courseName);
  courseProperties.setInt("courseSize", int(defaultCourseSize.x));
  courseProperties.setInt("difficultyLevel", difficultyLevel);
  courseProperties.setInt("randomAmount", randomLevel);

  course.setJSONObject("courseProperties", courseProperties);
  println(" Course: "+courseName);

  for (int i = 0; i < obstacles.size (); i++) {
    JSONObject obstacle = new JSONObject();
    obstacle.setString("class", obstacles.get(i).getClass().getSimpleName());
    obstacle.setInt("id", i);
    obstacle.setInt("xCoord", int(obstacles.get(i).x));
    obstacle.setInt("yCoord", int(obstacles.get(i).y));
    course.setJSONObject(obstacles.get(i).getClass().getSimpleName()+i, obstacle);
    println(i+" "+ obstacles.get(i).getClass().getSimpleName()+ " obstacle is exported");
  }

  saveJSONObject(json, "data/"+courseName+".json");
  println("[saved at data/"+courseName+".json}");
}

/*void exportJSON() {
 json.setJSONObject(courseName, course);
 
 JSONObject courseProperties = new JSONObject();
 courseProperties.setInt("courseSize", 2200);
 courseProperties.setInt("difficultyLevel", 0);
 courseProperties.setInt("randomAmount", 4);
 
 course.setJSONObject("courseProperties", courseProperties);
 println(" Course: "+courseName);
 
 for (int i = 0; i < klass.length; i++) {
 JSONObject obstacle = new JSONObject();
 obstacle.setInt("id", i);
 obstacle.setInt("xCoord", xCoord[i]);
 obstacle.setInt("yCoord", yCoord[i]);
 course.setJSONObject(klass[i], obstacle);
 println(i+" "+ klass[i]+ " obstacle is exported");
 }
 
 saveJSONObject(json, "data/"+courseName+".json");
 println("[saved at data/"+courseName+".json}");
 }*/


void rotateListElement(int index) {

  ArrayList<Obstacle> tempList=  new ArrayList(list.subList(0, index));
  print(" cutted:");
  for (Obstacle line : tempList) {
    print(line.getClass().getSimpleName()+" ");
  }
  println("");

  for ( int i=index-1; i>=0; i--) {
    list.remove(i);
  }
  print(" left:");
  for (Obstacle line : list) {
    print(line.getClass().getSimpleName()+" ");
  }
  println("");

  list.addAll(tempList);

  print(" listed:");
  for (Obstacle line : list) {
    print(line.getClass().getSimpleName()+" ");
  }
  println("");
  //  return new ArrayList(list.subList(0, index));
}

