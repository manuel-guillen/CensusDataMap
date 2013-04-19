String[] stateNames = {"Alabama", "Alaska", "Arizona", "Arkansas",
                        "California", "Colorado", "Connecticut",
                        "Delaware", "District of Columbia",
                        "Florida", "Georgia", "Hawaii", "Idaho",
                        "Illinois", "Indiana", "Iowa", "Kansas",
                        "Kentucky", "Louisiana", "Maine", 
                        "Maryland", "Massachusetts", "Michigan",
                        "Minnesota", "Mississippi", "Missouri",
                        "Montana", "Nebraska", "Nevada", 
                        "New Hampshire", "New Jersey", "New Mexico",
                        "New York", "North Carolina", "North Dakota",
                        "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
                        "Rhode Island", "South Carolina", "South Dakota",
                        "Tennessee", "Texas", "Utah", "Vermont",
                        "Virginia", "Washington", "West Virginia",
                        "Wisconsin", "Wyoming"};
PFont plain,bold;
color backgroundColor = color(0,25,50);
PGraphics[] pieChart = new PGraphics[51], barGraph = new PGraphics[51];

PImage grayMapper;
PShape map;
PShape[] state = new PShape[51];
Table table;

void setup() {
  size(1300,650);
  
  grayMapper = loadImage("_grayMapper.png");
  map = loadShape("_fullMap.svg");
  
  for (int i = 0; i < stateNames.length; i++)
    state[i] = loadShape(stateNames[i] + ".svg");

  plain = loadFont("fonts/Calibri-30.vlw");
  bold = loadFont("fonts/Calibri-Bold-30.vlw");
  
  table = loadTable("data.csv", "header");
  
  //loadGraphics();
}

int current = -1;

void draw() {
  background(backgroundColor);
  shape(map);
  
  int n = 52;
  if (mouseX <= 928 && mouseY <= 587)
    n = (int)(blue(grayMapper.get(mouseX,mouseY))/4);
  
  if (n < 51) shape(state[n]);
  else if (current != -1) shape(state[current]);
  
  // -------------------------------------------------
  translate(930,2);
  textAlign(LEFT,TOP);
  fill(255);
  
  textFont(bold);
  text("United States 2010 Census",15,0);
  
  if (current != -1) displayData();
  
}

void mousePressed() {
  current = (int)(blue(grayMapper.get(mouseX,mouseY))/4);
  
  if (mouseX > 928 || mouseY > 587 || current >= 51)
    current = -1;
}

void displayData() {
  textFont(bold);
    textSize(24);
    text("State:",0,40);
    
    textFont(plain);
    textSize(24);
    text(stateNames[current],65,40);
    
    
    textFont(bold);
    textSize(24);
    text("Population:",0,90);
    
    textFont(plain);
    textSize(24);
    text(nfc(table.getInt(current, "Population")) ,120,90);

    
    fill(0,185,255);
    textFont(bold);
    textSize(22);
    text("Male:", 230,125);
    
    textFont(plain);
    textSize(22);
    int male = table.getInt(current, "Male");
    text(nfc(male), 240,145);
    
    fill(255,120,220);
    textFont(bold);
    textSize(22);
    text("Female:", 230,175);
    
    textFont(plain);
    textSize(22);
    int female = table.getInt(current, "Female");
    text(nfc(female), 240,195);
    
    if (pieChart[current] == null) pieChart[current] = createPieChart(male,female);
    image(pieChart[current],0,120);
    
    
    fill(0,255,255);
    textFont(bold);
    textSize(22);
    text("Under 18:", 230,360);
    
    textFont(plain);
    textSize(22);
    int a1 = table.getInt(current, "Under 18");
    text(nfc(a1), 240,380);
    
    fill(0,255,0);
    textFont(bold);
    textSize(22);
    text("20 to 24:", 230,410);
    
    textFont(plain);
    textSize(22);
    int a2 = table.getInt(current, "20 to 24");
    text(nfc(a2), 240,430);
    
    fill(255,255,0);
    textFont(bold);
    textSize(22);
    text("25 to 34:", 230,460);
    
    textFont(plain);
    textSize(22);
    int a3 = table.getInt(current, "25 to 34");
    text(nfc(a3), 240,480);
    
    fill(255,127,0);
    textFont(bold);
    textSize(22);
    text("35 to 49:", 230,510);
    
    textFont(plain);
    textSize(22);
    int a4 = table.getInt(current, "35 to 49");
    text(nfc(a4), 240,530);
    
    fill(255,0,0);
    textFont(bold);
    textSize(22);
    text("50 to 64:", 230,560);
    
    textFont(plain);
    textSize(22);
    int a5 = table.getInt(current, "50 to 64");
    text(nfc(a5), 240,580);
 
    fill(185,0,185);
    textFont(bold);
    textSize(22);
    text("65 and Over:", 230,610);
    
    textFont(plain);
    textSize(22);
    int a6 = table.getInt(current, "65 and Over");
    text(nfc(a6), 240,630);
    
    if (barGraph[current] == null) barGraph[current] = createBarGraph(a1,a2,a3,a4,a5,a6);
    image(barGraph[current],0,355);
      
}

PGraphics img;

PGraphics createPieChart(int male, int female) {
  float percent = ((float) male)/(male+female);
  
  img = createGraphics(225,225);
  img.beginDraw();
  img.background(backgroundColor);
  img.stroke(backgroundColor);
  img.strokeWeight(3);
  
  img.fill(0,185,255);
  img.arc(112, 112, 200, 200, -HALF_PI-percent*TWO_PI, -HALF_PI,PIE);
  
  img.fill(255,120,220);
  img.arc(112, 112, 200, 200, -HALF_PI, -HALF_PI+(1-percent)*TWO_PI,PIE);
  
  img.endDraw();
  return img;
}

PGraphics createBarGraph(int... ages) {
  img = createGraphics(225,280);
  img.beginDraw();
  img.background(0);
  
  img.stroke(255);
  img.strokeWeight(3);
  img.line(0,280,225,280);
  
  for (int i = 0; i <= 10; i++)
    img.line((int)(22.5*i),275,(int)(22.5*i),280);
  
  int h = 45;
  
  img.stroke(0);
  for (int i = 0; i < 6; i++) {
    img.fill(barColor(i));
    img.rect(0,i*h+10,ages[i]*9/400000,25);
  }
  
  img.endDraw();
  return img;
}

color barColor (int i) {
  switch(i) {
  case 0: return color(0,255,255);
  case 1: return color(0,255,0);
  case 2: return color(255,255,0);
  case 3: return color(255,127,0);
  case 4: return color(255,0,0);
  case 5: return color(185,0,185);
  
  default: return -1;
  }
}
