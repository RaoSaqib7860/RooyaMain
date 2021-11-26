import 'package:get/get.dart';
import 'package:rooya_app/dashboard/Home/Models/AllStoriesModel.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import '../Models/HomeBannerModel.dart';

class HomeController extends GetxController {
  var listofStories = <AllStoryies>[].obs;
  var storyLoad=false.obs;
  var listofbanner = <HomeBannerModel>[].obs;
  var listofpost= <RooyaPostModel>[].obs;
  var listofSearch= <RooyaPostModel>[].obs;
  var postLoad=false.obs;
  var isForyou=true.obs;
}
