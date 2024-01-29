import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/notification/notification.dart';
import 'package:provider/provider.dart';

import '../Api/Config.dart';
import '../home/EventDetails.dart';
import '../home/home.dart';
import '../home/seeall.dart';
import '../utils/colornotifire.dart';

class Tournaments extends StatefulWidget {
  const Tournaments({Key? key}) : super(key: key);

  @override
  State<Tournaments> createState() => _TournamentsState();
}

class _TournamentsState extends State<Tournaments>
    with TickerProviderStateMixin {
  final hData = Get.put(HomeController());
  late ColorNotifire notifire;
  List<String> upMember = [];
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: ListView(
        children: [
          homeAppbar(),
          SizedBox(height: Get.height * 0.02),
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "image/trophy_page_bg.png",
                ),
              ),
            ),
          ),
          // SizedBox(height: Get.height * 0.02),
          // hData.trendingEvent.isNotEmpty
          //     ? Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: Row(
          //           children: [
          //             Text("Upcoming Tournaments".tr,
          //                 style: TextStyle(
          //                     fontFamily: 'Gilroy Bold',
          //                     color: notifire.textcolor,
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.w600)),
          //             const Spacer(),
          //             GestureDetector(
          //               onTap: () {
          //                 Get.to(
          //                     () => All(
          //                         title: "Upcoming Tournaments".tr,
          //                         eventList: hData.trendingEvent),
          //                     duration: Duration.zero);
          //               },
          //               child: Container(
          //                 color: Colors.transparent,
          //                 child: Row(
          //                   children: [
          //                     Text("See All".tr,
          //                         style: TextStyle(
          //                             fontFamily: 'Gilroy Medium',
          //                             color: const Color(0xff747688),
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w400)),
          //                     const Icon(Icons.arrow_forward_ios_rounded,
          //                         size: 14, color: Color(0xff747688)),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     : const SizedBox(),
          // SizedBox(height: Get.height * 0.03),

          // for (int i = 0; i < hData.trendingEvent.length; i++)
          //   tredingEvents(hData.trendingEvent, i),
          //! --------- trndingList ---------
        ],
      ),
    );
  }

  tredingEvents(tEvent, i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.to(() => EventsDetails(eid: tEvent[i]["event_id"]),
              duration: Duration.zero);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: Get.width * 0.60,
            height: Get.height * 0.27,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: SizedBox(
                    height: Get.height * 0.20,
                    width: Get.width,
                    child: FadeInImage.assetNetwork(
                        fadeInCurve: Curves.easeInCirc,
                        placeholder: "image/skeleton.gif",
                        fit: BoxFit.cover,
                        image: Config.base_url + tEvent[i]["event_img"]),
                  ),
                ),
                // Positioned(
                //   top: 8,
                //   right: Get.width * 0.02,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(100 / 2),
                //     child: BackdropFilter(
                //       blendMode: BlendMode.srcIn,
                //       filter: ImageFilter.blur(
                //         sigmaX: 10, // mess with this to update blur
                //         sigmaY: 10,
                //       ),
                //       child: CircleAvatar(
                //         radius: 18,
                //         backgroundColor: Colors.transparent,
                //         child: Padding(
                //           padding: const EdgeInsets.only(left: 3),
                //           child: LikeButton(
                //             onTap: (val) {
                //               return onLikeButtonTapped(
                //                   val, tEvent[i]["event_id"]);
                //             },
                //             likeBuilder: (bool isLiked) {
                //               return tEvent[i]["IS_BOOKMARK"] != 0
                //                   ? const Icon(Icons.favorite,
                //                       color: Color(0xffF0635A), size: 22)
                //                   : const Icon(Icons.favorite_border,
                //                       color: Color(0xffF0635A), size: 22);
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: Get.height * 0.12,
                      width: Get.width * 0.85,
                      decoration: BoxDecoration(
                          color: notifire.getprimerycolor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height * 0.01),
                            Ink(
                              width: Get.width * 0.7,
                              child: Text(tEvent[i]["event_title"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      color: notifire.textcolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(height: Get.height * 0.006),
                            Row(
                              children: [
                                Image.asset("image/location.png", height: 30),
                                SizedBox(width: Get.width * 0.01),
                                Ink(
                                  width: Get.width * 0.7,
                                  child: Text(tEvent[i]["event_address"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy Medium',
                                          color: Colors.grey,
                                          fontSize: 14)),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.008),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Container(
                            //       height: Get.height * 0.04,
                            //       width: Get.width * 0.30,
                            //       decoration: BoxDecoration(
                            //           color: Colors.black,
                            //           borderRadius: BorderRadius.circular(10)),
                            //       child: Center(
                            //         child: Text(
                            //           "Join as Team".tr,
                            //           maxLines: 1,
                            //           overflow: TextOverflow.ellipsis,
                            //           style: TextStyle(
                            //               fontFamily: 'Gilroy Bold',
                            //               color: Colors.white,
                            //               fontSize: 14),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
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
}
