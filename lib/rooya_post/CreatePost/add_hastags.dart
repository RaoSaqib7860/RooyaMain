import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:get/get.dart';
import 'package:rooya_app/models/HashTagModel.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AddHashTags extends StatefulWidget {
  List<HashTagModel>? selectedHashTags;
  Function? onAddHashTag;

  AddHashTags({Key? key, this.selectedHashTags, this.onAddHashTag})
      : super(key: key);

  @override
  _AddHashTagsState createState() => _AddHashTagsState();
}

class _AddHashTagsState extends State<AddHashTags> {
  List<HashTagModel> _selectedHashTags = [];
  bool isLoading = false;
  List<HashTagModel> mRooyaHashTagList = [];

  @override
  void initState() {
    // TODO: implement initState
    _selectedHashTags.addAll(widget.selectedHashTags!);
    getHashTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Add Hash Tags',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: AppFonts.segoeui),
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black)),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.5.w),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: FlutterTagging<HashTagModel>(
                        initialItems: _selectedHashTags,
                        textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                              fillColor: Colors.green.withAlpha(30),
                              hintText: 'Search Tags',
                              labelText: 'Select Hash Tags',
                              hintStyle: TextStyle(
                                  fontSize: 13, fontFamily: AppFonts.segoeui),
                              labelStyle: TextStyle(
                                  fontSize: 13,
                                  color: primaryColor,
                                  fontFamily: AppFonts.segoeui)),
                        ),
                        findSuggestions: getHashtags,
                        additionCallback: (value) {
                          return HashTagModel(
                            hashtag: value,
                            hashtagId: 0,
                          );
                        },
                        onAdded: (hastag) {
                          // api calls here, triggered when add to tag button is pressed
                          setState(() {
                            hastag.hashtag = '#${hastag.hashtag}';
                          });
                          return hastag;
                        },
                        configureSuggestion: (hashtag) {
                          return SuggestionConfiguration(
                            title: Text(hashtag.hashtag!),
                            additionWidget: Chip(
                              avatar: Icon(
                                Icons.add_circle,
                                color: Colors.white,
                              ),
                              label: Text('Add Hash Tag'),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        configureChip: (lang) {
                          return ChipConfiguration(
                            label: Text(lang.hashtag!),
                            backgroundColor: Colors.green,
                            labelStyle: TextStyle(color: Colors.white),
                            deleteIconColor: Colors.white,
                          );
                        },
                        onChanged: () {
                          setState(() {
                            // _selectedValuesJson = _selectedLanguages
                            //     .map<String>((lang) => '\n${lang.toJson()}')
                            //     .toList()
                            //     .toString();
                            // _selectedValuesJson =
                            //     _selectedValuesJson.replaceFirst('}]', '}\n]');
                          });
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      widget.onAddHashTag!(_selectedHashTags);
                      Get.back();
                    },
                    child: Container(
                      width: 50.0.w,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<List<HashTagModel>> getHashtags(String query) async {
    return mRooyaHashTagList
        .where((hastag) =>
            hastag.hashtag!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> getHashTags() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.get(
        Uri.parse('${baseUrl}getRooyaPostHashTag${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!});

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print(response.body);
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mRooyaHashTagList = List<HashTagModel>.from(
              data['data'].map((model) => HashTagModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }
}
