import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

/**
 * Exercício de conversão de dados cromáticos a som
 * Por medul.la (http://medul.la)
 * Para a oficina "Datajockey"
 //               ---
 * Conversion from hue data to sound frequency
 * By medul.la (http://medul.la)
 * Developed for the "Datajockey" workshop
 
 * Clique e segure o mouse para mudar o leitor linear de pixels
 * Pressione qualquer tecla do teclado para ver qual o pixel sendo analizado
 * Este sketch lê qualquer sequencia de pixels de uma imagem,
 * analizando a matiz da cor de cada pixel e converte o valor
 * a um parâmetro para um sintetizador.
 
 * Click and drag the mouse up and down to control the signal and
 * press and hold any key to see the current pixel being read.
 * This program sequentially reads the color of every pixel of an image
 * and displays this color to fill the window. 
*/

Minim minim;
AudioOutput lineOut;
SineWave sine;
PImage img;
int[] imgPixels;
int direction = 1;
boolean onetime = true;
float signal;

void setup()
{
  size(470, 706);
  imgPixels = new int[width*height];
  frameRate(50);
  //carregando imagem. lembre-se de coloca-la na pasta "data"
  //loading image. remember it must be in the "data" folder
  img = loadImage("monalisa.jpg");
  //carregando pixels da imagem em um array
  //loading pixels from image in an array
  for (int i = 0; i < width * height; i++) {
    imgPixels[i] = img.pixels[i];
  }
  
  stroke(255);

  minim = new Minim(this);
  // acionando uma saída de linha da placa de áudio, com propriedades:
  // bufferSize 1024, sample rate 44100, bit depth 16;
  // ---
  // get a line out from Minim, default bufferSize is 1024, 
  // default sample rate is 44100, bit depth is 16
  
  lineOut = minim.getLineOut(Minim.STEREO);
  
  // criando um oscilador de onda senoidal, com as propriedades:
  // 440 Hz, amplitude 0.5, sample rate da saída de linha
  // create a sine wave Oscillator, set to: 
  // 440 Hz, at 0.5 amplitude, sample rate from line out
  
  sine = new SineWave(440, 0.5, lineOut.sampleRate());
  
  // adicionando o oscilador a saída de linha 
  // add the oscillator to the line out
  lineOut.addSignal(sine);
}

void draw()
{
  if (signal > width * height - 1 || signal < 0) {
    direction = direction * -1;
  }

  if (mousePressed) {
    if (mouseY > height - 1) {
      mouseY = height - 1;
    }
    if (mouseY < 0) {
      mouseY = 0;
    }
    signal = mouseY * width + mouseX;
  } else {
    signal += (0.33 * direction);
  }


  loadPixels();
  
  for (int i = 0; i < (width * height); i++) {
    pixels[i] = imgPixels[i];
  }
  
  updatePixels();
  
  fill(color(imgPixels[int(signal)]));
  rect(signal % width - 5, int(signal/width) - 5, 10, 10);
  point(signal % width, int(signal/width));

  // convertendo valor de matiz a frequência de onda
  //(verifique valores de frequência em http://en.wikipedia.org/wiki/Audio_frequency)
  // converting from hue to sound frequency
  //(verify frequency values in http://en.wikipedia.org/wiki/Audio_frequency)
  float freq = map(hue(imgPixels[int(signal)]), 0, 255, 200, 2000);
  sine.setFreq(freq);
  
  // osciladores são sinais em mono, para convertê-los a stereo,
  // utiliza-se o pan. aqui estamos convertendo o valor do matiz
  // em um correspondente de -1 a 1 para simular o stereo:
  // oscillators are always mono signals. to convert them to stereo
  // you can use the pan property. here we are converting the 
  // hue value to a range from -1 to 1, to simulate stereo:
  float pan = map(pixels[int(signal)], 0, width, -1, 1);
  sine.setPan(pan);

  print ("\n Brilho/Brightness = " + brightness (imgPixels[int(signal)]) + 
  "   Hue/Matiz = " + hue (imgPixels[int(signal)]) + "  Freq. = " + freq);
}