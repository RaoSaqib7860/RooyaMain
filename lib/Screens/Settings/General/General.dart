import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/GlobalClass/TextFieldsCustom.dart';
import 'package:rooya_app/Screens/Settings/General/CountryModel.dart';
import 'package:rooya_app/Screens/Settings/General/GeneralController.dart';
import 'package:rooya_app/story/uploadStroy.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class General extends StatefulWidget {
  const General({Key? key}) : super(key: key);

  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  String countryCode = '+971';
  SharedPreferences? prefs;
  final controller = Get.put(GeneralController());
  CountryModel? selectedCat;
  String current_country = '';

  @override
  void initState() {
    AuthUtils.getAllCountry(controller: controller);
    Future.delayed(Duration(), () async {
      prefs = await SharedPreferences.getInstance();
      controller.fNameCont.text = prefs!.getString('user_firstname')!;
      controller.lNameCont.text = prefs!.getString('user_lastname')!;
      controller.emailCont.text = prefs!.getString('user_email')!;
      print('contry =${prefs!.getString('user_country')}');
      current_country = prefs!.getString('user_country') == '' ||
              prefs!.getString('user_country') == null ||
              prefs!.getString('user_country') == ''
          ? ''
          : prefs!.getString('user_country')!;
      controller.gender.value = prefs!.getString('user_gender') == '' ||
              prefs!.getString('user_gender') == null ||
              prefs!.getString('user_gender') == 'null'
          ? 'Male'
          : prefs!.getString('user_gender') == '0'
              ? 'Male'
              : 'Female';
      controller.phoneCont.text = prefs!.getString('user_phone')!;
      setState(() {});
    });
    super.initState();
  }

  GetStorage storage = GetStorage();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    print('${storage.read('user_cover')}');
    return LayoutBuilder(builder: (c, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
      return ProgressHUD(
        inAsyncCall: loading,
        opacity: 0.7,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Get.back();
              },
              color: Colors.white,
            ),
            centerTitle: false,
            title: Text(
              'GENERAL',
              style: TextStyle(
                  fontFamily: AppFonts.segoeui,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Obx(
              () => Stack(
                children: [
                  Container(
                    height: height * 0.150,
                    width: width,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: controller.profilePath2.value == ''
                        ? storage.read('user_cover') != '' ||
                                storage.read('user_cover') != null
                            ? Image.network(
                                '$baseImageUrl${storage.read('user_cover')}',
                                fit: BoxFit.cover,
                              )
                            : SizedBox()
                        : Image.file(
                            File('${controller.profilePath2.value}'),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.030),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Obx(
                              () => controller.profilePath.value != ''
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.050,
                                        ),
                                        CircularProfileAvatar(
                                          '',
                                          child: Image.file(
                                            File(controller.profilePath.value),
                                            fit: BoxFit.cover,
                                          ),
                                          elevation: 5,
                                          radius: 50,
                                          borderColor: primaryColor,
                                          borderWidth: 1,
                                        ),
                                      ],
                                    )
                                  : storage.read('user_picture') == null ||
                                          storage.read('user_picture') == ''
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: height * 0.050,
                                            ),
                                            CircularProfileAvatar(
                                              '',
                                              child: Image.asset(
                                                  'assets/images/logo.png'),
                                              elevation: 5,
                                              radius: 50,
                                              borderColor: primaryColor,
                                              borderWidth: 1,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: height * 0.050,
                                            ),
                                            CircularProfileAvatar(
                                              '$baseImageUrl${storage.read('user_picture')}',
                                              elevation: 5,
                                              radius: 50,
                                              borderColor: primaryColor,
                                              borderWidth: 1,
                                            ),
                                          ],
                                        ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: height * 0.050,
                                ),
                                InkWell(
                                  child:
                                      SvgPicture.asset('assets/svg/edit.svg'),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            elevation: 0,
                                            backgroundColor:
                                                Colors.black.withOpacity(0.5),
                                            insetPadding: EdgeInsets.symmetric(
                                                horizontal: width / 10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            //this right here
                                            child: Container(
                                              height: height / 5,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      controller
                                                          .onImageButtonPressed(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: height * 0.050,
                                                        decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.1),
                                                        child: Center(
                                                          child: Text(
                                                            'CAMERA',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    AppFonts
                                                                        .segoeui,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      controller
                                                          .onImageButtonPressed(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: height * 0.050,
                                                        decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.1),
                                                        child: Center(
                                                          child: Text(
                                                            'GALLERY',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    AppFonts
                                                                        .segoeui,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.010,
                        ),
                        TextFieldsProfile(
                          controller: controller.fNameCont,
                          hint: 'First Name',
                          uperhint: 'First Name',
                          width: width,
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        TextFieldsProfile(
                          controller: controller.lNameCont,
                          hint: 'Last Name'.tr,
                          uperhint: 'Last Name'.tr,
                          width: width,
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        TextFieldsProfile(
                          controller: controller.emailCont,
                          hint: 'Email'.tr,
                          uperhint: 'Email'.tr,
                          width: width,
                          enable: false,
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.015),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Country',
                              style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.segoeui),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height / 130,
                        ),
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.green.withOpacity(0.10),
                                      offset: Offset(4, 4),
                                      blurRadius: 3),
                                  BoxShadow(
                                      color: Colors.green.withOpacity(0.1),
                                      offset: Offset(-0.5, -0.5),
                                      blurRadius: 1)
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: DropdownButtonFormField<CountryModel>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 2.0.w),
                                  enabledBorder: InputBorder.none,
                                ),
                                isExpanded: true,
                                iconEnabledColor: primaryColor,
                                iconSize: 3.0.h,
                                itemHeight: kMinInteractiveDimension,
                                items: controller.listofCountry
                                    .map((CountryModel value) {
                                  return new DropdownMenuItem(
                                    value: value,
                                    child: new Text(
                                      value.countryName!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: AppFonts.segoeui,
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
                                    fontSize: 12.0.sp, color: Colors.black),
                                value: selectedCat,
                                hint: Text(
                                  '$current_country',
                                  style: TextStyle(
                                      fontSize: 12.0.sp, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Container(
                          width: width,
                          height: height * 0.065,
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.030),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.green.withOpacity(0.10),
                                    offset: Offset(4, 4),
                                    blurRadius: 3),
                                BoxShadow(
                                    color: Colors.green.withOpacity(0.1),
                                    offset: Offset(-0.5, -0.5),
                                    blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton<String>(
                            items:
                                <String>['Male', 'Female'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: AppFonts.segoeui),
                                ),
                              );
                            }).toList(),
                            underline: SizedBox(),
                            isExpanded: true,
                            hint: Text(
                              '${controller.gender.value}',
                              style: TextStyle(
                                  fontSize: 12, fontFamily: AppFonts.segoeui),
                            ),
                            onChanged: (value) {
                              controller.gender.value = value!;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.015),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.segoeui),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.008,
                        ),
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.green.withOpacity(0.10),
                                    offset: Offset(4, 4),
                                    blurRadius: 3),
                                BoxShadow(
                                    color: Colors.green.withOpacity(0.1),
                                    offset: Offset(-0.5, -0.5),
                                    blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              CountryCodePicker(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                hideMainText: false,
                                alignLeft: false,
                                onChanged: (e) {
                                  print(e.dialCode);
                                  setState(() {
                                    countryCode = e.dialCode!;
                                  });
                                },
                                initialSelection: '+971',
                                enabled: false,
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                favorite: ['+971', 'UAE'],
                              ),
                              Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        countryCode == '+971' ? 9 : 10),
                                  ],
                                  controller: controller.phoneCont,
                                  keyboardType: TextInputType.number,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width * 0.030),
                                      border: InputBorder.none,
                                      hintText: countryCode == '+971'
                                          ? '55 505 5505'
                                          : '555 505 5505',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.030,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            String? profile;
                            String? cover;
                            if (controller.profilePath.value != '') {
                              profile = await createStory(
                                  controller.profilePath.value);
                            } else {
                              profile = storage.read('user_picture');
                            }
                            if (controller.profilePath2.value != '') {
                              cover = await createStory(
                                  controller.profilePath2.value);
                            } else {
                              cover = storage.read('user_cover');
                            }
                            await AuthUtils.getgeneralSetting(
                                controller: controller,
                                CountryModel: selectedCat,
                                country_code: countryCode,
                                cover: cover,
                                countryName: selectedCat == null
                                    ? current_country
                                    : selectedCat!.countryName,
                                profile: profile);
                            setState(() {
                              loading = false;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: height * 0.060,
                            width: width,
                            child: Center(
                              child: Text(
                                'SAVE CHANGES',
                                style: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.050,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                elevation: 0,
                                backgroundColor: Colors.black.withOpacity(0.5),
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: width / 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                //this right here
                                child: Container(
                                  height: height / 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          controller.onImageButtonPressed(
                                              source: ImageSource.camera,
                                              fromCover: true);
                                        },
                                        child: Center(
                                          child: Container(
                                            width: double.infinity,
                                            height: height * 0.050,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: width * 0.1),
                                            child: Center(
                                              child: Text(
                                                'CAMERA',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          controller.onImageButtonPressed(
                                              source: ImageSource.gallery,
                                              fromCover: true);
                                        },
                                        child: Center(
                                          child: Container(
                                            width: double.infinity,
                                            height: height * 0.050,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: width * 0.1),
                                            child: Center(
                                              child: Text(
                                                'GALLERY',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Edit Cover',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            physics: BouncingScrollPhysics(),
          ),
        )),
      );
    });
  }
}
