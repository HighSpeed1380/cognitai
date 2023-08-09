extension StringHelper on String {
  String takeOnly(int value) {
    if (length > value) {
      return "${substring(0, value)} ...";
    }
    return this;
  }

  String get removeSpaces {
    if (length > 0) {
      return replaceAll(RegExp(r"\n+"), "\n");
    }
    return this;
  }

  bool get isImage {
    return contains('[alt text]') ||
        contains('.jpg') ||
        contains('.jpeg') ||
        contains('.webp') ||
        contains('.png') ||
        contains('.bmp') ||
        contains('.gif');
  }
}
