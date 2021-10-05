import 'package:flutter/material.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';

class RooyaAdDisplay extends StatefulWidget {
  RooyaSouqModel? rooyaSouqModel;

  RooyaAdDisplay({Key? key,@required this.rooyaSouqModel}):super(key: key);
  @override
  _RooyaAdDisplayState createState() => _RooyaAdDisplayState();
}

class _RooyaAdDisplayState extends State<RooyaAdDisplay> {

  int _groupValue = 0;
  int selectedImageIndex=0;
  TextEditingController mDescriptionController= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    mDescriptionController.text=widget.rooyaSouqModel!.text!;
    if(widget.rooyaSouqModel!.status=='new'){
      _groupValue=0;
    }else{
      _groupValue=1;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal:5.0.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 30.0.h,
                  width: 100.0.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage('$baseImageUrl${widget.rooyaSouqModel!.attachment![selectedImageIndex].source}')
                      )
                  ),
                ),
                SizedBox(height: 2.0.h,),
                Container(
                  height: 10.0.h,

                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.rooyaSouqModel!.attachment!.length,
                      itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            setState(() {
                              selectedImageIndex=index;
                            });
                          },
                          child: Container(
                            height: 10.0.h,
                            width: 10.0.h,
                            margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage('$baseImageUrl${widget.rooyaSouqModel!.attachment![index].source}')
                                )
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(height: 2.0.h,),
                Container(
                  width: 100.0.w,
                 // height: 7.0.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 3.5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child: Text('${widget.rooyaSouqModel!.name}',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize:12.0.sp,
                        color: const Color(0xff5a5a5a),
                      )),
                ),
                SizedBox(height: 2.0.h,),
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
                    padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 3.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child:Text('${widget.rooyaSouqModel!.text}',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize:12.0.sp,
                          color: const Color(0xff5a5a5a),
                        )),
                  ),
                ),
                SizedBox(height: 2.0.h,),
                Container(
                  width: 100.0.h,
                  // height: 7.0.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 3.5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child: Text('${widget.rooyaSouqModel!.categoryName}',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 12.0.sp,
                        color: const Color(0xff5a5a5a),
                      )),
                ),
                SizedBox(height: 2.0.h,),
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
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 3.5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child: Text('AED ${widget.rooyaSouqModel!.price}',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 12.0.sp,
                        color: const Color(0xff5a5a5a),
                      )),
                ),
                SizedBox(height: 2.0.h,),
                Container(
                  width: 100.0.h,
                  // height: 7.0.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w,vertical: 3.5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Condition',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
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
                              fontFamily: 'Segoe UI',
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
                              fontFamily: 'Segoe UI',
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
                SizedBox(height: 2.0.h,),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w,vertical: 3.0.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xff0bab0d),
                    ),
                    child: Text(
                      'Rooya Chat',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 12.0.sp,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 2.0.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
