// Artwork timeline example

import java.util.Collections;
import java.util.Comparator;

XML xml;
int dImgWidth, greatImgHeight, yAlign;
ArrayList<Artwork> artworks = new ArrayList<Artwork>();

void setup() {
  size(1024, 768);
  dImgWidth = 120;
  greatImgHeight = 0;
  yAlign = 250;
  loadData();
  Collections.sort(artworks, sortByYear);
  resizeImages();
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(1);
  float xInc = (width/artworks.size()) - dImgWidth;
  line(xInc, yAlign, 
    (dImgWidth * artworks.size()) + (xInc * (artworks.size() - 1)), 
    yAlign);

  if (artworks.size() > 0) {
    for (int i = 0; i < artworks.size(); i++) {
      int xPos = int(width/(artworks.size()) * i);
      xPos += xInc/2;

      int yPos = int(yAlign - (artworks.get(i).getImgHeight()/2));
      image(artworks.get(i).workImg, xPos, yPos);

      fill(255);
      textSize(14);
      textLeading(15);
      int textYPos = yAlign + (greatImgHeight/2) + 20;
      int textHeight = 60;
      text(artworks.get(i).getTitle() + " (" + artworks.get(i).getYear() + ")", 
        xPos, 
        textYPos, 
        dImgWidth, 
        textHeight);

      textSize(12);
      textLeading(12);
      text(artworks.get(i).getArtistName(), 
        xPos, 
        textYPos + 60, 
        dImgWidth, 
        textHeight);
      
      //Circle for estimated value visualization:
      fill(0,255,0);
      float r = artworks.get(i).getValue()/5000000.0;
      ellipse(xPos + artworks.get(i).getImgWidth()/2,
              textYPos + yAlign, r, r);
              
      String valueStr = "" + artworks.get(i).getValue();
      text(valueStr, xPos, textYPos + 330, dImgWidth, textHeight);
    }
  }
}

void loadData() {
  // Load XML file
  xml = loadXML("data.xml");

  XML[] works = xml.getChildren("obra");

  for (int i = 0; i < works.length; i++) {
    // Get the work title:
    XML titleElement = works[i].getChild("titulo");
    String title = titleElement.getContent();

    // Get the artist name:
    XML artistElement = works[i].getChild("artista");
    String artistName = artistElement.getContent();

    // Get the image URL
    XML urlElement = works[i].getChild("url_imagem");
    String url = urlElement.getContent();

    // Get thvalueElement:
    XML yearElement = works[i].getChild("ano");
    int year = yearElement.getIntContent();

    // Get the work value:
    XML valueElement = works[i].getChild("valor");
    int value = valueElement.getIntContent();

    println("-------------- WORK ----------------");
    println("title: " + title);
    println("URL: " + url);
    println("year: " + year);
    println("value: " + value);

    artworks.add(new Artwork(title, artistName, url, year, value));
  }
}

Comparator<Artwork> sortByYear = new Comparator<Artwork>() {
  int compare(Artwork a1, Artwork a2) {
    return a1.getYear()  - a2.getYear();
  }
};

void resizeImages() {
  int lastImgHeight = 0;
  for (int i = 0; i < artworks.size(); i++) {
    int thisImgWidth = artworks.get(i).getImgWidth();
    int thisImgHeight = artworks.get(i).getImgHeight();
    int dImgHeight = 0;

    if (thisImgWidth > dImgWidth) {
      dImgHeight = int(thisImgHeight / (thisImgWidth/dImgWidth));
    }

    if (thisImgWidth <= dImgWidth) {
      dImgHeight = int(thisImgHeight * (dImgWidth/thisImgWidth));
    }

    artworks.get(i).setImgSize(dImgWidth, dImgHeight);

    //Getting the greatest height:
    if (dImgHeight > greatImgHeight) {
      greatImgHeight = dImgHeight;
    }

    lastImgHeight = dImgHeight;
  }
}