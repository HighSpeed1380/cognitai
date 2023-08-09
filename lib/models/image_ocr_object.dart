import 'package:ml_kit_ocr/ml_kit_ocr.dart';
import 'package:image_picker/image_picker.dart';


class ImageOcrObject {
  MlKitOcr? ocr = MlKitOcr();
  String? result;
  bool? isAvailable = false;
  XFile? image;
}
