extension ImageUrlHelper on String {
  String buildImageRequestUrl() {
    const String imageHost = "https://www.duckylife.net/img/";
    if (!contains(imageHost)) {
      return imageHost + this;
    } else {
      return this;
    }
  }
}
