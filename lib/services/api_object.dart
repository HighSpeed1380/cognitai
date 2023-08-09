import 'package:app/models/setting_model.dart';

class APIObject {
  dynamic results;
  List<SettingModel>? settings;
  List<dynamic>? packages;
  bool isLoading = false;
}
