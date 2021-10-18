import 'package:get/get.dart';
import 'package:rooya_app/dashboard/Home/Models/AllStoriesModel.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import '../Models/HomeBannerModel.dart';

class HomeController extends GetxController {
  var listofStories = <AllStoriesModel>[].obs;
  var storyLoad=false.obs;
  var listofbanner = <HomeBannerModel>[].obs;
  var listofpost= <RooyaPostModel>[].obs;
  var postLoad=false.obs;
}
