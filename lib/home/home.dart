// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print, unused_local_variable, unused_import, unnecessary_null_comparison, prefer_final_fields, prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/Search/SearchPage.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/home/TrendingCatPage.dart';
import 'package:goevent2/home/seeall.dart';
import 'package:goevent2/home/ticket.dart';
import 'package:goevent2/spleshscreen.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/string.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../Controller/custom_home_controller.dart';
import '../Search/searchpage2.dart';
import '../notification/notification.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

final getData = GetStorage();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final x = Get.put(AuthController());
  final hData = Get.put(HomeController());
  final customHomeController = Get.put(CustomHomeController());
  late ColorNotifire notifire;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  bool isChecked = false;
  String code = "0";
  RxBool isDateSelected = false.obs;

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
    walletrefar();
    getdarkmodepreviousstate();
    getUserLocation();
    getPackage();
    getData.read("UserLogin") != null
        ? hData.homeDataApi(getData.read("UserLogin")["id"], lat, long)
        : null;
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    OneSignal.initialize(Config.oneSignel);

    OneSignal.Notifications.addPermissionObserver((changes) {
      print("Accepted OSPermissionStateChanges : $changes");
    });

    print("--------------__uID : ${getData.read("UserLogin")["id"]}");
    await OneSignal.User.addTagWithKey(
        "storeid", getData.read("UserLogin")["id"]);
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  getUserLocation() async {
    Position position = await getLatLong();

    lat = position.longitude.toString();
    long = position.latitude.toString();
    // lat = "33.223190";
    // long = "73.135002";
    setState(() {});
  }

  Future<Position> getLatLong() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //! ----- LikeButtonTapped -----
  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          hData.homeDataReffressApi(getData.read("UserLogin")["id"], lat, long);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        backgroundColor: notifire.backgrounde,
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   child: Container(
        //     width: 300,
        //     decoration: BoxDecoration(
        //         color: notifire.homecontainercolore,
        //         borderRadius: const BorderRadius.all(Radius.circular(20))),
        //     height: 60,
        //     child: Stack(
        //       children: [
        //         CustomPaint(
        //           size: Size(Get.width, 80),
        //           painter: SideCutsDesign(),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            //! ------ Home AppBar ------
            homeAppbar(),

            Expanded(
              child: SingleChildScrollView(
                child: !hData.isLoading
                    ? Container(
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            hData.trendingEvent.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        Text("Upcoming Matches".tr,
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Bold',
                                                color: notifire.textcolor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => All(
                                                    title:
                                                        "Upcoming Matches".tr,
                                                    eventList:
                                                        hData.trendingEvent),
                                                duration: Duration.zero);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text("See All".tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Gilroy Medium',
                                                        color: const Color(
                                                            0xff747688),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Color(0xff747688)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),

                            SizedBox(height: 8),
                            hData.trendingEvent.isNotEmpty
                                ? Container(
                                    width: Get.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i <
                                                CustomHomeController
                                                    .instance.dates.length;
                                            i++)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                CustomHomeController
                                                    .instance.currentIndex = i;
                                                setState(() {});
                                              },
                                              child: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: CustomHomeController
                                                              .instance
                                                              .currentIndex ==
                                                          i
                                                      ? notifire.getwhitecolor
                                                      : notifire.getwhitecolor
                                                          .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        CustomHomeController
                                                            .instance.days[i],
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Gilroy Medium',
                                                          color: CustomHomeController
                                                                      .instance
                                                                      .currentIndex ==
                                                                  i
                                                              ? notifire
                                                                  .getprimerycolor
                                                              : notifire
                                                                  .textcolor,
                                                          fontSize: 12,
                                                        )),
                                                    Text(
                                                      CustomHomeController
                                                          .instance.dates[i],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Gilroy BOLD',
                                                          color: CustomHomeController
                                                                      .instance
                                                                      .currentIndex ==
                                                                  i
                                                              ? notifire
                                                                  .getprimerycolor
                                                              : notifire
                                                                  .textcolor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  )
                                : Container(),

                            SizedBox(height: 8),
                            hData.trendingEvent.isNotEmpty
                                ? Container(
                                    height: 250,
                                    child: Row(
                                      children: [
                                        for (int i = 0; i < 2; i++)
                                          tredingEvents(hData.trendingEvent, i)
                                      ],
                                    ),
                                  )
                                : Container(),
                            //     child: GridView.builder(
                            //       gridDelegate:
                            //           SliverGridDelegateWithFixedCrossAxisCount(
                            //         crossAxisCount: 2,
                            //         childAspectRatio: 0.79,
                            //       ),
                            //       itemBuilder: (ctx, i) {
                            //         return tredingEvents(
                            //             hData.trendingEvent, i);
                            //       },
                            //       itemCount: 2,
                            //       shrinkWrap: true,
                            //       physics: NeverScrollableScrollPhysics(),
                            //     ),
                            //   )
                            // : Container(),
                            SizedBox(height: 30),
                            hData.upcomingEvent.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        Text("Today's Matches".tr,
                                            style: TextStyle(
                                                fontFamily: 'Gilroy Bold',
                                                color: notifire.textcolor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => All(
                                                    title: "Today's Matches".tr,
                                                    eventList:
                                                        hData.upcomingEvent),
                                                duration: Duration.zero);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text("See All".tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Gilroy Medium',
                                                        color: const Color(
                                                            0xff747688),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Color(0xff747688)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),

                            SizedBox(height: height / 60),

                            //! ----------- Upcoming Events List -------------
                            Container(),

                            Ink(
                              height: 270,
                              child: ListView.builder(
                                itemCount: hData.upcomingEvent.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return events(hData.upcomingEvent[i], i);
                                },
                              ),
                            ),
                            SizedBox(height: height / 60),

                            // Container(
                            //   color: Colors.black,
                            //   child: ClipPath(
                            //     clipper: CustomShape(),
                            //     child: Container(
                            //       height: 60,
                            //       width: 380,
                            //       decoration: BoxDecoration(
                            //           color: notifire.getblackcolor,
                            //           borderRadius: const BorderRadius.only()),
                            //     ),
                            //   ),
                            // ),

                            // ListView.builder(
                            //   itemCount: hData.thisMonthEvent.length,
                            //   padding: const EdgeInsets.only(top: 8),
                            //   shrinkWrap: true,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   itemBuilder: (ctx, i) {
                            //     return monthly(hData.thisMonthEvent, i);
                            //   },
                            // ),
                          ],
                        ),
                      )
                    : isLoadingCircular(),
              ),
            ),
          ],
        ));
  }

  treding(catList, i) {
    return InkWell(
      onTap: () {
        Get.to(() => TrndingPage(catdata: catList[i]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
              color: notifire.getprimerycolor,
              border: Border.all(color: notifire.bordercolore, width: 0.5),
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Row(
              children: [
                Image(
                    image:
                        NetworkImage(Config.base_url + catList[i]["cat_img"]),
                    height: 30),
                SizedBox(width: Get.width * 0.02),
                Text(catList[i]["title"],
                    style: TextStyle(
                        fontFamily: 'Gilroy Medium',
                        color: notifire.textcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  imgloading() {
    return Container(
      height: Get.height * 0.20,
      width: Get.width * 0.62,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("image/skeleton.gif"), fit: BoxFit.fill)),
    );
  }

  tredingEvents(tEvent, i) {
    return InkWell(
      onTap: () {
        Get.to(() => EventsDetails(eid: tEvent[i]["event_id"]),
            duration: Duration.zero);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: notifire.bordercolore)),
          width: Get.width / 2 - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  //only borderRadius here
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),

                  child: SizedBox(
                    height: 120,
                    width: Get.width * 0.62,
                    child: FancyShimmerImage(
                      shimmerDuration: const Duration(seconds: 2),
                      imageUrl: Config.base_url + tEvent[i]["event_img"],
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  //   child: FadeInImage.assetNetwork(
                  //       fadeInCurve: Curves.easeInCirc,
                  //       placeholder: "image/skeleton.gif",
                  //       fit: BoxFit.cover,
                  //       image: Config.base_url + tEvent[i]["event_img"]),
                  // ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(tEvent[i]["event_title"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Gilroy Bold',
                        color: notifire.textcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  child: Text(
                      //address
                      tEvent[i]["event_address"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            ///This will close the dialog box when user taps outside the dialog box
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: Get.height * 0.5,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: notifire.backgrounde,
                              ),
                              child: GestureDetector(
                                ///This will prevent the dialog box to close when user taps inside the dialog box
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Ticket(eid: tEvent[i]["event_id"]),
                                ),
                              ),
                            ),
                          );
                        },
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff8cff9e),
                            // border:
                            //     Border.all(color: notifire.textcolor, width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Join Match",
                            style: TextStyle(
                                fontFamily: 'Gilroy Medium',
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  homeAppbar() {
    return Container(
      decoration: BoxDecoration(
          color: notifire.backgrounde, borderRadius: const BorderRadius.only()),
      height: Get.height * 0.14,
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.055),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: notifire.getwhitecolor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey.shade200,
                                child: Image.network(
                                  "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("Hey, ${getData.read("UserLogin")["name"]}".tr,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Bold',
                                  color: notifire.textcolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      //! ------ Notification Page -----
                      Get.to(() => const Note(), duration: Duration.zero);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(color: notifire.bordercolore)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.notifications,
                            color: notifire.textcolor, size: 25),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.015),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 22),
          //   child: InkWell(
          //     onTap: () {
          //       Get.to(() => const SearchPage2());
          //     },
          //     child: Row(
          //       children: [
          //         Image.asset("image/search.png", height: height / 30),
          //         SizedBox(width: width / 90),
          //         Container(width: 1, height: height / 40, color: Colors.grey),
          //         SizedBox(width: width / 90),
          //         //! ------ Search TextField -------
          //         Text(
          //           "Search...".tr,
          //           style: TextStyle(
          //               fontFamily: 'Gilroy Medium',
          //               color: const Color(0xffd2d2db),
          //               fontSize: 15),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  List<String> _mImages = [];

  // Widget monthly(mEvent, i) {
  //   _mImages.clear();
  //   mEvent[i]["member_list"].forEach((e) {
  //     _mImages.add(Config.base_url + e);
  //   });
  //   int mEventcount = int.parse(mEvent[i]["total_member_list"].toString()) > 3
  //       ? 3
  //       : int.parse(mEvent[i]["total_member_list"].toString());
  //   for (var i = 0; i < mEventcount; i++) {
  //     _mImages.add(Config.userImage);
  //   }
  //   return GestureDetector(
  //     onTap: () {
  //       Get.to(() => EventsDetails(eid: mEvent[i]["event_id"]),
  //           duration: Duration.zero);
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 14),
  //       child: Card(
  //         color: notifire.getprimerycolor,
  //         child: Container(
  //           decoration: BoxDecoration(
  //               color: notifire.getprimerycolor,
  //               borderRadius: const BorderRadius.all(Radius.circular(10))),
  //           height: height / 6.5,
  //           width: width,
  //           child: Row(
  //             children: [
  //               Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: 8, right: 8, bottom: 5, top: 5),
  //                     child: Row(
  //                       children: [
  //                         ClipRRect(
  //                           borderRadius:
  //                               const BorderRadius.all(Radius.circular(16)),
  //                           child: SizedBox(
  //                             width: width / 5,
  //                             height: height / 8,
  //                             child: FadeInImage.assetNetwork(
  //                                 fadeInCurve: Curves.easeInCirc,
  //                                 placeholder: "image/skeleton.gif",
  //                                 fit: BoxFit.cover,
  //                                 image:
  //                                     Config.base_url + mEvent[i]["event_img"]),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 6),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             SizedBox(
  //                               width: Get.width * 0.45,
  //                               child: Text(
  //                                 mEvent[i]["event_title"],
  //                                 maxLines: 1,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: TextStyle(
  //                                     fontFamily: 'Gilroy Medium',
  //                                     color: notifire.getdarkscolor,
  //                                     fontSize: 14,
  //                                     fontWeight: FontWeight.w600),
  //                               ),
  //                             ),
  //                             SizedBox(height: height / 100),
  //                             Row(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Image.asset("image/location.png",
  //                                     height: height / 50),
  //                                 SizedBox(width: Get.width * 0.01),
  //                                 SizedBox(
  //                                   width: Get.width * 0.45,
  //                                   child: Text(
  //                                     mEvent[i]["event_address"],
  //                                     maxLines: 2,
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                         fontFamily: 'Gilroy Medium',
  //                                         color: Colors.grey,
  //                                         fontSize: 10),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(height: height / 100),
  //                             mEvent[i]["total_member_list"] != "0"
  //                                 ? Row(
  //                                     children: [
  //                                       FlutterImageStack(
  //                                         totalCount: 0,
  //                                         itemRadius: 30,
  //                                         itemCount: 3,
  //                                         itemBorderWidth: 1.5,
  //                                         imageList: _mImages,
  //                                       ),
  //                                       SizedBox(width: Get.width * 0.01),
  //                                       Text(
  //                                           "${mEvent[i]["total_member_list"]} + Joined",
  //                                           style: TextStyle(
  //                                             color: const Color(0xffF0635A),
  //                                             fontSize: 12,
  //                                             fontFamily: 'Gilroy Bold',
  //                                           )),
  //                                     ],
  //                                   )
  //                                 : const SizedBox(),
  //                           ],
  //                         ),
  //                         SizedBox(height: height / 80)
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               // const Spacer(),
  //               Column(
  //                 children: [
  //                   SizedBox(height: height / 80),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                         color: notifire.getpinkcolor,
  //                         borderRadius:
  //                             const BorderRadius.all(Radius.circular(10))),
  //                     height: height / 12,
  //                     width: width / 10,
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Center(
  //                           child: SizedBox(
  //                             width: width / 11,
  //                             child: Text(
  //                               mEvent[i]["event_sdate"],
  //                               maxLines: 2,
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                   color: notifire.getdarkscolor,
  //                                   fontSize: 14,
  //                                   fontFamily: 'Gilroy Bold',
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(width: width / 40),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget rights(se, name1, name, img, txtcolor, ce) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(img, height: height / 15),
        SizedBox(width: width / 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name1,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gilroy Bold',
                  color: txtcolor),
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Gilroy Normal',
                  color: Colors.grey),
            ),
          ],
        ),
        se,
        ce
      ],
    );
  }

  Widget conference(nearby, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: () {
          Get.to(() => EventsDetails(eid: nearby[i]["event_id"]),
              duration: Duration.zero);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: notifire.containercolore,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: notifire.bordercolore)),
          height: height / 7,
          width: width,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 6, bottom: 5, top: 5),
            child: Row(children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: SizedBox(
                  width: width / 5,
                  height: height / 8,
                  child: FancyShimmerImage(
                    shimmerDuration: const Duration(seconds: 2),
                    imageUrl: Config.base_url + nearby[i]["event_img"],
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              Column(children: [
                SizedBox(height: height / 200),
                Row(
                  children: [
                    SizedBox(width: width / 50),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.35,
                                child: Text(
                                  nearby[i]["event_sdate"],
                                  style: const TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: Color(0xff4A43EC),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(width: width * 0.21),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100 / 2),
                                child: BackdropFilter(
                                  blendMode: BlendMode.srcIn,
                                  filter: ImageFilter.blur(
                                    sigmaX: 10, // mess with this to update blur
                                    sigmaY: 10,
                                  ),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.2),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: LikeButton(
                                        onTap: (val) {
                                          return onLikeButtonTapped(
                                              val, nearby[i]["event_id"]);
                                        },
                                        likeBuilder: (bool isLiked) {
                                          return nearby[i]["IS_BOOKMARK"] != 0
                                              ? const Icon(Icons.favorite,
                                                  color: Color(0xffF0635A),
                                                  size: 22)
                                              : const Icon(
                                                  Icons.favorite_border,
                                                  color: Color(0xffF0635A),
                                                  size: 22);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: Get.width * 0.55,
                            child: Text(nearby[i]["event_title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: notifire.textcolor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: height / 200),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "image/location.png",
                                  height: height / 50,
                                ),
                                SizedBox(width: Get.width * 0.01),
                                SizedBox(
                                  width: Get.width * 0.56,
                                  child: Text(
                                    nearby[i]["event_address"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        color: Colors.grey,
                                        fontSize: 10),
                                  ),
                                ),
                              ]),
                        ]),
                  ],
                ),
                SizedBox(height: height / 80),
              ])
            ]),
          ),
        ),
      ),
    );
  }

  //List<String> upMember = [];
  Widget events(upEvent, i) {
    // upMember.clear();
    // upEvent["member_list"].forEach((e) {
    //   upMember.add(Config.base_url + e);
    // });
    // int membercount = int.parse(upEvent["total_member_list"].toString()) > 3
    //     ? 3
    //     : int.parse(upEvent["total_member_list"].toString());
    // for (var i = 0; i < membercount; i++) {
    //   upMember.add(Config.userImage);
    // }
    return InkWell(
      onTap: () {
        Get.to(() => EventsDetails(eid: upEvent["event_id"]),
            duration: Duration.zero);
      },
      child: Container(
        color: Colors.transparent,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: notifire.bordercolore),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: width / 1.7,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: SizedBox(
                        height: Get.height * 0.20,
                        width: Get.width * 0.62,
                        child: FancyShimmerImage(
                          shimmerDuration: const Duration(seconds: 2),
                          imageUrl: Config.base_url + upEvent["event_img"],
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height / 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    width: Get.width,
                    child: Text(
                      upEvent["event_title"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Gilroy Bold',
                          color: notifire.textcolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    width: Get.width,
                    child: Text(
                      upEvent["event_address"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                ///This will close the dialog box when user taps outside the dialog box
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: Get.height * 0.5,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    color: notifire.backgrounde,
                                  ),
                                  child: GestureDetector(
                                    ///This will prevent the dialog box to close when user taps inside the dialog box
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Ticket(eid: upEvent["event_id"]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff8cff9e),
                                // border: Border.all(
                                //     color: notifire.textcolor, width: 1),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Join Match",
                                style: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: '$appName',
        text:
            'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code $code & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }

  walletrefar() async {
    var data = {"uid": uID};

    ApiWrapper.dataPost(Config.refardata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          code = val["code"];
        } else {
          setState(() {});
        }
      }
    });
  }
}

class SideCutsDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(width / 3 + 10, -1), radius: 18),
      0,
      3.14,
      true,
      Paint()..color = Colors.white,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(width / 3 + 10, 60), radius: 18),
      0,
      90,
      true,
      Paint()..color = Colors.white,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(width / 3 * 2 - 10, -1), radius: 18),
      0,
      3.14,
      true,
      Paint()..color = Colors.white,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(width / 3 * 2 - 10, 60), radius: 18),
      0,
      90,
      true,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    Path path = Path();
    path.lineTo(140, 0);
    var firstStart = Offset(100, -2);
    var firstEnd = Offset(140, 20);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    // var secondStart = Offset(160, -2);
    // var secondEnd = Offset(170, 20);
    // path.quadraticBezierTo(
    //     secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(160, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
