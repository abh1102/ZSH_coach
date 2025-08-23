import 'package:flutter/material.dart';

class TabIndexProvider extends ChangeNotifier {
  bool isVerified = true;

  int initialTabIndex = 0;

  void setInitialTabIndex(int index) {
    initialTabIndex = index;
    notifyListeners();
  }
}
