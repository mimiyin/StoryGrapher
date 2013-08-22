ArrayList<PImage>  getFlickr() {

  ////////////////////////////////
  ////////////////////////////////
  //////////// FLICKR ////////////
  ////////////////////////////////
  ////////////////////////////////

  String APIKey = "0a9391809bd0efda1c2c0198397b7bf0";
  String APISig = "0cda18c9789572ba444826c42b796bb4";
  String query = "war";
  int page = 1;
  String APICall = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" + APIKey + "&text=" + query +"&extras=url_o&page=" + page + "&format=json&nojsoncallback=1";
  println("CALLING FLICKR WITH: " + APICall);
  JSONObject json = loadJSONObject(APICall);

  ArrayList<PImage>flickr = new ArrayList<PImage>();
  JSONArray photos = json.getJSONObject("photos").getJSONArray("photo");
  for (int i = 0; i < photos.size(); i++) { 
    try {
      JSONObject photo = photos.getJSONObject(i);
      String url = photo.getString("url_o");
      println("IS THERE AN URL? " + url);
      if (photo.getInt("width_o") < width || photo.getInt("height_o") < height) {
        println("TOO SMALL");
        continue;
      }
      else {
        println("ADDING IMAGE");
        flickr.add(requestImage(url));
      }
    }
    finally {
      println("NO URL!!! ");
      continue;
    }
  }
  return flickr;
}

ArrayList<PImage> getGoogle() {
  ////////////////////////////////
  ////////////////////////////////
  //////////// GOOGLE ////////////
  ////////////////////////////////
  ////////////////////////////////

  String APIKey = "AIzaSyAyX0SAKhPbwRVU6tZpEOIt7A5XbKJx7bg";
  String cx = "016258877628183636436:qnjsbiws_fw";
  String query = "portrait";
  String APICall = "https://www.googleapis.com/customsearch/v1?key=" + APIKey +"&cx=" + cx + "&q=" + query;  
  println(APICall);
  JSONObject json = loadJSONObject(APICall);
  JSONArray items = json.getJSONArray("items");


  // Google doesn't provide file format in url, so we need to try all of them
  String[] formats = { 
    "png", "gif", "jpg", "jpeg"
  };

  ArrayList<PImage>google = new ArrayList<PImage>();
  for (int i = 0; i < items.size(); i++) { 
    try {
      JSONObject item = items.getJSONObject(i);
      JSONArray imgs = item.getJSONObject("pagemap").getJSONArray("cse_image");
      String url = imgs.getJSONObject(0).getString("src");
      println("IS THERE AN URL? " + url);
      PImage thisImage = new PImage();
      for (String format: formats) {
        thisImage = requestImage(url, format);
        google.add(thisImage);
        break;
      }
    }
    finally {
      println("NO URL!!! ");
      continue;
    }
  }

  return google;
}

