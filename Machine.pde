import processing.pdf.*; 

float a=1;
void setup () {
  beginRecord(PDF, "pdf/lines_#####.pdf");
  size(600, 600);
  
  noFill();
  strokeWeight(50);
  textSize(30);
  textAlign(CENTER, CENTER);
  stroke(255, 160);
}
void draw() {
  background(0);
  translate(0, 0);
  for (int i = 50; i < width; i = i+100) {
    for (int j = 50; j < height; j = j+100) {
      //switch color
      line(i, j, 303, 505);
      stroke(255, 160);
      if (a > 0) {
        stroke(#f80606, 160);
      }
      point(i, j);
      text("", i, j-6);
      a=a*-1;
    }
    //noLoop();
  }
  endRecord();
}
void mouseClicked() {
  //saveFrame("pic_###.jpg");
}