import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/rooya_souq/rooya_ad_display.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
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
    // TODO: implement initState
    getRooyaSouqAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Colors.green, //change your color here
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Image.asset(
              'assets/images/logo.png',
              height: 8.0.h,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Rooya Souq',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 16,
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
                  height: 2.0.h,
                ),
                Container(
                  width: 100.0.h,
                  height: 7.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            // controller: mMobileNumber,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 0, top: 0, right: 15),
                              hintText: 'Search here...',
                              hintStyle: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 11.0.sp,
                                color: const Color(0xff5a5a5a),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          color: primaryColor,
                          size: 4.0.h,
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Container(
                          height: 3.0.h,
                          width: 3.0.h,
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
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  '$baseImageUrl${mRooyaSouqList[index].attachment![0].source}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 15.0.h,
                                width: 100.0.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: imageProvider)),
                              ),
                              placeholder: (context, url) => Container(
                                  height: 15.0.h,
                                  width: 100.0.w,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              '${mRooyaSouqList[index].name} (${mRooyaSouqList[index].categoryName})',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 9,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              '${mRooyaSouqList[index].text}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 9,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text('AED ${mRooyaSouqList[index].price}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: const Color(0xff0bab0d),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 8.0.sp)),
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
                                      fontFamily: 'Segoe UI',
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
        ));
  }

  Future<void> getRooyaSouqAll() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= await prefs.getString('token');
    final response =
    await http.post(Uri.parse('${baseUrl}getRooyaSouqbyLimit${code}'), headers: {
      "Content-Type": "application/json",
      "Authorization":token!
    },body: jsonEncode({
      "page_size":100,
      "page_number":1
    }));

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
        setState(() {

        });
      }
    }
  }
}
