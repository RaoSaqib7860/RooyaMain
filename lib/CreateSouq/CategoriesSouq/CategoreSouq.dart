import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/rooya_souq/rooya_ad_display.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class CategoriSouq extends StatefulWidget {
  final String? catName;
  final String? catID;

  const CategoriSouq({Key? key, this.catName, this.catID}) : super(key: key);

  @override
  _CategoriSouqState createState() => _CategoriSouqState();
}

class _CategoriSouqState extends State<CategoriSouq> {
  bool isLoading = false;
  List<RooyaSouqModel> mRooyaSouqList = [];
  GetStorage storage = GetStorage();

  @override
  void initState() {
    getRooyaSouqfavoriteLimit();
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
            '${widget.catName}',
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
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: Column(
            children: [
              SizedBox(),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                            getRooyaSouqfavoriteLimit();
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
                                errorWidget: (context, url, error) => Container(
                                  height: 15.0.h,
                                  child:
                                      Image.asset('assets/images/nature.jpeg'),
                                ),
                              ),
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
                                    Text('AED ${mRooyaSouqList[index].price}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: const Color(0xff0bab0d),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 8.0.sp)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      child: Icon(
                                        mRooyaSouqList[index].isLike!
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: primaryColor,
                                        size: 2.0.h,
                                      ),
                                      onTap: () async {
                                        bool isForward = true;
                                        if (isForward) {
                                          isForward = false;
                                          if (mRooyaSouqList[index].isLike!) {
                                            await unfavoriteSouq(
                                                post_id: mRooyaSouqList[index]
                                                    .postId
                                                    .toString(),
                                                user_id:
                                                    storage.read('userID'));
                                            setState(() {
                                              mRooyaSouqList[index].isLike =
                                                  false;
                                            });
                                          } else {
                                            await favoriteSouq(
                                                post_id: mRooyaSouqList[index]
                                                    .postId
                                                    .toString(),
                                                user_id:
                                                    storage.read('userID'));
                                            setState(() {
                                              mRooyaSouqList[index].isLike =
                                                  true;
                                            });
                                          }
                                          isForward = true;
                                        }
                                      },
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
      )),
    );
  }

  Future<void> getRooyaSouqfavoriteLimit() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getProductBySouqCat$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "page_size": 100,
          "catid": widget.catID,
          "page_number": 0,
          "user_id": storage.read('userID')
        }));

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
          mRooyaSouqList = List<RooyaSouqModel>.from(
              data['data'].map((model) => RooyaSouqModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> favoriteSouq({String? post_id, String? user_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}SouqpostLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"post_id": post_id, "user_id": user_id}));
  }

  Future<void> unfavoriteSouq({String? post_id, String? user_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}SouqpostUnLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"post_id": post_id, "user_id": user_id}));
  }
}
