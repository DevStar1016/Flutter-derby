// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/login_signup/Login.dart';
import 'package:goevent2/profile/loream.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/media.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/Config.dart';
import 'setting_screen.dart';

class Profile extends StatefulWidget {
  final String title;
  const Profile(this.title, {Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final x = Get.put(AuthController());

  bool isLodding = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  int favNumber = 10;
  int totalMatch = 17;
  String? networkimage;
  String? base64Image;

  late ColorNotifire notifire;
  String? text;
  List<DynamicPageData> dynamicPageDataList = [];
  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'عربى', 'locale': const Locale('ar', 'IN')},
    {'name': 'हिंदी', 'locale': const Locale('hi', 'IN')},
    {'name': 'Spanish', 'locale': const Locale('es', 'ES')},
    {'name': 'France', 'locale': const Locale('de', 'ES')},
    {'name': 'Germany', 'locale': const Locale('UN', 'ES')},
    {'name': 'Indonesia', 'locale': const Locale('fr', 'ES')},
    // **********************************************************
    {'name': 'South Africa', 'locale': const Locale('ZA', 'ES')},
    {'name': 'Turkish', 'locale': const Locale('tr', 'ES')},
    {'name': 'Portuguese', 'locale': const Locale('pt', 'ES')},
    {'name': 'Dutch', 'locale': const Locale('nl', 'ES')},
    {'name': 'Vietnamese', 'locale': const Locale('vi', 'ES')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    getWebData();
    print("Usename " + getData.read("UserLogin")["name"]);
    print(getData.read("UserLogin")["id"]);
    print(getData.read("UserLogin")["email"]);
    print(getData.read("UserLogin")["pro_pic"]);

    getData.read("UserLogin") != null
        ? setState(() {
            name.text = getData.read("UserLogin")["name"] ?? "";
            number.text = getData.read("UserLogin")["mobile"] ?? "";
            email.text = getData.read("UserLogin")["email"] ?? "";
            password.text = getData.read("UserLogin")["password"] ?? "";
            networkimage = getData.read("UserLogin")["pro_pic"] ?? "";
            getData.read("UserLogin")["pro_pic"] != "null"
                ? setState(() {
                    networkimageconvert();
                  })
                : const SizedBox();
          })
        : null;
  }

  networkimageconvert() {
    (() async {
      http.Response response =
          await http.get(Uri.parse(Config.base_url + networkimage.toString()));
      if (mounted) {
        print(response.bodyBytes);
        setState(() {
          base64Image = const Base64Encoder().convert(response.bodyBytes);
          print(base64Image);
        });
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Change this color to your desired color
      statusBarIconBrightness:
          Brightness.light, // Adjust the brightness of status bar icons
    ));
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: width,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: const BorderRadius.only()),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          child: Image.network(
                            "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png",
                            height: 50,
                            width: 50,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(() => SettingScreen(""));
                            },
                            child: Icon(Icons.settings, color: Colors.white))
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset("image/iraq_flag.png",
                                height: 20, width: 40, fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(favNumber.toString(),
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Gilroy Medium',
                                color: Colors.white)),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text(
                      name.text,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Gilroy Bold',
                          color: Colors.white),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    RatingBar.builder(
                      initialRating: 4.5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemSize: 20,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(height: Get.height * 0.02),

                    // Container(
                    //   width: Get.width * 0.4,
                    //   decoration: BoxDecoration(
                    //       color: Colors.transparent,
                    //       borderRadius: BorderRadius.circular(6),
                    //       border: Border.all(color: Colors.white, width: 0.5)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 6, vertical: 12),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Image.asset("image/edit_icon.png",
                    //             height: 20, width: 20),
                    //         SizedBox(width: Get.width * 0.02),
                    //         Text("Edit Profile",
                    //             style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontFamily: 'Gilroy Medium',
                    //                 color: Colors.white)),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Badge",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor),
                    ),
                    SizedBox(height: 10),
                    Container(
                        width: Get.width * 0.3,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.track_changes, color: Colors.white),
                            ],
                          ),
                        )),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text("Matches".tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.textcolor)),
                    SizedBox(height: 10),
                    Container(
                        width: Get.width * 0.3,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "17".tr,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Gilroy Medium',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.02),
            Column(
              children: [
                Text(
                  "Preferred Position".tr,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Gilroy Medium',
                      color: notifire.textcolor),
                ),
                SizedBox(height: 10),
                Container(
                    width: Get.width * 0.3,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Top".tr,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Gilroy Medium',
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Age".tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.textcolor),
                      ),
                      SizedBox(height: 5),
                      Container(
                          width: Get.width * 0.25,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "19".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Gilroy Medium',
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Height".tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.textcolor),
                      ),
                      SizedBox(height: 5),
                      Container(
                          width: Get.width * 0.25,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "170 cm".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Gilroy Medium',
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Preferred Foot".tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy Medium',
                            color: notifire.textcolor),
                      ),
                      SizedBox(height: 5),
                      Container(
                          width: Get.width * 0.25,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Left".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Gilroy Medium',
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Text('Favorite Team'.tr,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.textcolor)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: Get.width - (Get.width * 0.2),
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset("image/real_madrid.png",
                                  height: 30, width: 30),
                              SizedBox(width: Get.width * 0.02),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Real Madrid".tr,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  dialogShow({required String title}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              content: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              actions: <Widget>[
                TextButton(
                    child: Text("Delete".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                    onPressed: accountDelete),
                TextButton(
                  child: Text("No".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                  onPressed: () {
                    Get.back();
                  },
                )
              ]);
        });
  }

  settingWidget({Function()? onTap, String? tital, image, Widget? darkmode}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        height: 70,
        decoration: BoxDecoration(
            color: notifire.containercolore,
            border: Border.all(color: notifire.bordercolore, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image(
                            image: AssetImage(image!),
                            color: notifire.getdarkscolor),
                      )),
                  SizedBox(width: Get.width * 0.02),
                  Text(
                    tital!,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.textcolor),
                  ),
                ],
              ),
              darkmode ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: Colors.grey.withOpacity(0.4),
                  )
            ],
          ),
        ),
      ),
    );
  }

  void signoutSheetMenu() {
    showModalBottomSheet(
        backgroundColor: notifire.containercolore,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (builder) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Get.height * 0.02),
              Container(
                  height: 6,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25))),
              SizedBox(height: Get.height * 0.02),
              Text(
                "Logout".tr,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Gilroy Bold',
                    color: const Color(0xffF0635A)),
              ),
              SizedBox(height: Get.height * 0.02),
              Text(
                "Are you sure you want to log out?".tr,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Gilroy Medium',
                    color: notifire.gettextcolor),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Get.width * 0.35,
                    height: Get.height * 0.06,
                    child: MaterialButton(
                      color: const Color(0xFFE9E7FC),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Cancel".tr,
                          style: TextStyle(color: buttonColor, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.35,
                    height: Get.height * 0.06,
                    child: MaterialButton(
                      color: buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () {
                        getData.remove("UserLogin");
                        getData.remove("FirstUser");
                        Get.offAll(() => const Login());
                      },
                      child: Text(
                        "Yes Logout".tr,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.04),
            ],
          );
        });
  }

  //! Account Delete User
  accountDelete() {
    var data = {"uid": uID};
    ApiWrapper.dataPost(Config.deleteAc, data).then((accDelete) {
      log(accDelete.toString(), name: "Delete Data Api user :: ");
      if ((accDelete != null) && (accDelete.isNotEmpty)) {
        if ((accDelete['ResponseCode'] == "200") &&
            (accDelete['Result'] == "true")) {
          log(accDelete.toString(), name: "Account Delete :: ");
          getData.remove("UserData");
          Get.offAll(() => const Login());
          ApiWrapper.showToastMessage(accDelete["ResponseMsg"]);
        }
      }
    });
  }

  bottomsheet() {
    return showModalBottomSheet(
        backgroundColor: notifire.containercolore,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                height: Get.height * 0.7,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            updateLanguage(locale[index]['locale']);
                            print(locale[index]['name']);
                          });
                        },
                        child: Row(children: [
                          Image.asset(FlagList[index]["img"], height: 25),
                          SizedBox(width: Get.width * 0.03),
                          InkWell(
                              onTap: () {
                                print(locale[index]['name']);
                                updateLanguage(locale[index]['locale']);
                              },
                              child: Text(
                                locale[index]['name'],
                                style: TextStyle(color: notifire.textcolor),
                              )),
                        ]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.grey,
                      );
                    },
                    itemCount: locale.length));
          });
        });
  }

  void getWebData() {
    Map<String, dynamic> data = {};

    dynamicPageDataList.clear();
    ApiWrapper.dataPost(Config.pagelist, data).then((value) {
      if ((value != null) &&
          (value.isNotEmpty) &&
          (value['ResponseCode'] == "200")) {
        List da = value['pagelist'];
        for (int i = 0; i < da.length; i++) {
          Map<String, dynamic> mapData = da[i];
          DynamicPageData a = DynamicPageData.fromJson(mapData);
          dynamicPageDataList.add(a);
        }

        for (int i = 0; i < dynamicPageDataList.length; i++) {
          if ((widget.title == dynamicPageDataList[i].title)) {
            text = dynamicPageDataList[i].description;
            setState(() {});
            return;
          } else {
            text = "";
          }
        }
        print("jwgqdskdjchsjdilcuhsilcjsailkfhcjilsjfcsilkjfchidshfcid" +
            dynamicPageDataList.length.toString());
        setState(() {
          isLodding = true;
        });
      }
    });
  }
}
