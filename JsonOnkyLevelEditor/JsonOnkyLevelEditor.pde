import javax.swing.*; 
import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;
String myInputFile ;

final JFileChooser fc = new JFileChooser(); 
int returnVal;
FileFilter fileFilter = new ExtensionFileFilter(".json", new String[] { 
  "json"
}
);
ArrayList<ArrayList<Obstacle>> undoState = new ArrayList<ArrayList<Obstacle>>();
ArrayList<Obstacle> obstacles= new ArrayList<Obstacle>();
ArrayList<Obstacle> list= new ArrayList<Obstacle>();
ArrayList<Obstacle> selected= new ArrayList<Obstacle>();
ArrayList<Obstacle> clipBoard= new ArrayList<Obstacle>();
PVector clipBoardCoord= new PVector();
int listOrder;
boolean first=true, hide, pasteing, directing, streching;

Obstacle focus=null;
PImage  randomIcon, poisonIcon, slashIcon, laserIcon, superIcon, tokenIcon, lifeIcon, slowIcon, magnetIcon;
PImage Tire, Vines, rockSign, rock, lumber, glass, Bush, Box, brokenBox, mysteryBox, Leaf, rockDebris, Block, BlockSad, ironBox, ironBox2, ironBox3;
PImage  sign, Grass, waterSpriteSheet, Snake, Barrel;
float scaleFactor=0.5, directionScale=0.1;
PVector cameraCoord= new PVector(0, 0);
//PVector pCameraCoord= new PVector(0, 0);
PVector defaultCourseSize= new PVector(2200, 1000);

JSONObject json= new JSONObject();
JSONObject course= new JSONObject();
int difficultyLevel=0, randomLevel=4;

String courseName ="testCourse";
String courseFilePath;
boolean transparent, saveChanged=true;
void setup() {
  changeAppIcon( loadImage("icon/Qwerty-icon.png") );
  changeAppTitle("QWERTY");
  ((JFrame)frame).setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE); // disable first Jframe level listener of close
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
  list.add(new StoneSign());
  list.add(new TokenPowerup());
  list.add(new LifePowerup());
  list.add(new LaserPowerup());
  list.add(new TeleportPowerup());
  list.add(new InvisPowerup());
  list.add(new MagnetPowerup());
  list.add(new RandomPowerup());
  list.add(new PoisonPowerdown());
  if (frame != null) {
    frame.setResizable(true);
  }
  File dir = new File(dataPath(""));
  fc.setCurrentDirectory (dir);
  first=false;
}

void draw() {
  background(100);
  pushMatrix();
  scale(scaleFactor);
  translate(cameraCoord.x, cameraCoord.y);
  displayCourseSize();
  if (transparent)tint(255, 150);
  for (Obstacle o : obstacles) {
    o.display();
    o.direction();
  }

  if (transparent)noTint();
  for (Obstacle o : selected)  o.highLight();

  /*  if (pasteing) {
   tint(255,100);
   for (Obstacle o : clipBoard)o.display();
   noTint();
   }*/
  popMatrix();
  if (!hide) showGrid();
  fill(255);

  if (selected.size()>0) {
    for (int i=selected.size ()-1; 0<=i; i--) {
      image(selected.get(i).image, 50+(i)*20, 50, selected.get(i).w*0.5, selected.get(i).h*0.5);
    }
  } 
  if (focus!=null) { 
    rect(50, 50, focus.w*0.5, focus.h*0.5);
    image(focus.image, 50, 50, focus.w*0.5, focus.h*0.5);
    fill(255);
    textSize(18);
    textAlign(LEFT);
    text(" Coord: "+ int(focus.x)+" , " +int(focus.y), 50, 80+focus.h*0.5);
    text(" Size: "+ int(focus.w)+" , " +int(focus.h), 50, 100+focus.h*0.5);
    text(" velocity: "+ int(focus.vx)+" , " +int(focus.vy), 50, 120+focus.h*0.5);
    text(" Tooltip: "+ focus.tooltip[focus.type], 50, 140+focus.h*0.5);
    text(" Class: "+ focus.getClass().getSimpleName(), 50, 40);
  } else if (selected.size()==0) {
    rect(50, 50, 100, 100);
  }
  if (pasteing) { // paste objects
    pushMatrix();
    scale(scaleFactor);
    translate(mouseX/scaleFactor, mouseY/scaleFactor);

    //translate(cameraCoord.x*scaleFactor+mouseX/scaleFactor, cameraCoord.y*scaleFactor+mouseY/scaleFactor);
    tint(255, 100);
    for (Obstacle o : clipBoard)
      o.display();
    noTint();
    popMatrix();
  }
  displayToolbar();
  displayDebug();
  fill(0, 255, 0);
  textSize(10);
  textAlign(LEFT);
  text(mouseX+" : "+mouseY, mouseX-50, mouseY-20);
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
  if (scaleFactor>.4)strokeWeight(2);
  else   strokeWeight(1);
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
  text(obstacles.size()+" obstacles  "+ selected.size() +" selected", 100, height-15);
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
  JSONObject course= json.getJSONObject(courseName);
  JSONObject courseProperties= course.getJSONObject("courseProperties");
  println( "courseSize: "+ courseProperties.getInt("courseSize")) ;
  println( "difficultyLevel: "+ courseProperties.getInt("difficultyLevel")) ;
  println( "randomAmount: "+ courseProperties.getInt("randomAmount")) ;
  println(course.size());
  println(course.keys());
  String[] entity = splitTokens(course.keys().toString(), ",[] ");
  println(entity);
  for (int i = 0; i < course.size (); i++) {
    if (!entity[i].equals("courseProperties")) {
      JSONObject element = course.getJSONObject(entity[i]);
      println(element);
      Obstacle correspondingObstacle= getObstacleOnClassName(element.getString("class"));
      correspondingObstacle.type=element.getInt("type"); 
      correspondingObstacle.x=element.getInt("xCoord");
      correspondingObstacle.y=element.getInt("yCoord");
      try {correspondingObstacle.w=element.getInt("xSize");} catch (Exception e) { }
      try {correspondingObstacle.h=element.getInt("ySize");} catch (Exception e) { }
      try {correspondingObstacle.text=element.getString("text");} catch (Exception e) { }
      try {correspondingObstacle.vx=element.getInt("xVel");} catch (Exception e) { }
      try {correspondingObstacle.vy=element.getInt("yVel");} catch (Exception e) { }

      obstacles.add(correspondingObstacle);
    }
  }
  println("[loaded at data/"+courseName+".json]");
}

void exportJSON() {
  json=new JSONObject();
  course=new JSONObject();

  json.setJSONObject(courseName, course);

  JSONObject courseProperties = new JSONObject();
  courseProperties.setString("name", courseName);
  courseProperties.setInt("courseSize", int(defaultCourseSize.x));
  courseProperties.setInt("difficultyLevel", difficultyLevel);
  courseProperties.setInt("minSpeedLevel", 0);
  courseProperties.setInt("maxSpeedLevel", 5);
  courseProperties.setInt("randomAmount", randomLevel);

  course.setJSONObject("courseProperties", courseProperties);
  println(" Course: "+courseName);

  for (int i = 0; i < obstacles.size (); i++) {
    JSONObject entity = new JSONObject();
    entity.setString("class", obstacles.get(i).getClass().getSimpleName());
    entity.setInt("id", i);
    entity.setInt("type", int(obstacles.get(i).type));
    entity.setInt("xCoord", int(obstacles.get(i).x));
    entity.setInt("yCoord", int(obstacles.get(i).y));
    entity.setInt("xSize", int(obstacles.get(i).w));
    entity.setInt("ySize", int(obstacles.get(i).h));
    if ( !obstacles.get(i).text.equals(""))entity.setString("text", obstacles.get(i).text); 
    if ( obstacles.get(i).vx!=0)entity.setInt("xVel", int(obstacles.get(i).vx)); 
    if ( obstacles.get(i).vy!=0)entity.setInt("yVel", int(obstacles.get(i).vy)); 
    course.setJSONObject(obstacles.get(i).getClass().getSimpleName()+i, entity);
    println(i+" "+ obstacles.get(i).getClass().getSimpleName()+ " obstacle is exported");
  }

  //saveJSONObject(json, "data/"+courseName+".json");
  saveJSONObject(json, courseFilePath);
  println("[saved at data/"+courseName+".json]");
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
  /* print(" cutted:");
   for (Obstacle line : tempList) {
   print(line.getClass().getSimpleName()+" ");
   }
   println("");
   */
  for ( int i=index-1; i>=0; i--) {
    list.remove(i);
  }
  /*  print(" left:");
   for (Obstacle line : list) {
   print(line.getClass().getSimpleName()+" ");
   }
   println("");
   */
  list.addAll(tempList);
  /*
  print(" listed:");
   for (Obstacle line : list) {
   print(line.getClass().getSimpleName()+" ");
   }
   println("");
   */
}
@Override
void exit() {  // override second processing level listener of close
  if (!saveChanged ) {
    returnVal=JOptionPane.showConfirmDialog(null, "Do you want to exit without saving?", "Confirm", 
    JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
    if (returnVal == JOptionPane.NO_OPTION) {
      System.out.println("No button clicked");
    } else if (returnVal == JOptionPane.YES_OPTION) {
      super.exit();
      System.out.println("EXIT");
    } else if (returnVal == JOptionPane.CLOSED_OPTION) {
      System.out.println("Cancel");
    }
  } else {
    super.exit();
  }
} 

void changeAppIcon(PImage img) {
  final PGraphics pg = createGraphics(64, 64, JAVA2D);
  pg.beginDraw();
  pg.image(img, 0, 0, 64, 64);
  pg.endDraw();
  frame.setIconImage(pg.image);
}

void changeAppTitle(String title) {
  frame.setTitle(title);
}

