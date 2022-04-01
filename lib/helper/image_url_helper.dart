extension ImageUrlHelper on String {
  String buildImageRequestUrl() {
    const String imageHost = "https://www.sunkai.xyz:5001/img/";
    if (!contains(imageHost)) {
      return imageHost + this;
    } else {
      return this;
    }
  }
}
