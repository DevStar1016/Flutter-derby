import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/login_signup/Login.dart';
import 'package:goevent2/profile/ReferFriend.dart';
import 'package:goevent2/profile/faq.dart';
import 'package:goevent2/profile/loream.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/Config.dart';

class SubSettingScreen extends StatefulWidget {
  final String title;
  const SubSettingScreen(this.title, {Key? key}) : super(key: key);

  @override
  _SubSettingScreenState createState() => _SubSettingScreenState();
}

class _SubSettingScreenState extends State<SubSettingScreen> {
  final x = Get.put(AuthController());

  bool isLodding = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  String? networkimage;
  String? base64Image;

  late ColorNotifire notifire;
  String? text;
  static List<DynamicPageData> dynamicPageDataList = [];
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: notifire.textcolor),
        title: Text("Settings".tr,
            style: TextStyle(
                fontSize: 18, fontFamily: 'Gilroy', color: notifire.textcolor)),
        backgroundColor: notifire.backgrounde,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.02),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      settingWidget(
                        tital: "Refer a Friend".tr,
                        image: "image/Discount-1.png",
                        onTap: () {
                          Get.to(() => const ReferFriendPage());
                        },
                      ),
                      settingWidget(
                        tital: "Dark Mode".tr,
                        image: "image/Show.png",
                        darkmode: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: notifire.getbuttonscolor,
                            value: notifire.getIsDark,
                            onChanged: (val) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                notifire.setIsDark = val;
                                prefs.setBool("setIsDark", val);
                              });
                            },
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: dynamicPageDataList.length,
                        shrinkWrap: true,
                        itemExtent: 70,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() =>
                                  Loream(dynamicPageDataList[index].title));
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: notifire.containercolore,
                                      border: Border.all(
                                          color: notifire.bordercolore,
                                          width: 0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                radius: 20,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image(
                                                      image: AssetImage(
                                                          "image/Paper.png"),
                                                      color: notifire
                                                          .getdarkscolor),
                                                )),
                                            SizedBox(width: Get.width * 0.02),
                                            Text(
                                              dynamicPageDataList[index].title!,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Gilroy Medium',
                                                  color: notifire.textcolor),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: Colors.grey.withOpacity(0.4),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                          // return InkWell(
                          //   child: Column(
                          //     children: [
                          //
                          //       settingWidget(
                          //         tital: dynamicPageDataList[index].title,
                          //         image: "image/Paper.png",
                          //         onTap: () {
                          //           Get.to(() => Loream(
                          //               dynamicPageDataList[index].title));
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          //);
                        },
                      ),
                      settingWidget(
                        tital: "FAQ".tr,
                        image: "image/faq.png",
                        onTap: () {
                          Get.to(() => const Faq());
                        },
                      ),
                      settingWidget(
                          tital: "Langauge".tr,
                          image: "image/langauge.png",
                          onTap: bottomsheet),
                      settingWidget(
                        tital: "Delete Account".tr,
                        image: "image/Delete.png",
                        onTap: () {
                          dialogShow(
                              title:
                                  "Are you sure ?\n You want to delete the account"
                                      .tr);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
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

  // void signoutSheetMenu() {
  //   showModalBottomSheet(
  //       backgroundColor: notifire.containercolore,
  //       isDismissible: false,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
  //       clipBehavior: Clip.antiAliasWithSaveLayer,
  //       context: context,
  //       builder: (builder) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SizedBox(height: Get.height * 0.02),
  //             Container(
  //                 height: 6,
  //                 width: 80,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey.shade300,
  //                     borderRadius: BorderRadius.circular(25))),
  //             SizedBox(height: Get.height * 0.02),
  //             Text(
  //               "Logout".tr,
  //               style: TextStyle(
  //                   fontSize: 20,
  //                   fontFamily: 'Gilroy Bold',
  //                   color: const Color(0xffF0635A)),
  //             ),
  //             SizedBox(height: Get.height * 0.02),
  //             Text(
  //               "Are you sure you want to log out?".tr,
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontFamily: 'Gilroy Medium',
  //                   color: notifire.gettextcolor),
  //             ),
  //             SizedBox(height: Get.height * 0.02),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 SizedBox(
  //                   width: Get.width * 0.35,
  //                   height: Get.height * 0.06,
  //                   child: MaterialButton(
  //                     color: const Color(0xFFE9E7FC),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(25)),
  //                     onPressed: () {
  //                       Get.back();
  //                     },
  //                     child: Text("Cancel".tr,
  //                         style: TextStyle(color: buttonColor, fontSize: 16)),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: Get.width * 0.35,
  //                   height: Get.height * 0.06,
  //                   child: MaterialButton(
  //                     color: buttonColor,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(25)),
  //                     onPressed: () {
  //                       getData.remove("UserLogin");
  //                       getData.remove("FirstUser");
  //                       Get.offAll(() => const Login());
  //                     },
  //                     child: Text(
  //                       "Yes Logout".tr,
  //                       style:
  //                           const TextStyle(color: Colors.white, fontSize: 14),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //             SizedBox(height: Get.height * 0.04),
  //           ],
  //         );
  //       });
  // }

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
