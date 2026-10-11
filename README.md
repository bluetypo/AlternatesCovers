# AlternatesCovers

Portadas interactivas generativas para sencillos de Kraftwerk desarrolladas en **Processing** con reactividad sonora en tiempo real mediante la librería **Minim**.

Proyecto original creado por **Manolo Guerrero (bluetypo)**, 2016.

---

## Descripción del Proyecto

`AlternatesCovers` es una serie de reinterpretaciones visuales interactivas de tres portadas emblemáticas de Kraftwerk:

1. **Tour de France**
2. **Techno Pop**
3. **Home Computer**

El sketch unificado (`AlternatesCovers/AlternatesCovers.pde`) integra las tres piezas en una sola aplicación interactiva, permitiendo alternar fluidamente entre ellas con el teclado mientras cada una reacciona en tiempo real a su respectiva pista de audio.

---

## Controles e Interacción

Al ejecutar el sketch, puedes cambiar de pieza en cualquier momento usando las teclas numéricas:

| Tecla | Portada | Pista de Audio | Características Visuales |
| :---: | :--- | :--- | :--- |
| **`1`** | **Tour de France** | `tour.mp3` | Montañas alpinas poligonales con morfología continua y picos reactivos |
| **`2`** | **Techno Pop** | `techno.mp3` | Cuadrícula con tipografía en vértices y líneas en movimiento de bandada |
| **`3`** | **Home Computer** | `home.mp3` | Facetas geométricas poligonales con deformación orbital y pulso sonoro |

Cada transición pausa la pista anterior, rebobina y reproduce la nueva en bucle (`loop()`), sincronizando automáticamente los cuadros por segundo (`frameRate`) óptimos para cada composición.

---

## Cómo Funciona Cada Portada

### 1. Tour de France (`tecla 1`)
* **Morfología Continua:** Representa el paso por los Alpes. Las montañas no se desplazan horizontalmente; en su lugar, evolucionan gradualmente entre diferentes siluetas topográficas (perfil original, picos alpinos afilados y colinas suaves) en un ciclo de 20 segundos (`changeSecs`). La interpolación suave (`lerp`) entre perfiles crea una sensación de avance topográfico constante.
* **Reactividad al Audio:** Cada vértice de la cordillera cuenta con un factor de respuesta acústica. Las crestas suben y bajan al compás de la amplitud de la señal (`groove.left.level()`).
* **Composición:** Tres capas poligonales superpuestas (azul cielo, azul ultramar y rojo) junto con la tipografía oficial del sencillo de 2016.

### 2. Techno Pop (`tecla 2`)
* **Tipografía en Vértices Estáticos:** Cada letra de la tipografía está dibujada en color blanco (`fill(255)`), centrada exactamente en el centro inmutable del círculo/nodo de la rejilla de 6×6, distribuida por palabras:
  * Fila 0: `K  R  A  F  T`
  * Fila 1: `_  W  E  R  K`
  * Fila 2: `T  E  C  H  N  O`
  * Fila 3: `_  P  O  P`
  * Fila 4: `_  2  0  1  6`
* **Movimiento Colectivo (Flocking / Cardumen):** Las líneas parten de los vértices y giran alrededor de un eje base de 45°. En lugar de moverse de forma caótica o desfasada al azar, se comportan de manera coordinada como una bandada de aves o un cardumen de peces: un giro principal sincronizado que viaja como una onda gradual a través de la rejilla con una sutil variación armónica (`noise`).
* **Longitud Reactiva:** En momentos de silencio las líneas conservan una longitud mínima compacta (30 px) y se elongan dramáticamente hacia el exterior al ritmo de los golpes del audio.

### 3. Home Computer (`tecla 3`)
* **Facetas Poligonales Conectadas:** La icónica computadora se construye mediante polígonos vectoriales superpuestos con distintos valores de opacidad y color.
* **Deformación Orbital Paramétrica:** Los vértices compartidos entre polígonos describen pequeñas trayectorias orbitales desfasadas en el tiempo (`homeAmp = 20 px`), permitiendo que la figura mute de forma orgánica y fluida en ciclos de 20 segundos sin que las facetas se separen.
* **Modulación Sonora:** El nivel de volumen del audio modula la tensión y apertura de los puntos clave del polígono central.

---

## Parámetros Principales de Configuración

En la cabecera de `AlternatesCovers.pde` se encuentran las variables globales que permiten calibrar la experiencia:

```java
float changeSecs = 20;       // Intervalo (segundos) para los ciclos de mutación morfológica
float tourStep = 10;         // Resolución horizontal (px) para el dibujo de las montañas
float technoAmp = PI/3;      // Amplitud del viraje de la bandada en Techno Pop
float technoPhase = 0.15;    // Velocidad de propagación de la onda direccional
float technoNoise = 0.4;     // Variación armónica orgánica entre celdas vecinas
float technoMinLen = 30;     // Longitud mínima de las líneas sin sonido
float technoGain = 1.5;      // Factor de amplificación reactiva al volumen
float homeAmp = 20;          // Radio de órbita (px) de los vértices en Home Computer
```

---

## Requisitos e Instalación

1. **Processing:** Compatible con Processing 4.x (probado en 4.1) y Processing 3.x.
2. **Librería Minim:**
   * Debe estar instalada en la carpeta `libraries` de tu Processing Sketchbook (`~/Documents/Processing/libraries/minim`).
   * Contiene soporte para decodificación y análisis de audio MP3 en tiempo real.
3. **Archivos de Audio:**
   * Coloca los archivos correspondientes dentro de la carpeta `AlternatesCovers/data/`:
     * `tour.mp3`
     * `techno.mp3`
     * `home.mp3`

---

## Estructura del Repositorio

```
AlternatesCovers/
├── AlternatesCovers/
│   ├── AlternatesCovers.pde    # Sketch unificado principal (teclas 1, 2, 3)
│   └── data/
│       ├── tour.mp3            # Pistas de audio (ignoradas en git)
│       ├── techno.mp3
│       └── home.mp3
├── TourFrance/
│   └── TourFrance.pde          # Sketch individual Tour de France
├── Techno_pop/
│   └── Techno_pop.pde          # Sketch individual Techno Pop
├── home_comp/
│   └── home_comp.pde           # Sketch individual Home Computer
├── .gitignore                  # Exclusiones para macOS y archivos .mp3
└── README.md
```
