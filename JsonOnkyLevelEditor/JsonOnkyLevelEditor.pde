ArrayList<Obstacle> obstacles= new ArrayList<Obstacle>();
ArrayList<Obstacle> list= new ArrayList<Obstacle>();
int listOrder;
boolean hide;

Obstacle focus=null;

PImage Tire, Vines, rockSign, rock, lumber, glass, Bush, Box, brokenBox, mysteryBox, Leaf, rockDebris, Block, BlockSad, ironBox, ironBox2, ironBox3;
PImage  sign, Grass, waterSpriteSheet, Snake, Barrel;
float scaleFactor=0.5;
PVector cameraCoord= new PVector(0, 0);
//PVector pCameraCoord= new PVector(0, 0);
PVector defaultCourseSize= new PVector(2200, 1000);


JSONObject json= new JSONObject();
JSONObject course= new JSONObject();

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
  list.add(new Sign());
  list.add(new Barrel());
  list.add(new Rock());
  list.add(new stoneSign());
}

void draw() {

  background(100);
  pushMatrix();
  scale(scaleFactor);
  translate(cameraCoord.x, cameraCoord.y);

  fill(255, 255, 0);
  rect(0, 0, defaultCourseSize.x, defaultCourseSize.y);
  for (Obstacle o : obstacles)  o.display();

  popMatrix();
  if (!hide) showGrid();
  fill(255);

  if (focus!=null) { 
    rect(50, 50, focus.w*0.5, focus.h*0.5);
    image(focus.image, 50, 50, focus.w*0.5, focus.h*0.5);
  } else {
    rect(50, 50, 100, 100);
  }
  stroke(255);
  rect(50, height-100, 50, 50);
  for ( int i=0; i<list.size (); i++)
    image(list.get(i).image, 50+i*50, height-100, 50, 50);
  displayDebug();
}


void loadImages() {

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
void displayDebug() {
  fill(0);
  textSize(24);
  text(obstacles.size()+" obstacles", 100, height-100);
}


void exportJSON() {
  json.setJSONObject(courseName, course);

  JSONObject courseProperties = new JSONObject();
  courseProperties.setInt("courseSize", 2200);
  courseProperties.setInt("difficultyLevel", 0);
  courseProperties.setInt("randomAmount", 4);

  course.setJSONObject("courseProperties", courseProperties);
  println(" Course: "+courseName);

  for (int i = 0; i < obstacles.size (); i++) {
    JSONObject obstacle = new JSONObject();
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

