import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/explore_uae/explore_all.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';

import '../create_all.dart';

class ExploreUAE extends StatefulWidget {
  @override
  _ExploreUAEState createState() => _ExploreUAEState();
}

class _ExploreUAEState extends State<ExploreUAE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 1.5.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.png',
                        height: 5.0.h,),
                      Expanded(
                        child: Container(
                          height: 5.0.h,
                          margin:
                          EdgeInsets.symmetric(horizontal: 2.0.w),
                          padding:
                          EdgeInsets.symmetric(horizontal: 2.5.w),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Search here...',
                                  style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 9.0.sp
                                  ),),
                              ),
                              Icon(
                                Icons.search,
                                color: primaryColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: (){
                            Get.to(()=>CreateAll());
                          },
                          child: Icon(Icons.add_circle,color: primaryColor,)),
                      SizedBox(width: 1.0.w,),
                      Icon(Icons.notifications,color: Colors.black,),
                      SizedBox(width: 1.0.w,),
                      Icon(Icons.mail,color: primaryColor,),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30.0.w,
                      //  height: 5.0.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],

                      ),
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 2.0.w),
                            enabledBorder: InputBorder.none,
                          ),
                          isExpanded: true,
                          iconEnabledColor: primaryColor,
                          iconSize: 3.0.h,

                          itemHeight: kMinInteractiveDimension,
                          items: ['Abu Dhabi','B','C'].map((String value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text(value,overflow: TextOverflow.ellipsis,),
                            );
                          }).toList(),
                          onChanged: (value) async {

                          },
                          style: TextStyle(fontSize: 12.0.sp,color: Colors.black),
                          value:'Abu Dhabi' ,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.0.w,),
                    Container(
                      height: 4.0.h,
                      width: 4.0.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icons/filter.png')
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Famous Places',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          Get.to(()=>ExploreAll(exploreType:'Famous Places' ,));
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12.0.sp,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.left,
                        ),)
                  ],
                ),
                SizedBox(height: 1.5.h,),
                Container(
                  height: 18.0.h,
                  width: 100.0.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                      itemBuilder: (context,index){
                    return CachedNetworkImage(
                      imageUrl: 'https://cdn-prod.medicalnewstoday.com/content/images/articles/325/325466/man-walking-dog.jpg',
                      imageBuilder: (context, imageProvider) => Container(
                        height: 18.0.h,
                        width: 70.0.w,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: imageProvider)),
                        child:  Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Text('Lorem Lipsm ',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 10.0.sp,
                                color: Colors.white,
                              ),),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                          height: 18.0.h,
                          width: 70.0.w,
                          child: Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );

                  }),
                ),
                SizedBox(height: 1.5.h,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Places for Adventure',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(()=>ExploreAll(exploreType:'Places for Adventure' ,));
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 12.0.sp,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.left,
                      ),)
                  ],
                ),
                SizedBox(height: 1.5.h,),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 3.0.w,
                        mainAxisSpacing: 3.0.w,
                        childAspectRatio: 100.0.w/30.0.h,
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return  InkWell(
                        onTap: (){
                        },
                        child: CachedNetworkImage(
                          imageUrl: 'https://cdn-prod.medicalnewstoday.com/content/images/articles/325/325466/man-walking-dog.jpg',
                          imageBuilder: (context, imageProvider) => Container(
                            height: 10.0.h,
                            width: 100.0.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: imageProvider)),
                            child:  Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text('Lorem Lipsm ',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 10.0.sp,
                                    color: Colors.white,
                                  ),),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                              height: 10.0.h,
                              width: 100.0.w,
                              child: Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 1.5.h,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Kids Fun',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(()=>ExploreAll(exploreType:'Kids Fun' ,));
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 12.0.sp,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.left,
                      ),)
                  ],
                ),
                SizedBox(height: 1.5.h,),
                Container(
                  height: 15.0.h,
                  width: 100.0.w,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context,index){
                        return CachedNetworkImage(
                          imageUrl: 'https://cdn-prod.medicalnewstoday.com/content/images/articles/325/325466/man-walking-dog.jpg',
                          imageBuilder: (context, imageProvider) => Container(
                            height: 15.0.h,
                            width: 15.0.h,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: imageProvider)),
                            child:  Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text('Lorem Lipsm ',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 10.0.sp,
                                    color: Colors.white,
                                  ),),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                              height: 15.0.h,
                              width: 15.0.h,
                              child: Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        );

                      }),
                ),
                SizedBox(height: 1.5.h,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Brand Offers',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Get.to(()=>ExploreAll(exploreType:'Brand Offers' ,));
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 12.0.sp,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.left,
                      ),)
                  ],
                ),
                SizedBox(height: 1.5.h,),
                Container(
                  height: 18.0.h,
                  width: 100.0.w,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context,index){
                        return CachedNetworkImage(
                          imageUrl: 'https://cdn-prod.medicalnewstoday.com/content/images/articles/325/325466/man-walking-dog.jpg',
                          imageBuilder: (context, imageProvider) => Container(
                            height: 18.0.h,
                            width: 70.0.w,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: imageProvider)),
                            child:  Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text('Lorem Lipsm ',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 10.0.sp,
                                    color: Colors.white,
                                  ),),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                              height: 18.0.h,
                              width: 70.0.w,
                              child: Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        );

                      }),
                ),
                SizedBox(height: 1.5.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
