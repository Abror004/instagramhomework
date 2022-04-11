import 'package:get/get.dart';

class Home_Controller extends GetxController {
  var currentPage = 0.obs;

  selectPage(index) {
    currentPage.value = index;
  }
}