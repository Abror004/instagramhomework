import 'package:get/get.dart';
import 'package:instagramhomework/controllers/feed_controller.dart';
import 'package:instagramhomework/controllers/home_controller.dart';
import 'package:instagramhomework/controllers/profile_controller.dart';
import 'package:instagramhomework/controllers/search_controller.dart';
import 'package:instagramhomework/controllers/update_controller.dart';

class ControllersBinding implements Bindings {

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FeedController>(FeedController());
    Get.put<Home_Controller>(Home_Controller());
    Get.put<Profile_Controller>(Profile_Controller());
    Get.put<Search_Controller>(Search_Controller());
    Get.put<Update_Controller>(Update_Controller());
  }
}