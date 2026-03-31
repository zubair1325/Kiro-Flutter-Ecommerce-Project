import 'package:get/get.dart';

class MainBottomNavController extends GetxController {
  int _selectedIndex = 2;
  int get currentIndex => _selectedIndex;
  void changeIndex(int index) {
    if (_selectedIndex == index) {
      return;
    }
    _selectedIndex = index;
    update();
  }

  void bacToHome() {
    changeIndex(2);
  }
}
