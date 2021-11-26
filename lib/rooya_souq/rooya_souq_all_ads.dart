import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/rooya_souq/rooya_ad_display.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class RooyaSouqAllAds extends StatefulWidget {
  @override
  _RooyaSouqAllAdsState createState() => _RooyaSouqAllAdsState();
}

class _RooyaSouqAllAdsState extends State<RooyaSouqAllAds> {
  bool isLoading = false;
  List<RooyaSouqModel> mRooyaSouqList = [];

  @override
  void initState() {
    getRooyaSouqAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.030,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 8.0.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Rooya Souq',
                        style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 14.0.sp,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                      Icon(
                        Icons.add_circle,
                        color: primaryColor,
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: primaryColor,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              // controller: mMobileNumber,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Search here...',
                                hintStyle: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 11.0.sp,
                                  color: const Color(0xff5a5a5a),
                                ),
                              ),
                            ),
                            height: height * 0.055,
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: primaryColor,
                          size: 3.0.h,
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Container(
                          height: 2.0.h,
                          width: 2.0.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/icons/filter.png'))),
                        ),
                        SizedBox(
                          width: 3.0.w,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: mRooyaSouqList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5.0.w,
                          mainAxisSpacing: 2.0.w,
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => RooyaAdDisplay(
                                      rooyaSouqModel: mRooyaSouqList[index],
                                    ))!
                                .then((value) {
                              if (value is bool) {
                                getRooyaSouqAll();
                              }
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Container(
                                  child: CachedNetworkImage(
                                    height: 15.0.h,
                                    imageUrl:
                                        '$baseImageUrl${mRooyaSouqList[index].images![0].attachment}',
                                    placeholder: (context, url) => ShimerEffect(
                                      child: Container(
                                        height: 15.0.h,
                                        child: Image.asset(
                                            'assets/images/nature.jpeg'),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 15.0.h,
                                      child: Image.asset(
                                          'assets/images/nature.jpeg'),
                                    ),
                                  ),
                                  color: Colors.blueGrey[100],
                                  width: double.infinity,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Text(
                                '${mRooyaSouqList[index].name} (${mRooyaSouqList[index].categoryName})',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 9,
                                  color: const Color(0xff000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${mRooyaSouqList[index].text}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 9,
                                  color: const Color(0xff000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                            'AED ${mRooyaSouqList[index].price}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: const Color(0xff0bab0d),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 8.0.sp)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          color: primaryColor,
                                          size: 2.0.h,
                                        )
                                      ],
                                    ),
                                  ),
                                  Text('${mRooyaSouqList[index].status}',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 8.0.sp,
                                        color: const Color(0xff5a5a5a),
                                      ))
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> getRooyaSouqAll() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaSouqbyLimit$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"page_size": 100, "page_number": 0}));
    setState(() {
      isLoading = false;
    });
    print(response.request);
    print(response.statusCode);
    // print(response.body);
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mRooyaSouqList = List<RooyaSouqModel>.from(
              data['data'].map((model) => RooyaSouqModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }
}
