class Artwork {
  String title;
  String artistName;
  String imgUrl;
  int year;
  PImage workImg;

  Artwork(String _title, String _artist, String _imgUrl, int _year) {
    this.title = _title;
    this.artistName = _artist;
    this.imgUrl = _imgUrl;
    this.year = _year;

    workImg = loadImage(imgUrl);
  }

  int getYear() {
    return year;
  }

  int getImgHeight() {
    return workImg.height;
  }

  int getImgWidth() {
    return workImg.width;
  }

  void setImgSize(int _w, int _h) {
    workImg.resize(_w, _h);
  }

  String getArtistName() {
    return artistName;
  }

  String getTitle() {
    return title;
  }
}