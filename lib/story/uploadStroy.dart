import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/dashboard/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CreateStoryController.dart';

Future<String> createStory(String path) async {
  List<MultipartFile> listofFile = <MultipartFile>[];
  String fileName = path.split('/').last;
  listofFile.add(await MultipartFile.fromFile(
    path,
    filename: '$fileName',
  ));
  FormData formData = new FormData.fromMap({"files[]": listofFile});
  String url = '';
  try {
    final response = await Dio().post('${baseUrl}uploadfiles$code',
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": '${await getToken()}'
        }),
        data: formData);
    print('response data is = ${response.data}');
    url = response.data['file_url'];
    return url;
  } catch (e) {
    print('Exception is = $e');
    return url;
  }
}

Future uploadStoryData(
    {String? text, List? listOfUrl, String? eventID = '0'}) async {
  print('call story');
  print('token is =  ${await getToken()}');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('user_id');
  print('userId is = $userId');
  var dt = DateTime.now();
  final response = await http.post(
      Uri.parse(
          '$baseUrl${fromHomeStory == '0' ? 'addStory' : 'addStoryEvent'}$code'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${await getToken()}'
      },
      body: fromHomeStory == '0'
          ? jsonEncode({
              "user_id": int.parse(userId!),
              "text": text,
              'files': listOfUrl,
              'time':
                  '${dt.year}-${dt.month}-${dt.day} ${dt.hour}:${dt.minute}:${dt.second}'
            })
          : jsonEncode({
              "user_id": int.parse(userId!),
              "text": text,
              'files': listOfUrl,
              'event_id': fromHomeStory,
              'time':
                  '${dt.year}-${dt.month}-${dt.day} ${dt.hour}:${dt.minute}:${dt.second}'
            }));
  var data = jsonDecode(response.body);
  print('addStory =$data');
  if (data['result'] == 'success') {
  } else {}
}
