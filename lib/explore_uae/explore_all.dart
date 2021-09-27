import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/explore_uae/places_detail.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';

class ExploreAll extends StatefulWidget {
  String? exploreType;
  ExploreAll({Key? key,this.exploreType}):super(key: key);
  @override
  _ExploreAllState createState() => _ExploreAllState();
}

class _ExploreAllState extends State<ExploreAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 1.5.h,vertical: 1.5.w),
          child: Column(
            children: [
              Row(
                children: [
                 InkWell(
                   onTap: (){
                     Get.back();
                   },
                   child: Icon(Icons.arrow_back),
                 ),
                  SizedBox(width: 2.0.w,),
                  Expanded(child: Text('${widget.exploreType}',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 13.0.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ))),
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
                    height: 3.0.h,
                    width: 3.0.h,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/icons/filter.png')
                        )
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0.w,),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 20,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 3.0.w,
                      mainAxisSpacing: 3.0.w,
                      childAspectRatio: 100.0.w/32.0.h,
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Get.to(()=>PlacesDetail());
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                        'https://cdn-prod.medicalnewstoday.com/content/images/articles/325/325466/man-walking-dog.jpg',
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              height: 25.0.h,
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
                            height: 15.0.h,
                            width: 100.0.w,
                            child: Center(
                                child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
