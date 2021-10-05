import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:get/get.dart';
import 'package:rooya_app/models/UserTagModel.dart';

import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AddUserTags extends StatefulWidget {
  List<UserTagModel>? selectedUserTags;
  Function? onAddUserTag;
  AddUserTags({Key? key,this.selectedUserTags,this.onAddUserTag}):super(key: key);
  @override
  _AddUserTagsState createState() => _AddUserTagsState();
}

class _AddUserTagsState extends State<AddUserTags> {
  List<UserTagModel> _selectedUserTags = [];
  bool isLoading = false;
  List<UserTagModel> mRooyaUserTagList = [];

  @override
  void initState() {
    // TODO: implement initState
    _selectedUserTags.addAll(widget.selectedUserTags!);
    getUsersTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:2.5.w,vertical: 2.5.w),
              child: Column(
                children: [
                  FlutterTagging<UserTagModel>(
                      initialItems: _selectedUserTags,
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.green.withAlpha(30),
                          hintText: 'Search User',
                          labelText: 'Select User',
                        ),
                      ),
                      findSuggestions: getUsertags,
                      // additionCallback: (value) {
                      //   return UserTagModel(
                      //     us: value,
                      //     hashtagId: 0,
                      //   );
                      // },
                      // onAdded: (userModel) {
                      //   // api calls here, triggered when add to tag button is pressed
                      //   setState(() {
                      //    // hastag.hashtag='#${hastag.hashtag}';
                      //   });
                      //   return userModel;
                      // },
                      configureSuggestion: (user) {
                        return SuggestionConfiguration(
                          title: Text(user.userName!),
                          additionWidget: Chip(
                            avatar: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: Text('Add New Tag'),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      configureChip: (user) {
                        return ChipConfiguration(
                          label: Text(user.userName!),
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
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      widget.onAddUserTag!(_selectedUserTags);
                      Get.back();
                    },
                    child: Container(
                      width: 80.0.w,
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Center(child: Text('Save',style: TextStyle(color: Colors.white),)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<List<UserTagModel>> getUsertags(String query) async {
    return mRooyaUserTagList
        .where((user) =>
        user.userName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> getUsersTags() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= await prefs.getString('token');
    final response = await http
        .get(Uri.parse('${baseUrl}getRooyaUser${code}'), headers: {
      "Content-Type": "application/json",
      "Authorization":token!
    });

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
          mRooyaUserTagList = List<UserTagModel>.from(
              data['data'].map((model) => UserTagModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }
}
