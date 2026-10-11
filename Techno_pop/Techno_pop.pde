import ddf.minim.*;

float a=1;

Minim minim;
AudioPlayer groove;

void setup (){
  size(600,600);
  noFill();
  strokeWeight(50);
  textSize(30);
  textAlign(CENTER,CENTER);

  minim = new Minim(this);
  groove = minim.loadFile("techno.mp3", 1024);
  groove.loop();
}

void draw() {
  background(0);
  // nivel de audio (mismo criterio que TourFrance)
  float s = groove.left.level()*height;
  float d = s*cos(QUARTER_PI);
  a=1;
  stroke(255,160);
  translate(-20,-20);
  for (int i = 50; i < width; i = i+100) {
    for (int j = 50; j < height; j = j+100) {
      //switch color
      // el extremo se mueve sobre la diagonal de 45° (mismo desplazamiento en x e y)
      line(i,j, i+100+d,j+100+d);
      stroke(255,160);
      if (a > 0) {
        stroke(#f80606,160);
      }
      point(i, j);

      int col = (i - 50) / 100;
      int row = (j - 50) / 100;
      String[][] technoGrid = {
        { "K", "R", "A", "F", "T", "" },
        { "",  "W", "E", "R", "K", "" },
        { "T", "E", "C", "H", "N", "O" },
        { "",  "P", "O", "P", "",  "" },
        { "",  "2", "0", "1", "6", "" },
        { "",  "",  "",  "",  "",  "" }
      };
      if (row < technoGrid.length && col < technoGrid[row].length) {
        String ch = technoGrid[row][col];
        if (ch.length() > 0) {
          pushStyle();
          fill(255);
          noStroke();
          textSize(24);
          textAlign(CENTER, CENTER);
          text(ch, i, j);
          popStyle();
        }
      }

      a=a*-1;
    }
  }
}

void mouseClicked(){
//saveFrame("pic_###.jpg");
}
