import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';

class PlacesDetail extends StatefulWidget {
  @override
  _PlacesDetailState createState() => _PlacesDetailState();
}

class _PlacesDetailState extends State<PlacesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl:
              'https://cdn-prod.medicalnewstoday.com/content/images/articles/325/325466/man-walking-dog.jpg',
              imageBuilder: (context, imageProvider) =>
                  Container(
                    height: 30.0.h,
                    width: 100.0.w,
                    decoration: BoxDecoration(

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
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 1.5.h,vertical: 2.0.h),
              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: Text('Shaikh Zayed Mosque',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 14.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                            )
                        ),
                      ),
                      Material(
                        shape: CircleBorder(),
                        elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle
                              ),

                              child: Image.asset('assets/icons/forward.png',height: 3.0.h,)))
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                              shape: CircleBorder(),
                              elevation: 5,
                              child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle
                                  ),

                                  child: Image.asset('assets/icons/call.png',height: 3.0.h,width: 3.0.h,))),
                          SizedBox(height: 1.0.h,),
                          Text('Call',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 12.0.sp,
                                color: Colors.black,
                              ) )
                        ],
                      ),
                      SizedBox(width: 4.0.w,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                              shape: CircleBorder(),
                              elevation: 5,
                              child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle
                                  ),

                                  child: Image.asset('assets/icons/location.png',height: 3.0.h,width: 3.0.h,))),
                          SizedBox(height: 1.0.h,),
                          Text('Directions',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 12.0.sp,
                                color: Colors.black,
                              ) )
                        ],
                      ),
                      SizedBox(width: 4.0.w,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                              shape: CircleBorder(),
                              elevation: 5,
                              child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle
                                  ),

                                  child: Image.asset('assets/icons/globe.png',height: 3.0.h,width: 3.0.h,))),
                          SizedBox(height: 1.0.h,),
                          Text('Website',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 12.0.sp,
                                color: Colors.black,
                              ) )
                        ],
                      ),
                      Expanded(child: Container()),
                      Container(
                        padding: EdgeInsets.all(1.0.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff0bab0d)),
                            borderRadius: BorderRadius.circular(3.5.h)),
                        child: Text('Free Entry',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 12,
                              color: const Color(0xff0bab0d),
                              fontWeight: FontWeight.w700,
                            )),
                      )
                    ],
                  ),
                  SizedBox(height: 2.0.h,),
                  Text('The design of the Sheikh Zayed Mosque has been inspired by Persian, Mughal, and the Alexandrian Mosque of Abu al-Abbas al-Mursi Mosque in Egypt, also the Indo-Islamic mosque architecture, particularly the Badshahi Mosque in Lahore, Pakistan being direct influences.\n\nThe dome layout and floorplan of the mosque was inspired by the Badshahi Mosque. Its archways are quintessentially Moorish and its minarets classically Arab. Under lead contractor Impregilo (Italy), more than 3,000 workers and 38 sub-contracting companies took part in its construction.\n\nNatural materials were chosen for much of its design and construction due to their long-lasting qualities, including marble stone, gold, semi-precious stones, crystals and ceramics. Artisans and materials came from many countries including India, Italy, Germany, Egypt, Turkey, Morocco, Pakistan, Malaysia, Iran, China, United Kingdom, New Zealand, Republic of Macedonia and United Arab Emirates.',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 10.0.sp,
                        color: Colors.black,
                      )),
                  SizedBox(height: 3.0.h,),
                  Text('Connect Us at',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14.0.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      )),
                  SizedBox(height: 3.0.h,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/socialicons/insta.png',height: 5.0.h,),
                      SizedBox(width: 3.0.w,),
                      Image.asset('assets/socialicons/whatsapp.png',height: 5.0.h,),
                      SizedBox(width: 3.0.w,),
                      Image.asset('assets/socialicons/facebook.png',height: 5.0.h,),
                      SizedBox(width: 3.0.w,),
                      Image.asset('assets/socialicons/snapchat.png',height: 5.0.h,),
                      SizedBox(width: 3.0.w,),
                      Image.asset('assets/socialicons/tiktok.png',height: 5.0.h,)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
