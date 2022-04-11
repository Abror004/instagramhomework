import 'package:get/get.dart';
import 'package:instagramhomework/controllers/feed_controller.dart';
import 'package:instagramhomework/controllers/home_controller.dart';
import 'package:instagramhomework/controllers/profile_controller.dart';
import 'package:instagramhomework/controllers/search_controller.dart';
import 'package:instagramhomework/controllers/update_controller.dart';

class DIService {
  static Future<void> init() async {
    Get.lazyPut<FeedController>(() => FeedController(), fenix: true);
    Get.lazyPut<Home_Controller>(() => Home_Controller(), fenix: true);
    Get.lazyPut<Profile_Controller>(() => Profile_Controller(), fenix: true);
    Get.lazyPut<Search_Controller>(() => Search_Controller(), fenix: true);
    Get.lazyPut<Update_Controller>(() => Update_Controller(), fenix: true);
  }
}