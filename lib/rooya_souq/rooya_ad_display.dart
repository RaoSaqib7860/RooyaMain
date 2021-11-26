import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/rooya_souq/EditSouq/EditSouq.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class RooyaAdDisplay extends StatefulWidget {
  RooyaSouqModel? rooyaSouqModel;

  RooyaAdDisplay({Key? key, @required this.rooyaSouqModel}) : super(key: key);

  @override
  _RooyaAdDisplayState createState() => _RooyaAdDisplayState();
}

class _RooyaAdDisplayState extends State<RooyaAdDisplay> {
  int _groupValue = 0;
  int selectedImageIndex = 0;
  TextEditingController mDescriptionController = TextEditingController();
  GetStorage storage = GetStorage();

  @override
  void initState() {
    print('i d=${widget.rooyaSouqModel!.userId}');
    print('id=${storage.read('userID')}');
    mDescriptionController.text = widget.rooyaSouqModel!.text!;
    if (widget.rooyaSouqModel!.status == 'new') {
      _groupValue = 0;
    } else {
      _groupValue = 1;
    }
    super.initState();
  }

  bool isLoading = false;

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
              'Details',
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
            actions: [
              widget.rooyaSouqModel!.userId.toString() == storage.read('userID')
                  ? Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(EditSouq(
                            rooyaSouqModel: widget.rooyaSouqModel,
                          ));
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: AppFonts.segoeui,
                              color: primaryColor),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.rooyaSouqModel!.userId.toString() == storage.read('userID')
                  ? IconButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await removeSouq();
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop(true);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.030),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ClipRRect(
                    child: InkWell(
                      onTap: () {
                        Get.to(ViewSouqPic(
                          images: widget.rooyaSouqModel!.images,
                        ));
                      },
                      child: Container(
                        child: CachedNetworkImage(
                          height: 30.0.h,
                          width: 100.0.h,
                          imageUrl:
                              '$baseImageUrl${widget.rooyaSouqModel!.images![selectedImageIndex].attachment}',
                          placeholder: (context, url) => ShimerEffect(
                            child: Container(
                              height: 13.0.h,
                              width: 18.0.h,
                              child: Image.asset('assets/images/nature.jpeg'),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 13.0.h,
                            width: 18.0.h,
                            child: Image.asset('assets/images/nature.jpeg'),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border:
                                Border.all(width: 1, color: Colors.black38)),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Container(
                    height: 10.0.h,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.rooyaSouqModel!.images!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(ViewSouqPic(
                                images: widget.rooyaSouqModel!.images,
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                              child: ClipRRect(
                                child: Container(
                                  child: CachedNetworkImage(
                                    height: 10.0.h,
                                    width: 10.0.h,
                                    imageUrl:
                                        '$baseImageUrl${widget.rooyaSouqModel!.images![index].attachment}',
                                    placeholder: (context, url) => ShimerEffect(
                                      child: Container(
                                        height: 10.0.h,
                                        width: 10.0.h,
                                        child: Image.asset(
                                            'assets/images/nature.jpeg'),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 10.0.h,
                                      width: 10.0.h,
                                      child: Image.asset(
                                          'assets/images/nature.jpeg'),
                                    ),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  Container(
                    width: 100.0.w,
                    // height: 7.0.h,
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w, vertical: 3.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey[200],
                    ),
                    child: Text('${widget.rooyaSouqModel!.name}',
                        style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff5a5a5a),
                        )),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 20.0.h,
                      minWidth: 100.0.w,
                      // maxHeight: 30.0,
                      maxWidth: 100.0.w,
                    ),
                    child: Container(
                      width: 100.0.w,
                      // height: 7.0.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0.w, vertical: 3.5.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text('${widget.rooyaSouqModel!.text}',
                          style: TextStyle(
                            fontFamily: AppFonts.segoeui,
                            fontSize: 11,
                            color: const Color(0xff5a5a5a),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Container(
                    width: 100.0.h,
                    // height: 7.0.h,
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w, vertical: 3.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey[200],
                    ),
                    child: Text('${widget.rooyaSouqModel!.categoryName}',
                        style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 11,
                          color: const Color(0xff5a5a5a),
                        )),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  // Container(
                  //   width: 100.0.h,
                  //   // height: 7.0.h,
                  //   padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 3.5.w),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     color: Colors.grey[200],
                  //   ),
                  //   child: Text('#iPhone',
                  //       style: TextStyle(
                  //         fontFamily: 'Segoe UI',
                  //         fontSize: 12.0.sp,
                  //         color: const Color(0xff5a5a5a),
                  //       )),
                  // ),
                  // SizedBox(height: 2.0.h,),
                  Container(
                    width: 100.0.h,
                    // height: 7.0.h,
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w, vertical: 3.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: Text('AED ${widget.rooyaSouqModel!.price}',
                        style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 12.0.sp,
                          color: const Color(0xff5a5a5a),
                        )),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Container(
                    width: 100.0.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Condition',
                            style: TextStyle(
                              fontFamily: AppFonts.segoeui,
                              fontSize: 12.0.sp,
                              color: const Color(0xff5a5a5a),
                            )),
                        Expanded(
                          flex: 1,
                          child: RadioListTile(
                            value: 0,
                            groupValue: _groupValue,
                            activeColor: primaryColor,
                            onChanged: (newValue) => setState(() => {}),
                            title: Text(
                              'New',
                              style: TextStyle(
                                fontFamily: AppFonts.segoeui,
                                fontSize: 10,
                                color: const Color(0xff222222),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RadioListTile(
                            value: 1,
                            groupValue: _groupValue,
                            activeColor: primaryColor,
                            onChanged: (newValue) => setState(() => {}),
                            title: Text(
                              'Used',
                              style: TextStyle(
                                fontFamily: AppFonts.segoeui,
                                fontSize: 10,
                                color: const Color(0xff222222),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0.w, vertical: 2.0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xff0bab0d),
                      ),
                      child: Center(
                        child: Text(
                          'Rooya Chat',
                          style: TextStyle(
                            fontFamily: AppFonts.segoeui,
                            fontSize: 12.0.sp,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> removeSouq({String? post_id, String? user_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}removeSouqProduct$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_id": widget.rooyaSouqModel!.postId,
          "product_id": widget.rooyaSouqModel!.productId,
          "user_id": user_id
        }));
  }
}

class ViewSouqPic extends StatefulWidget {
  List<Images>? images;

  ViewSouqPic({Key? key, @required this.images}) : super(key: key);

  @override
  _ViewSouqPicState createState() => _ViewSouqPicState();
}

class _ViewSouqPicState extends State<ViewSouqPic> {
  int? index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (i, dd) {
                    setState(() {
                      index = i;
                    });
                  }),
              items: widget.images!.map((item) {
                return PhotoView(
                  imageProvider:
                      NetworkImage("$baseImageUrl${item.attachment}"),
                );
                // return CachedNetworkImage(
                //   imageUrl: "$baseImageUrl${item.attachment}",
                //   fit: BoxFit.contain,
                //   placeholder: (context, url) => Container(
                //       height: 100.0.h,
                //       width: 100.0.w,
                //       child: Center(child: CircularProgressIndicator())),
                //   errorWidget: (context, url, error) => Container(
                //       height: 100.0.h,
                //       width: 100.0.w,
                //       child: Center(child: Icon(Icons.error))),
                // );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${index! + 1} /' + '${widget.images!.length}',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
