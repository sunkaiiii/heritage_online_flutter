extension ImageUrlHelper on String {
  String buildImageRequestUrl() {
    const String imageHost = "https://heritage.duckylife.net:8443/img/";
    if (!contains(imageHost)) {
      return imageHost + this;
    } else {
      return this;
    }
  }
}
