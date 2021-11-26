import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya_app/CreateSouq/CategoriesSouq/CategoreSouq.dart';
import 'package:rooya_app/events/Models/CategorySouqModel.dart';
import 'package:rooya_app/models/RooyaCategoryModel.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/rooya_souq/create_souq.dart';
import 'package:rooya_app/rooya_souq/rooyaFeaturedDisplay.dart';
import 'package:rooya_app/rooya_souq/rooya_ad_display.dart';
import 'package:rooya_app/rooya_souq/rooya_souq_all_ads.dart';
import 'package:rooya_app/rooya_souq/rooya_souq_featured.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'CategoriesSouq/GetFavoriteSouq.dart';

class RooyaSouq extends StatefulWidget {
  @override
  _RooyaSouqState createState() => _RooyaSouqState();
}

class _RooyaSouqState extends State<RooyaSouq> {
  bool isLoading = false;
  List<RooyaSouqModel> mRooyaSouqFeaturedList = [];
  List<RooyaSouqModel> mRooyaSouqList = [];
  List<CategorySouqModel> mSouqCategoryList = [];
  List<RooyaSouqModel> mSouqSearchList = [];
  List<String> mMenuIcons = [
    'assets/icons/car.png',
    'assets/icons/electronics.png',
    'assets/icons/fashion.png',
    'assets/icons/health.png',
    'assets/icons/beauty.png',
    'assets/icons/property.png',
    'assets/icons/jobs.png',
    'assets/icons/furniture.png',
  ];
  List<String> mMenuTitle = [
    'Cars',
    'Electronics',
    'Fashion',
    'Health',
    'Beauty',
    'Property',
    'Jobs',
    'Furniture',
  ];
  var searchController = ''.obs;
  TextEditingController maxpriceController = TextEditingController();
  TextEditingController minpriceController = TextEditingController();
  List<RooyaCategoryModel> mRooyaCatList = [];
  RooyaCategoryModel? selectedCat;

  @override
  void initState() {
    getRooyaSouqFeatured();
    getRooyaSouqbyLimit();
    getCaegorySouq();
    getRooyaCat();
    debounce(searchController, (value) {
      print('Search value is =$value');
      if (value.toString().isEmpty) {
        mSouqSearchList = [];
        setState(() {});
      } else {
        getRooyaSouqSearch(word: value.toString());
      }
    }, time: Duration(milliseconds: 600));
    super.initState();
  }

  GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.030,
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                getRooyaSouqFeatured();
                getRooyaSouqbyLimit();
                getCaegorySouq();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      InkWell(
                        onTap: () {
                          Get.to(() => CreateSouq());
                        },
                        child: Icon(
                          Icons.add_circle,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(FavoriteSouq());
                        },
                        child: Icon(
                          Icons.favorite_border,
                          color: primaryColor,
                        ),
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
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              onChanged: (v) {
                                searchController.value = v;
                              },
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
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          height: height * 0.010,
                                        ),
                                        Align(
                                          child: InkWell(
                                            onTap: () {
                                              if (maxpriceController.text
                                                  .trim()
                                                  .isNotEmpty) {
                                                if (minpriceController.text
                                                    .trim()
                                                    .isNotEmpty) {
                                                  getRooyaSouqFilter();
                                                } else {
                                                  snackBarFailer(
                                                      'Please enter minimum price first');
                                                }
                                              } else {
                                                snackBarFailer(
                                                    'Please enter maximum price first');
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Done',
                                              style: TextStyle(
                                                  fontFamily: AppFonts.segoeui,
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor),
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                        SizedBox(
                                          height: height * 0.030,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: TextFormField(
                                            controller: maxpriceController,
                                            cursorColor: Colors.black,
                                            keyboardType: TextInputType.text,
                                            decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              isDense: true,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'Maximum Price',
                                              hintStyle: TextStyle(
                                                fontFamily: AppFonts.segoeui,
                                                fontSize: 11.0.sp,
                                                color: const Color(0xff5a5a5a),
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black45,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: height * 0.055,
                                        ),
                                        SizedBox(
                                          height: height * 0.010,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: TextFormField(
                                            controller: minpriceController,
                                            cursorColor: Colors.black,
                                            keyboardType: TextInputType.text,
                                            decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              isDense: true,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: 'Minimum Price',
                                              hintStyle: TextStyle(
                                                fontFamily: AppFonts.segoeui,
                                                fontSize: 11.0.sp,
                                                color: const Color(0xff5a5a5a),
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black45,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: height * 0.055,
                                        ),
                                        SizedBox(
                                          height: height * 0.010,
                                        ),
                                        Container(
                                          // width: 30.0.w,
                                          //  height: 5.0.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: Colors.grey[200],
                                          ),
                                          child: Center(
                                            child: DropdownButtonFormField<
                                                RooyaCategoryModel>(
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 2.0.w),
                                                enabledBorder: InputBorder.none,
                                              ),
                                              isExpanded: true,
                                              iconEnabledColor: primaryColor,
                                              iconSize: 3.0.h,
                                              itemHeight:
                                                  kMinInteractiveDimension,
                                              items: mRooyaCatList.map(
                                                  (RooyaCategoryModel value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(
                                                    value.categoryName!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            AppFonts.segoeui,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) async {
                                                setState(() {
                                                  selectedCat = value;
                                                });
                                              },
                                              style: TextStyle(
                                                  fontSize: 12.0.sp,
                                                  color: Colors.black),
                                              value: selectedCat,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            height: 2.0.h,
                            width: 2.0.h,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/icons/filter.png'))),
                          ),
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
                      child: mSouqSearchList.isNotEmpty
                          ? CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: InkWell(
                                    onTap: () {
                                      mSouqSearchList = [];
                                      setState(() {});
                                    },
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                    child: SizedBox(
                                  height: 5,
                                )),
                                SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5.0.w,
                                      mainAxisSpacing: 2.0.w,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => RooyaAdDisplay(
                                                    rooyaSouqModel:
                                                        mSouqSearchList[index],
                                                  ))!
                                              .then((value) {
                                            if (value is bool) {
                                              getRooyaSouqFeatured();
                                              getRooyaSouqbyLimit();
                                              getCaegorySouq();
                                            }
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              child: Container(
                                                child: CachedNetworkImage(
                                                  height: 15.0.h,
                                                  imageUrl:
                                                      '$baseImageUrl${mSouqSearchList[index].images![0].attachment}',
                                                  placeholder: (context, url) =>
                                                      ShimerEffect(
                                                    child: Container(
                                                      height: 15.0.h,
                                                      child: Image.asset(
                                                          'assets/images/nature.jpeg'),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    height: 15.0.h,
                                                    child: Image.asset(
                                                        'assets/images/nature.jpeg'),
                                                  ),
                                                ),
                                                width: double.infinity,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                            Text(
                                              '${mSouqSearchList[index].name} (${mSouqSearchList[index].categoryName})',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppFonts.segoeui,
                                                fontSize: 9,
                                                color: const Color(0xff000000),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              '${mSouqSearchList[index].text}',
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
                                                          'AED ${mSouqSearchList[index].price}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: const Color(
                                                                  0xff0bab0d),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  8.0.sp)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                          mSouqSearchList[index]
                                                                  .isLike!
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color: primaryColor,
                                                          size: 2.0.h,
                                                        ),
                                                        onTap: () async {
                                                          bool isForward = true;
                                                          if (isForward) {
                                                            isForward = false;
                                                            if (mSouqSearchList[
                                                                    index]
                                                                .isLike!) {
                                                              await unfavoriteSouq(
                                                                  post_id: mSouqSearchList[
                                                                          index]
                                                                      .postId
                                                                      .toString(),
                                                                  user_id: storage
                                                                      .read(
                                                                          'userID'));
                                                              setState(() {
                                                                mSouqSearchList[
                                                                            index]
                                                                        .isLike =
                                                                    false;
                                                              });
                                                            } else {
                                                              await favoriteSouq(
                                                                  post_id: mSouqSearchList[
                                                                          index]
                                                                      .postId
                                                                      .toString(),
                                                                  user_id: storage
                                                                      .read(
                                                                          'userID'));
                                                              setState(() {
                                                                mSouqSearchList[
                                                                        index]
                                                                    .isLike = true;
                                                              });
                                                            }
                                                            isForward = true;
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                    '${mSouqSearchList[index].status}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 8.0.sp,
                                                      color: const Color(
                                                          0xff5a5a5a),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }, childCount: mSouqSearchList.length))
                              ],
                            )
                          : CustomScrollView(
                              slivers: [
                                SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 5),
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(CategoriSouq(
                                            catID: mSouqCategoryList[index]
                                                .categoryId
                                                .toString(),
                                            catName: mSouqCategoryList[index]
                                                .categoryName,
                                          ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: const Color(0xffffffff),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x290bab0d),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 5.h,
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                  imageUrl:
                                                      '$baseImageUrl${mSouqCategoryList[index].icons}',
                                                  placeholder: (context, url) =>
                                                      ShimerEffect(
                                                    child: Container(
                                                      height: 6.h,
                                                      child: Image.asset(
                                                          'assets/images/nature.jpeg'),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    height: 6.h,
                                                    child: Image.asset(
                                                        'assets/images/nature.jpeg'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1.0.h,
                                                ),
                                                Text(
                                                  '${mSouqCategoryList[index].categoryName}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontSize: 10,
                                                    color:
                                                        const Color(0xff1e1e1e),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }, childCount: mSouqCategoryList.length)),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Featured',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontSize: 16,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      // Icon(
                                      //   Icons.arrow_forward,
                                      //   size: 20,
                                      //   color: primaryColor,
                                      // )
                                    ],
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 1.5.h,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                    height: 20.0.h,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            mRooyaSouqFeaturedList.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => RooyaAdDisplay(
                                                        rooyaSouqModel:
                                                            mRooyaSouqFeaturedList[
                                                                index],
                                                      ))!
                                                  .then((value) {
                                                if (value is bool) {
                                                  getRooyaSouqFeatured();
                                                  getRooyaSouqbyLimit();
                                                  getCaegorySouq();
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 18.0.h,
                                              margin:
                                                  EdgeInsets.only(right: 4.0.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    child: Container(
                                                      child: CachedNetworkImage(
                                                        height: 13.0.h,
                                                        width: 18.0.h,
                                                        imageUrl:
                                                            '$baseImageUrl${mRooyaSouqFeaturedList[index].images![0].attachment}',
                                                        placeholder:
                                                            (context, url) =>
                                                                ShimerEffect(
                                                          child: Container(
                                                            height: 13.0.h,
                                                            width: 18.0.h,
                                                            child: Image.asset(
                                                                'assets/images/nature.jpeg'),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          height: 13.0.h,
                                                          width: 18.0.h,
                                                          child: Image.asset(
                                                              'assets/images/nature.jpeg'),
                                                        ),
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Text(
                                                    '${mRooyaSouqFeaturedList[index].name} (${mRooyaSouqFeaturedList[index].categoryName})',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 9,
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    '${mRooyaSouqFeaturedList[index].text}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 9,
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                'AED ${mRooyaSouqFeaturedList[index].price}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: const Color(
                                                                        0xff0bab0d),
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .segoeui,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        8.0.sp)),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            InkWell(
                                                              child: Icon(
                                                                mRooyaSouqFeaturedList[
                                                                            index]
                                                                        .isLike!
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border,
                                                                color:
                                                                    primaryColor,
                                                                size: 2.0.h,
                                                              ),
                                                              onTap: () async {
                                                                bool isForward =
                                                                    true;
                                                                if (isForward) {
                                                                  isForward =
                                                                      false;
                                                                  if (mRooyaSouqFeaturedList[
                                                                          index]
                                                                      .isLike!) {
                                                                    await unfavoriteSouq(
                                                                        post_id: mRooyaSouqFeaturedList[index]
                                                                            .postId
                                                                            .toString(),
                                                                        user_id:
                                                                            storage.read('userID'));
                                                                    setState(
                                                                        () {
                                                                      mRooyaSouqFeaturedList[index]
                                                                              .isLike =
                                                                          false;
                                                                    });
                                                                  } else {
                                                                    await favoriteSouq(
                                                                        post_id: mRooyaSouqFeaturedList[index]
                                                                            .postId
                                                                            .toString(),
                                                                        user_id:
                                                                            storage.read('userID'));
                                                                    setState(
                                                                        () {
                                                                      mRooyaSouqFeaturedList[index]
                                                                              .isLike =
                                                                          true;
                                                                    });
                                                                  }
                                                                  isForward =
                                                                      true;
                                                                }
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                          '${mRooyaSouqFeaturedList[index].status}',
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .segoeui,
                                                            fontSize: 8.0.sp,
                                                            color: const Color(
                                                                0xff5a5a5a),
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 1.5.h,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'All',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontSize: 16,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Get.to(() => RooyaSouqAllAds());
                                          },
                                          child: Icon(
                                            Icons.arrow_forward,
                                            size: 20,
                                            color: primaryColor,
                                          ))
                                    ],
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 1.5.h,
                                  ),
                                ),
                                SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5.0.w,
                                      mainAxisSpacing: 2.0.w,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => RooyaAdDisplay(
                                                    rooyaSouqModel:
                                                        mRooyaSouqList[index],
                                                  ))!
                                              .then((value) {
                                            if (value is bool) {
                                              getRooyaSouqFeatured();
                                              getRooyaSouqbyLimit();
                                              getCaegorySouq();
                                            }
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              child: Container(
                                                child: CachedNetworkImage(
                                                  height: 15.0.h,
                                                  imageUrl:
                                                      '$baseImageUrl${mRooyaSouqList[index].images![0].attachment}',
                                                  placeholder: (context, url) =>
                                                      ShimerEffect(
                                                    child: Container(
                                                      height: 15.0.h,
                                                      child: Image.asset(
                                                          'assets/images/nature.jpeg'),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    height: 15.0.h,
                                                    child: Image.asset(
                                                        'assets/images/nature.jpeg'),
                                                  ),
                                                ),
                                                width: double.infinity,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: const Color(
                                                                  0xff0bab0d),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  8.0.sp)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                          mRooyaSouqList[index]
                                                                  .isLike!
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color: primaryColor,
                                                          size: 2.0.h,
                                                        ),
                                                        onTap: () async {
                                                          bool isForward = true;
                                                          if (isForward) {
                                                            isForward = false;
                                                            if (mRooyaSouqList[
                                                                    index]
                                                                .isLike!) {
                                                              await unfavoriteSouq(
                                                                  post_id: mRooyaSouqList[
                                                                          index]
                                                                      .postId
                                                                      .toString(),
                                                                  user_id: storage
                                                                      .read(
                                                                          'userID'));
                                                              setState(() {
                                                                mRooyaSouqList[
                                                                            index]
                                                                        .isLike =
                                                                    false;
                                                              });
                                                            } else {
                                                              await favoriteSouq(
                                                                  post_id: mRooyaSouqList[
                                                                          index]
                                                                      .postId
                                                                      .toString(),
                                                                  user_id: storage
                                                                      .read(
                                                                          'userID'));
                                                              setState(() {
                                                                mRooyaSouqList[
                                                                        index]
                                                                    .isLike = true;
                                                              });
                                                            }
                                                            isForward = true;
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                    '${mRooyaSouqList[index].status}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 8.0.sp,
                                                      color: const Color(
                                                          0xff5a5a5a),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }, childCount: mRooyaSouqList.length))
                              ],
                            )),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> getRooyaSouqFeatured() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaSouqFeatured$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          'user_id': storage.read('userID')
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
          mRooyaSouqFeaturedList = List<RooyaSouqModel>.from(
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

  Future<void> getRooyaSouqbyLimit() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaSouqbyLimit$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          'user_id': storage.read('userID')
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
        setState(() {});
      }
    }
  }

  Future<void> getCaegorySouq() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}getSouqCat$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          'user_id': storage.read('userID')
        }));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    // print(response.body);
    log('Souq Category list is = ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mSouqCategoryList = List<CategorySouqModel>.from(
              data['data'].map((model) => CategorySouqModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> getRooyaSouqSearch({String? word}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaSouqSearch$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          "search": word,
          'user_id': storage.read('userID')
        }));
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mSouqSearchList = List<RooyaSouqModel>.from(
              data['data'].map((model) => RooyaSouqModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> getRooyaSouqFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaSouqByFilter$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "category_id": selectedCat!.categoryId,
          "minprice": minpriceController.text,
          "maxprice": maxpriceController.text,
          "page_size": 100,
          "page_number": 0,
          "user_id": storage.read('userID')
        }));
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mSouqSearchList = List<RooyaSouqModel>.from(
              data['data'].map((model) => RooyaSouqModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> getRooyaFilter({String? word}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaSouqSearch$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "category_id": 1,
          "minprice": 1,
          "maxprice": 3500,
          "page_size": 100,
          "page_number": 0,
          'user_id': storage.read('userID')
        }));
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mSouqSearchList = List<RooyaSouqModel>.from(
              data['data'].map((model) => RooyaSouqModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> getRooyaCat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}getSouqCat${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"page_size": 100, "page_number": 0}));

    print(response.request);
    print(response.statusCode);
    // print(response.body);
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mRooyaCatList = List<RooyaCategoryModel>.from(
              data['data'].map((model) => RooyaCategoryModel.fromJson(model)));
          selectedCat = mRooyaCatList[0];
        });
      } else {
        setState(() {});
      }
    }
  }
}
