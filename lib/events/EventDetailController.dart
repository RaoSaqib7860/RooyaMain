import 'package:get/get.dart';
import 'package:rooya_app/dashboard/Home/Models/AllStoriesModel.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'Models/EventBannerModel.dart';

class EventDetailController extends GetxController {
  var listofStories = <AllStoryies>[].obs;
  var storyLoad=false.obs;
  var listofbanner = <EventBannerModel>[].obs;
  var listofpost = <RooyaPostModel>[].obs;
  var listofSearch= <RooyaPostModel>[].obs;
  var postLoad = false.obs;
}
