// Artwork timeline example

import java.util.Collections;
import java.util.Comparator;

JSONObject json;
int dImgWidth;
int greatImgHeight;
ArrayList<Artwork> artworks = new ArrayList<Artwork>();

void setup() {
  size(1024, 768);
  dImgWidth = 120;
  greatImgHeight = 0;
  loadData();
  Collections.sort(artworks, sortByYear);
  resizeImages();
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(1);
  float xInc = (width/artworks.size()) - dImgWidth;
  line(xInc, height/2, 
      (dImgWidth * artworks.size()) + (xInc * (artworks.size() - 1)), 
      height/2);

  if (artworks.size() > 0) {
    for (int i = 0; i < artworks.size(); i++) {
      int xPos = int(width/(artworks.size()) * i);
      xPos += xInc/2;
      
      int yPos = int((height/2) - (artworks.get(i).getImgHeight()/2));
      image(artworks.get(i).workImg, xPos, yPos);

      fill(255);
      textSize(14);
      textLeading(15);
      int textYPos = height/2 + (greatImgHeight/2) + 20;
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
    }
  }
}

void loadData() {
  // Load JSON file
  json = loadJSONObject("data.json");

  JSONArray works = json.getJSONArray("obras");

  for (int i = 0; i < works.size(); i++) {
    // Get each object in the array
    JSONObject work = works.getJSONObject(i); 
    // Get the title
    String title = work.getString("titulo");
    // Get the artist name
    String artistName = work.getString("artista");
    // Get the image URL
    String url = work.getString("url_imagem");
    int year = work.getInt("ano");

    println("-------------- WORK ----------------");
    println("title: " + title);
    println("URL: " + url);
    println("year: " + year);

    artworks.add(new Artwork(title, artistName, url, year));
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