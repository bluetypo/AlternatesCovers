import processing.pdf.*; 
float vel=10;

void setup () {
  beginRecord(PDF, "pdf/home_#####.pdf");
  size (600, 600);
  noStroke();
}

void draw() {
  scale(1.4);
  translate(-26,-19);
  color c1=#9b9daf; //bacground color
  color c2=#72262c;
  color c3=#ec7566;
  color c4=#95111b;
  color c5=#72262c;
  color c6=#ec7566;
  
  frameRate(vel);
  float s= random(80);
  
  background(c1);

  fill(255, 230);
  beginShape();
  vertex(232,38);
  vertex(437,134-(s*.3));
  vertex(210-(s/2),262-s);
  vertex(196,496);
  vertex(56+(s*0.2),215);
  endShape();
  
  fill(c2, 200);
  beginShape();
  vertex(56+(s*0.2),215);
  vertex(210-(s+2),262-s);
  vertex(344,367+(s*.25));
  vertex(426,506);
  vertex(196,496);
  endShape();
  
  fill(c3, 180);
  beginShape();
  vertex(232,38);
  vertex(437,134-(s*.3));
  vertex(210-(s/2),262-s);
  endShape();

  fill(c4, 200);
  beginShape();
  vertex(444,73);
  vertex(550,250);
  vertex(426,506);
  vertex(196,496);
  vertex(210-(s/2),262-s);
  vertex(437,134-(s*.3));
  endShape();

  fill(c5, 90);
  beginShape();
  vertex(550,250);
  vertex(426,506);
  vertex(196,496);
vertex(344,367+(s*.25));
  endShape();
  
  fill(c6, 160);
  beginShape();
  vertex(232,38);
  vertex(444,73);
  vertex(550,250);
  vertex(437,134-(s*.3));
  endShape();
  
    fill(255, 220);
  textAlign(CENTER);
  text("K    R    A    F    T    W    E    R    K", 328, 253);
  text("H    O    M    E", 381, 282);
  text("C    O    M    P    U    T    E    R", 337, 310);
  text("2     0     1     6", 379, 430);
  endRecord();
  
  //saveFrame("img/home-####.tif");
}