import ddf.minim.*;

// Teclas: 1 = Tour de France, 2 = Techno Pop, 3 = Home Computer

// Cada cuántos segundos cambia el diseño de cada sketch
float changeSecs = 20;
int startMs = 0;

Minim minim;
AudioPlayer[] players = new AudioPlayer[3];
String[] files = { "tour.mp3", "techno.mp3", "home.mp3" };
float[] rates = { 60, 60, 30 };
int current = 0;

// Variantes de diseño (una por entrada). Se recorren en ciclo cada changeSecs.
// Tour: montañas (3 capas) por variante. Cada punto es { x, y, k }:
// k = 0 fijo, +1 / -1 se desplaza con el audio (hacia abajo / arriba).
// Variante 0 = diseño original; 1 = picos alpinos afilados; 2 = colinas suaves.
// Entre variantes las montañas se transforman de forma gradual (sin desplazarse).
// Separación horizontal (px) entre los puntos con que se dibuja la montaña
float tourStep = 10;
float[][][][] tourRidges = {
  { // 0: original
    { {0,95,0}, {95,164,0}, {191,92,-1}, {272,216,0}, {382,128,1}, {487,170,-1}, {600,150,0} },
    { {0,99,0}, {117,218,1}, {244,339,0}, {330,340,-1}, {425,537,0}, {550,234,1}, {600,150,0} },
    { {0,260,0}, {39,250,1}, {169,238,0}, {228,308,-1}, {371,93,0}, {549,233,1}, {600,426,0} }
  },
  { // 1: picos afilados
    { {0,140,0}, {60,90,-1}, {120,200,0}, {190,60,-1}, {250,180,0}, {340,100,1}, {420,210,0}, {500,70,-1}, {600,170,0} },
    { {0,200,0}, {80,320,1}, {150,230,0}, {260,400,-1}, {330,280,0}, {430,480,1}, {510,300,0}, {600,220,0} },
    { {0,330,0}, {70,200,1}, {150,310,0}, {240,160,-1}, {330,300,0}, {400,120,0}, {500,260,1}, {600,380,0} }
  },
  { // 2: colinas suaves
    { {0,170,0}, {110,120,-1}, {230,210,0}, {330,150,1}, {450,230,0}, {530,140,-1}, {600,190,0} },
    { {0,260,0}, {100,330,1}, {220,280,0}, {340,380,-1}, {450,330,0}, {540,420,1}, {600,300,0} },
    { {0,380,0}, {90,330,1}, {200,400,0}, {320,260,-1}, {430,380,0}, {520,300,1}, {600,440,0} }
  }
};
// Techno: las líneas se mueven como una bandada / cardumen: giran casi juntas.
// Un ciclo completo del giro dura changeSecs.
float technoAmp = PI/3;       // amplitud del giro común de la bandada (radianes)
float technoPhase = 0.15;     // retraso entre celdas vecinas: el giro viaja como una ola
float technoNoise = 0.4;      // variación suave y local entre vecinas (radianes)
float technoMinLen = 30;      // largo mínimo de la línea (sin audio), px
float technoGain = 1.5;       // cuánto la alarga el audio (multiplica el nivel)

// Tipografía Techno Pop: cada letra centrada en su vértice estático (círculo)
// Distribuida por palabras en las filas de la rejilla 6x6
String[][] technoGrid = {
  { "K", "R", "A", "F", "T", "" },
  { "",  "W", "E", "R", "K", "" },
  { "T", "E", "C", "H", "N", "O" },
  { "",  "P", "O", "P", "",  "" },
  { "",  "2", "0", "1", "6", "" },
  { "",  "",  "",  "",  "",  "" }
};
// Home: cada vértice se mueve en una pequeña órbita (px), un ciclo cada changeSecs.
float homeAmp = 20;

// Techno Pop
float a = 1;

void setup() {
  size(600, 600);

  minim = new Minim(this);
  for (int i = 0; i < players.length; i++) {
    players[i] = minim.loadFile(files[i], 1024);
  }
  selectSketch(0);
}

void draw() {
  float level = players[current].left.level();
  switch (current) {
    case 0: drawTour(level);   break;
    case 1: drawTechno(level); break;
    case 2: drawHome(level);   break;
  }
}

void keyPressed() {
  if (key == '1') selectSketch(0);
  if (key == '2') selectSketch(1);
  if (key == '3') selectSketch(2);
}

// Cambia de sketch: pausa el audio anterior y reproduce el nuevo desde el inicio
void selectSketch(int n) {
  players[current].pause();
  current = n;
  frameRate(rates[current]);
  startMs = millis();
  players[current].rewind();
  players[current].loop();
}

// ---------- 1: Tour de France ----------
// Valor c (1 = y, 2 = k) de un perfil en la posición x (interpolación lineal entre puntos)
float ridgeVal(float[][] r, float x, int c) {
  for (int i = 0; i < r.length - 1; i++) {
    if (x <= r[i+1][0]) {
      float t = (x - r[i][0]) / (r[i+1][0] - r[i][0]);
      return lerp(r[i][c], r[i+1][c], t);
    }
  }
  return r[r.length-1][c];
}

// Dibuja una capa de montañas mezclando dos perfiles (f = 0 -> ra, f = 1 -> rb).
// Los puntos mantienen su x: las montañas cambian de forma, no se desplazan.
// toTop=true cierra la forma hacia arriba (capa roja).
void drawRidge(float[][] ra, float[][] rb, float f, boolean toTop, float s) {
  beginShape();
  vertex(0, height);
  for (float x = 0; x <= width; x += tourStep) {
    float y = lerp(ridgeVal(ra, x, 1), ridgeVal(rb, x, 1), f);
    float k = lerp(ridgeVal(ra, x, 2), ridgeVal(rb, x, 2), f);
    vertex(x, y + k*s);
  }
  if (toTop) {
    vertex(width, 0);
    vertex(0, 0);
  } else {
    vertex(width, height);
    vertex(0, height);
  }
  endShape();
}

void drawTour(float level) {
  pushStyle();
  textSize(16);
  background(231);

  // Avance continuo: durante changeSecs se transforma de una variante a la siguiente
  float t = (millis() - startMs) / (changeSecs * 1000);
  int n = tourRidges.length;
  int i0 = int(t) % n;
  int i1 = (i0 + 1) % n;
  float f = t - floor(t);
  f = f*f*(3 - 2*f); // suavizado
  float[][][] ra = tourRidges[i0];
  float[][][] rb = tourRidges[i1];

  float s = level*height;
  noStroke();
  // Shape 1
  fill(#006cfe, 175);
  drawRidge(ra[0], rb[0], f, false, s);

  // Shape 2
  fill(#050bfb, 166);
  drawRidge(ra[1], rb[1], f, false, s);

  // Shape 3
  fill(#ff0303, 175);
  drawRidge(ra[2], rb[2], f, true, s);

  fill(255, 220);
  textAlign(CENTER);
  text("K    R    A    F    T    W    E    R    K", 189, 410);
  text("T    O    U    R         T    H    E         F    R    A    N    C    E", 308, 450);
  text("2     0     1     6", 519, 34);
  popStyle();
}

// ---------- 2: Techno Pop ----------
void drawTechno(float level) {
  pushStyle();
  pushMatrix();
  background(0);
  noFill();
  strokeWeight(50);
  textSize(30);
  textAlign(CENTER, CENTER);

  float s = level*height;
  float len = technoMinLen + s*technoGain;   // largo de la línea (el audio la alarga)
  float tt = TWO_PI * (millis() - startMs) / (changeSecs * 1000.0);
  a = 1;
  stroke(255, 160);
  translate(-20, -20);
  for (int i = 50; i < width; i = i+100) {
    for (int j = 50; j < height; j = j+100) {
      // dirección coherente: giro común (45° base) con retraso que viaja por la rejilla
      // + pequeña variación suave (noise) para que vecinas sean parecidas pero no idénticas
      float ang = QUARTER_PI
                + technoAmp * sin(tt - (i + j)/100.0 * technoPhase)
                + technoNoise * (noise(i*0.004, j*0.004, tt*0.15) - 0.5) * 2;
      //switch color
      line(i, j, i + len*cos(ang), j + len*sin(ang));
      stroke(255, 160);
      if (a > 0) {
        stroke(#f80606, 160);
      }
      point(i, j);

      // Cada letra centrada exactamente en el vértice estático (i, j)
      int col = (i - 50) / 100;
      int row = (j - 50) / 100;
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

      a = a*-1;
    }
  }
  popMatrix();
  popStyle();
}

// ---------- 3: Home Computer ----------
// Vértice con órbita propia (id): los vértices compartidos usan el mismo id
// para que los polígonos sigan encajando mientras cambian de forma.
float homeT = 0;
void hv(int id, float x, float y) {
  vertex(x + homeAmp*sin(homeT + id*1.7), y + homeAmp*cos(homeT + id*2.3));
}

void drawHome(float level) {
  pushStyle();
  pushMatrix();
  noStroke();
  scale(1.4);
  translate(-26, -19);
  color c1=#9b9daf; //bacground color
  color c2=#72262c;
  color c3=#ec7566;
  color c4=#95111b;
  color c5=#72262c;
  color c6=#ec7566;

  homeT = TWO_PI * (millis() - startMs) / (changeSecs * 1000.0);
  // nivel de audio mapeado al rango 0-80 que antes era random(80)
  float s = constrain(level*height*0.5, 0, 80);

  background(c1);

  // ids: 0=(232,38) 1=(437,134) 2=(210,262) 3=(196,496) 4=(56,215)
  //      5=(344,367) 6=(426,506) 7=(444,73) 8=(550,250)
  fill(255, 230);
  beginShape();
  hv(0, 232,38);
  hv(1, 437,134-(s*.3));
  hv(2, 210-(s/2),262-s);
  hv(3, 196,496);
  hv(4, 56+(s*0.2),215);
  endShape();

  fill(c2, 200);
  beginShape();
  hv(4, 56+(s*0.2),215);
  hv(2, 210-(s+2),262-s);
  hv(5, 344,367+(s*.25));
  hv(6, 426,506);
  hv(3, 196,496);
  endShape();

  fill(c3, 180);
  beginShape();
  hv(0, 232,38);
  hv(1, 437,134-(s*.3));
  hv(2, 210-(s/2),262-s);
  endShape();

  fill(c4, 200);
  beginShape();
  hv(7, 444,73);
  hv(8, 550,250);
  hv(6, 426,506);
  hv(3, 196,496);
  hv(2, 210-(s/2),262-s);
  hv(1, 437,134-(s*.3));
  endShape();

  fill(c5, 90);
  beginShape();
  hv(8, 550,250);
  hv(6, 426,506);
  hv(3, 196,496);
  hv(5, 344,367+(s*.25));
  endShape();

  fill(c6, 160);
  beginShape();
  hv(0, 232,38);
  hv(7, 444,73);
  hv(8, 550,250);
  hv(1, 437,134-(s*.3));
  endShape();

  fill(255, 220);
  textAlign(CENTER);
  text("K    R    A    F    T    W    E    R    K", 328, 253);
  text("H    O    M    E", 381, 282);
  text("C    O    M    P    U    T    E    R", 337, 310);
  text("2     0     1     6", 379, 430);
  popMatrix();
  popStyle();
}
