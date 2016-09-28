import processing.pdf.*; 
float vel=10;


void setup () {
  beginRecord(PDF, "pdf/tour_#####.pdf");
  size (600, 600);  
  textSize(16);
}


void draw() {
  frameRate(vel);
  background (231);
  float s= random(200);
  noStroke();

  // Shape 1
  fill(#006cfe, 175);
  beginShape();
  vertex(0, height);
  vertex(0, 95);
  vertex(95, 164);
  vertex(191, 92-s);
  vertex(272, 216);
  vertex(382, 128+s);
  vertex(487, 170-s);
  vertex(width, 150);
  vertex(width, height);
  vertex(0, height);
  endShape();

  // Shape 2
  fill(#050bfb, 166);
  beginShape();
  vertex(0, height);
  vertex(0, 99);
  vertex(117, 218+s);
  vertex(244, 339);
  vertex(330, 340-s);
  vertex(425, 537);
  vertex(550, 234+s);
  vertex(width, 150);
  vertex(width, height);
  vertex(0, height);
  endShape();
  
    // Shape 3
  fill(#ff0303, 175);
  beginShape();
  vertex(0, height);
  vertex(0, 260);
  vertex(39, 250+s);
  vertex(169, 238);
  vertex(228, 308-s);
  vertex(371, 93);
  vertex(549, 233+s);
  vertex(width, 426);
  vertex(width, 0);
  vertex(0, 0);
  endShape();

  fill(255, 220);
  textAlign(CENTER);
  text("K    R    A    F    T    W    E    R    K", 189, 410);
  text("T    O    U    R         T    H    E         F    R    A    N    C    E", 308, 450);
  text("2     0     1     6", 519, 34);
  
  
  /*println(frameCount);
  if (frameCount < 60) {
  saveFrame("img/tour-######.tif");} else { exit();}
  */
endRecord();
}