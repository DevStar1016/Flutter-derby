// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_label, prefer_final_fields, unused_local_variable, curly_braces_in_flow_control_structures, prefer_const_constructors, avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
//import 'package:goevent2/agent_chat_screen/chat_screen.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/home/ticket.dart';
import 'package:goevent2/profile/profile.dart';
import 'package:goevent2/tournaments/tournaments.dart';
import 'package:goevent2/utils/AppWidget.dart';
import 'package:goevent2/utils/media.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';

// done

late ColorNotifire notifire;

class EventsDetails extends StatefulWidget {
  final String? eid;
  const EventsDetails({Key? key, this.eid}) : super(key: key);

  @override
  _EventsDetailsState createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  // final event = Get.put(HomeController());

  final _pageOption = [
    const Home(),
    //const SearchPage(),
    // const TicketStatusPage(),
    Tournaments(),
    //const Bookmark(),
    const Profile(""),
  ];

  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  var eventData;
  String code = "0";
  List event_gallery = [];
  List event_sponsore = [];
  bool isloading = false;
  int _selectedIndex = 4;

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
    getPackage();

    eventDetailApi();
    getdarkmodepreviousstate();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  eventDetailApi() {
    // int userCount = 0;
    isloading = true;

    var data = {"eid": widget.eid, "uid": uID};
    ApiWrapper.dataPost(Config.eventdataApi, data).then((val) {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["EventData"].forEach((e) {
            eventData = e;
          });
          event_gallery = val["Event_gallery"];
          event_sponsore = val["Event_sponsore"];
          // eventData["member_list"]!.forEach((e) {
          //   _images.add(Config.base_url + e);
          // });
          // for (var i = 0; i < val["EventData"].length; i++)
          //   userCount =
          //       int.parse(val["EventData"][i]["total_member_list"].toString()) >
          //               3
          //           ? 3
          //           : int.parse(
          //               val["EventData"][i]["total_member_list"].toString());
          // for (var i = 0; i < userCount; i++) {
          //   _images.add(Config.userImage);
          // }
          isloading = false;
        } else {
          isloading = false;
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  //! ----- LikeButtonTapped -----
  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          eventDetailApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }

  List<String> _images = [];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: notifire.backgrounde,
      appBar: AppBar(
        backgroundColor: notifire.backgrounde,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: notifire.textcolor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.arrow_back,
                  color: notifire.getblackcolor,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Match Details",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Gilroy Medium',
              color: notifire.textcolor),
        ),
      ),
      // floatingActionButton: SizedBox(
      //   height: 45,
      //   width: 410,
      //   child: !isloading
      //       ? FloatingActionButton(
      //           onPressed: () {
      //             showModalBottomSheet(
      //               context: context,
      //               builder: (BuildContext context) {
      //                 return GestureDetector(
      //                   ///This will close the dialog box when user taps outside the dialog box
      //                   onTap: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                   child: Container(
      //                     height: Get.height * 0.5,
      //                     width: Get.width,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.only(
      //                           topLeft: Radius.circular(20),
      //                           topRight: Radius.circular(20)),
      //                       color: notifire.backgrounde,
      //                     ),
      //                     child: GestureDetector(
      //                       ///This will prevent the dialog box to close when user taps inside the dialog box
      //                       onTap: () {},
      //                       child: Padding(
      //                         padding: const EdgeInsets.only(top: 16),
      //                         child: Ticket(eid: eventData["event_id"]),
      //                       ),
      //                     ),
      //                   ),
      //                 );
      //               },
      //               isScrollControlled: true,
      //               backgroundColor: Colors.transparent,
      //             );
      //
      //             // Get.to(() => Ticket(eid: eventData["event_id"]),
      //             //     duration: Duration.zero);
      //           },
      //           child: Custombutton.button1(
      //             notifire.getbuttonscolor,
      //             "JOIN MATCH".tr,
      //             SizedBox(width: width / 15),
      //             SizedBox(width: width / 15),
      //           ),
      //         )
      //       : const SizedBox(),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: !isloading
          ? CustomScrollView(
              slivers: [
                // SliverPersistentHeader(
                //   pinned: true,
                //   floating: true,
                //   delegate: MySliverAppBar(
                //       expandedHeight: 200.0,
                //       eventData: eventData,
                //       images: _images,
                //       share: share),
                // ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 120),
                      Container(
                        height: 560,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        eventData["event_title"] ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Gilroy Medium',
                                            color: notifire.textcolor),
                                      ),
                                      SizedBox(height: 15),
                                      // Row(
                                      //   children: [
                                      //     RatingBar.builder(
                                      //       initialRating: 4.5,
                                      //       minRating: 1,
                                      //       direction: Axis.horizontal,
                                      //       allowHalfRating: true,
                                      //       itemSize: 15,
                                      //       itemCount: 5,
                                      //       itemPadding: EdgeInsets.symmetric(
                                      //           horizontal: 0.0),
                                      //       itemBuilder: (context, _) => Icon(
                                      //         Icons.star,
                                      //         color: Colors.amber,
                                      //       ),
                                      //       onRatingUpdate: (rating) {
                                      //         print(rating);
                                      //       },
                                      //     ),
                                      //     SizedBox(width: 5),
                                      //     Text(
                                      //       "(43)",
                                      //       style: TextStyle(
                                      //           fontSize: 12,
                                      //           fontWeight: FontWeight.w500,
                                      //           fontFamily: 'Gilroy Medium',
                                      //           color: notifire.textcolor),
                                      //     ),
                                      //   ],
                                      // ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Icon(Icons.timer_sharp,
                                              color: notifire.textcolor
                                                  .withOpacity(0.5),
                                              size: 15),
                                          SizedBox(width: 5),
                                          Text(
                                            eventData["event_time_day"] ?? "",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Gilroy Medium',
                                                color: notifire.textcolor
                                                    .withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: notifire.textcolor
                                                  .withOpacity(0.5),
                                              size: 15),
                                          SizedBox(width: 5),
                                          Text(
                                            eventData["event_address_title"] ??
                                                "",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Gilroy Medium',
                                                color: notifire.textcolor
                                                    .withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      InkWell(
                                        child: Row(
                                          children: [
                                            Icon(Icons.directions,
                                                color: notifire.textcolor
                                                    .withOpacity(0.5),
                                                size: 15),
                                            SizedBox(width: 5),
                                            Text(
                                              "Get Direction",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Gilroy Medium',
                                                  color: notifire.textcolor
                                                      .withOpacity(0.5)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return GestureDetector(
                                                    ///This will close the dialog box when user taps outside the dialog box
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      height: Get.height * 0.5,
                                                      width: Get.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20)),
                                                        color: notifire
                                                            .backgrounde,
                                                      ),
                                                      child: GestureDetector(
                                                        ///This will prevent the dialog box to close when user taps inside the dialog box
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 16),
                                                          child: Ticket(
                                                              eid: eventData[
                                                                  "event_id"]),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                              );

                                              // Get.to(() => Ticket(eid: eventData["event_id"]),
                                              //     duration: Duration.zero);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "JOIN MATCH",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'Gilroy Medium',
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.add,
                                                  color: notifire.getblackcolor,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Align(
                                alignment: AlignmentGeometry.lerp(
                                    FractionalOffset(-0.0, 0.0),
                                    FractionalOffset(0, -0.03),
                                    0.5)!,
                                child: Container(
                                  height: 380,
                                  child: CustomPaint(
                                    size: Size(Get.width, 320),
                                    painter: RPSCustomPainter(),
                                    child: SizedBox(
                                      height: 330,
                                      width: Get.width,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              //Take from x and y
                              alignment: AlignmentGeometry.lerp(
                                  FractionalOffset(0.0, 0.0),
                                  FractionalOffset(0.95, 0.976),
                                  0.5)!,

                              child: Container(
                                height: 25,
                                width: 120,
                                color: notifire.backgrounde,
                              ),
                            ),
                            Align(
                              alignment: AlignmentGeometry.lerp(
                                  FractionalOffset(0.0, 0.0),
                                  FractionalOffset(0.87, 0.03),
                                  0.5)!,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 4),
                                child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: FancyShimmerImage(
                                        errorWidget: Icon(
                                          Icons.person,
                                          size: 150,
                                          color: notifire.textcolor,
                                        ),
                                        boxFit: BoxFit.cover,
                                        imageUrl: Config.base_url +
                                            eventData["event_cover_img"][0],
                                        shimmerBaseColor: Colors.black12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),
                      //! -------international-------
                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 18),
                      //       child: SizedBox(
                      //         width: Get.width * 0.90,
                      //         child: Text(
                      //           eventData["event_title"] ?? "",
                      //           maxLines: 2,
                      //           overflow: TextOverflow.ellipsis,
                      //           style: TextStyle(
                      //               fontSize: 28,
                      //               fontWeight: FontWeight.w500,
                      //               fontFamily: 'Gilroy Medium',
                      //               color: notifire.textcolor),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(height: height / 50),
                      //     concert(
                      //         "image/date.png",
                      //         eventData["event_sdate"] ?? "",
                      //         eventData["event_time_day"] ?? ""),
                      //     SizedBox(height: height / 50),
                      //     concert(
                      //         "image/direction.png",
                      //         eventData["event_address_title"] ?? "",
                      //         eventData["event_address"] ?? ""),
                      //     SizedBox(height: height / 60),
                      //
                      //     //! -------- Event_sponsore List ------
                      //
                      //     // ListView.builder(
                      //     //   padding: EdgeInsets.zero,
                      //     //   itemCount: event_sponsore.length,
                      //     //   physics: const NeverScrollableScrollPhysics(),
                      //     //   shrinkWrap: true,
                      //     //   itemBuilder: (ctx, i) {
                      //     //     return sponserList(event_sponsore, i);
                      //     //   },
                      //     // ),
                      //
                      //     SizedBox(height: height / 50),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 20),
                      //       child: Row(
                      //         children: [
                      //           Text("Details".tr,
                      //               style: TextStyle(
                      //                   fontSize: 17,
                      //                   fontWeight: FontWeight.w700,
                      //                   fontFamily: 'Gilroy Medium',
                      //                   color: notifire.textcolor)),
                      //         ],
                      //       ),
                      //     ),
                      //     SizedBox(height: height / 40),
                      //     //! About Event
                      //     Ink(
                      //       width: Get.width * 0.97,
                      //       child: Padding(
                      //           padding:
                      //               const EdgeInsets.only(left: 20, right: 20),
                      //           child: HtmlWidget(
                      //             eventData["event_about"] ?? "",
                      //             textStyle: TextStyle(
                      //                 fontWeight: FontWeight.w400,
                      //                 color: notifire.textcolor,
                      //                 fontSize: 12,
                      //                 fontFamily: 'Gilroy Medium'),
                      //           )),
                      //     ),
                      //     event_gallery.isNotEmpty
                      //         ? SizedBox(height: height / 50)
                      //         : const SizedBox(),
                      //     event_gallery.isNotEmpty
                      //         ? Padding(
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 16),
                      //             child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Text("Gallery".tr,
                      //                     style: TextStyle(
                      //                         fontSize: 17,
                      //                         fontWeight: FontWeight.w700,
                      //                         fontFamily: 'Gilroy Medium',
                      //                         color: notifire.textcolor)),
                      //                 InkWell(
                      //                   onTap: () {
                      //                     Get.to(() => GalleryView(
                      //                           list: event_gallery,
                      //                         ));
                      //                     setState(() {});
                      //                   },
                      //                   child: Row(
                      //                     children: [
                      //                       Text("View All".tr,
                      //                           style: TextStyle(
                      //                               fontSize: 13,
                      //                               fontWeight: FontWeight.w700,
                      //                               fontFamily: 'Gilroy Medium',
                      //                               color: const Color(
                      //                                   0xff747688))),
                      //                       const Icon(
                      //                           Icons.keyboard_arrow_right,
                      //                           color: Color(0xff747688))
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           )
                      //         : const SizedBox(),
                      //     event_gallery.isNotEmpty
                      //         ? SizedBox(height: height / 40)
                      //         : const SizedBox(),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 20),
                      //       child: Ink(
                      //         height: Get.height * 0.14,
                      //         width: Get.width,
                      //         child: ListView.builder(
                      //           itemCount: event_gallery.length,
                      //           shrinkWrap: true,
                      //           scrollDirection: Axis.horizontal,
                      //           itemBuilder: (ctx, i) {
                      //             return galeryEvent(event_gallery, i);
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //     event_gallery.isNotEmpty
                      //         ? SizedBox(height: Get.height * 0.10)
                      //         : const SizedBox(),
                      //   ],
                      // ),
                      // SizedBox(height: 90),
                    ],
                  ),
                ),
              ],
            )
          : isLoadingCircular(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
              color: notifire.homecontainercolore,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          height: 60,
          child: Stack(
            children: [
              // CustomPaint(
              //   size: Size(Get.width, 80),
              //   painter: SideCutsDesign(),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                        Get.to(() => const Tournaments());
                      });
                    },
                    child: FittedBox(
                      child: Container(
                        height: 60,
                        width: 134,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: _selectedIndex == 1
                                      ? notifire.getblackcolor
                                      : notifire.getwhitecolor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: Icon(
                                Icons.calendar_today,
                                color: _selectedIndex == 1
                                    ? notifire.getwhitecolor
                                    : notifire.getblackcolor,
                              ),
                            ),
                            Text("Tournaments",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                        Get.to(() => const Home());
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? notifire.getblackcolor
                            : notifire.getwhitecolor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: Image.asset(
                        'image/getevent.png',
                        color: _selectedIndex == 0
                            ? notifire.getwhitecolor
                            : notifire.getblackcolor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                        Get.to(() => const Profile(""));
                      });
                    },
                    child: FittedBox(
                      child: Container(
                        height: 60,
                        width: 134,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                            SizedBox(width: 10),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: _selectedIndex == 2
                                      ? notifire.getblackcolor
                                      : notifire.getwhitecolor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: Icon(
                                Icons.person,
                                color: _selectedIndex == 2
                                    ? notifire.bottommenucolore
                                    : notifire.getblackcolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  galeryEvent(gEvent, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: Get.width * 0.28,
        decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
                image: NetworkImage(Config.base_url + gEvent[i]),
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget concert(img, name1, name2) {
    return Row(children: [
      Container(
        height: height / 15,
        width: width / 7,
        decoration: BoxDecoration(
            color: notifire.getcardcolor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Image.asset(
            img,
            color: Colors.black,
          ),
        ),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name1,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy Medium',
                color: notifire.textcolor)),
        SizedBox(height: 5),
        Ink(
          width: Get.width * 0.705,
          child: Text(name2,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy Medium',
                  color: Colors.grey)),
        ),
      ])
    ]);
  }

  sponserList(eventSponsore, i) {
    print(eventSponsore[i]);
    return ListTile(
      onTap: () {
        print(eventSponsore[i]);
        // Get.to(ChatPage(
        //     resiverUserId: "1",
        //     resiverUseremail: 'admin',
        //     proPic: eventSponsore[i]["sponsore_img"]));
      },
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: notifire.getcardcolor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: NetworkImage(
                    Config.base_url + eventSponsore[i]["sponsore_img"]),
                fit: BoxFit.fill)),
        // child: Image(image: NetworkImage(Config.base_url + eventSponsore[i]["sponsore_img"])),
      ),
      title: Transform.translate(
        offset: Offset(-10, 0),
        child: Text(eventSponsore[i]["sponsore_title"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy Medium',
                color: notifire.textcolor)),
      ),
      subtitle: Transform.translate(
        offset: Offset(-10, 0),
        child: Text("Referee",
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy Medium',
                color: Colors.grey)),
      ),
      trailing: Container(
          height: height / 29,
          width: width / 6,
          // padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xffE3E1E1FF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
              child: Text('Chat',
                  style: TextStyle(color: Colors.black, fontSize: 10)))),
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

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  var eventData;
  var share;
  var images;

  MySliverAppBar(
      {required this.expandedHeight,
      required this.eventData,
      required this.images,
      required this.share});
  late ColorNotifire notifire;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        CarouselSlider(
          options: CarouselOptions(height: height / 4),
          items: eventData != null
              ? eventData["event_cover_img"].map<Widget>((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: Get.width,
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: FadeInImage.assetNetwork(
                            fadeInCurve: Curves.easeInCirc,
                            placeholder: "image/skeleton.gif",
                            fit: BoxFit.cover,
                            image: Config.base_url + i),
                      );
                    },
                  );
                }).toList()
              : [].map<Widget>((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          child: Image.network(Config.base_url + i,
                              fit: BoxFit.fill));
                    },
                  );
                }).toList(),
          // ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Container(
              height: 60,
              color: notifire.containercolore,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: notifire.textcolor,
                        )),
                    Spacer(),
                    Text(
                      "Match Details".tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.textcolor),
                    ),
                    Spacer(flex: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 45 - shrinkOffset,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Match Details".tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: Colors.white),
                    ),
                  ],
                ),
                // SizedBox(height: height / 20),
                SizedBox(height: height / 7.5),
                Center(
                  child: SizedBox(
                    width: width / 1.4,
                    height: height / 14,
                    child: Card(
                      // color: notifire.getprimerycolor,
                      color: notifire.containercolore,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Row(
                        mainAxisAlignment: eventData["total_member_list"] != "0"
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          SizedBox(width: Get.width * 0.01),
                          eventData["total_member_list"] != "0"
                              ? FlutterImageStack(
                                  totalCount: 0,
                                  itemRadius: 30,
                                  itemCount: 3,
                                  itemBorderWidth: 1.5,
                                  imageList: images)
                              : const SizedBox(),
                          SizedBox(width: Get.width * 0.01),
                          eventData["total_member_list"] != "0"
                              ? Builder(builder: (context) {
                                  print(
                                      "+++++***********-------${Config.userImage}");
                                  return Text(
                                    "${eventData["total_member_list"]} + Going",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Gilroy Bold'),
                                  );
                                })
                              : const SizedBox(),
                          eventData["total_member_list"] != "0"
                              ? SizedBox(width: width / 14)
                              : const SizedBox(),
                          InkWell(
                            onTap: share,
                            child: Container(
                              height: height / 29,
                              width: width / 6,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: Text("Invite".tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'Gilroy Bold')),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class CustomDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    Path path = Path();
    path.lineTo(width / 3, height);
    path.quadraticBezierTo(
        width / 3 + height / 2, height / 2, width / 3, height / 3);
    path.lineTo(width / 3, height);
    // path.lineTo(0, height - 100);
    // path.quadraticBezierTo(50, 0, 100, height - 100);
    // path.quadraticBezierTo(150, height, 200, height - 100);
    // path.quadraticBezierTo(250, 0, 300, height - 100);
    // path.quadraticBezierTo(350, height, 400, height - 100);
    //
    // path.lineTo(width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomDesign oldClipper) => false;
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1766822, size.height * 0.3053441);
    path_0.cubicTo(
        size.width * 0.1766822,
        size.height * 0.1517104,
        size.width * 0.2997477,
        size.height * 0.02716570,
        size.width * 0.4515568,
        size.height * 0.02716570);
    path_0.cubicTo(
        size.width * 0.6033658,
        size.height * 0.02716570,
        size.width * 0.7264314,
        size.height * 0.1517104,
        size.width * 0.7264314,
        size.height * 0.3053441);
    path_0.cubicTo(
        size.width * 0.7264314,
        size.height * 0.4262794,
        size.width * 0.6501761,
        size.height * 0.5291902,
        size.width * 0.5436715,
        size.height * 0.5675179);
    path_0.cubicTo(
        size.width * 0.4662826,
        size.height * 0.6093593,
        size.width * 0.4842030,
        size.height * 0.6678942,
        size.width * 0.5810308,
        size.height * 0.6952034);
    path_0.lineTo(size.width * 0.5842152, size.height * 0.6952034);
    path_0.lineTo(size.width * 0.5842152, size.height * 0.6960825);
    path_0.cubicTo(
        size.width * 0.5851425,
        size.height * 0.6963331,
        size.width * 0.5860767,
        size.height * 0.6965808,
        size.width * 0.5870179,
        size.height * 0.6968257);
    path_0.lineTo(size.width * 0.5842152, size.height * 0.6968257);
    path_0.lineTo(size.width * 0.5842152, size.height * 0.7532409);
    path_0.lineTo(size.width * 0.3237212, size.height * 0.7532409);
    path_0.lineTo(size.width * 0.3237212, size.height * 0.6968257);
    path_0.lineTo(size.width * 0.3208685, size.height * 0.6968257);
    path_0.cubicTo(
        size.width * 0.3218268,
        size.height * 0.6965696,
        size.width * 0.3227777,
        size.height * 0.6963109,
        size.width * 0.3237212,
        size.height * 0.6960497);
    path_0.lineTo(size.width * 0.3237212, size.height * 0.6952034);
    path_0.lineTo(size.width * 0.3267214, size.height * 0.6952034);
    path_0.cubicTo(
        size.width * 0.4251241,
        size.height * 0.6669264,
        size.width * 0.4404911,
        size.height * 0.6105468,
        size.width * 0.3658462,
        size.height * 0.5697324);
    path_0.cubicTo(
        size.width * 0.2560075,
        size.height * 0.5332855,
        size.width * 0.1766822,
        size.height * 0.4286899,
        size.width * 0.1766822,
        size.height * 0.3053442);
    path_0.lineTo(size.width * 0.1766822, size.height * 0.3053441);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    //paint_0_stroke.color = Color(0xff000000).withOpacity(1);
    paint_0_stroke.color = Colors.black;
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    //paint_0_fill.color = Color(0xfffefefe).withOpacity(1.0);
    paint_0_fill.color = notifire.backgrounde;
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
