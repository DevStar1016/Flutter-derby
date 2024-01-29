// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Api/Config.dart';
import 'package:goevent2/AppModel/Homedata/HomedataController.dart';
import 'package:goevent2/home/EventDetails.dart';
import 'package:goevent2/home/ticket.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colornotifire.dart';
import '../utils/media.dart';

class All extends StatefulWidget {
  final String? title;
  final List? eventList;
  const All({Key? key, this.title, this.eventList}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  List<String> _images = [];

  final hData = Get.put(HomeController());

  bool selected = false;

  late ColorNotifire notifire;

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
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: ListView(
        children: [
          SizedBox(height: height / 16),
          //! -------- AppBar --------
          Row(
            children: [
              SizedBox(width: width / 20),
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, color: notifire.textcolor)),
              SizedBox(width: width / 80),
              Text(
                widget.title!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Gilroy Medium',
                    color: notifire.textcolor),
              ),
            ],
          ),
          MasonryView(
            listOfItem: widget.eventList!,
            numberOfColumn: 2,
            itemPadding: 0,
            itemBuilder: (item) {
              return InkWell(
                onTap: () {
                  Get.to(() => EventsDetails(eid: item["event_id"]),
                      duration: Duration.zero);
                },
                child: Container(
                  color: Colors.transparent,
                  width: width / 2.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
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
                              width: width / 1.6,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                child: SizedBox(
                                  height: Get.height * 0.20,
                                  width: Get.width * 0.62,
                                  child: FancyShimmerImage(
                                    shimmerDuration: const Duration(seconds: 2),
                                    imageUrl:
                                        Config.base_url + item["event_img"],
                                    boxFit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height / 40),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              width: Get.width,
                              child: Text(
                                item["event_title"],
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              width: Get.width,
                              child: Text(
                                item["event_address"],
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
                                                  topRight:
                                                      Radius.circular(20)),
                                              color: notifire.backgrounde,
                                            ),
                                            child: GestureDetector(
                                              ///This will prevent the dialog box to close when user taps inside the dialog box
                                              onTap: () {},
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Ticket(
                                                    eid: item["event_id"]),
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
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: width / height / 0.65,
          //   ),
          //   itemBuilder: (ctx, i) {
          //     return events(widget.eventList, i);
          //   },
          //   itemCount: widget.eventList!.length,
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          // ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget events(user, i) {
    _images.clear();
    // user[i]["member_list"].forEach((e) {
    //   _images.add(Config.base_url + e);
    // });
    // int mEventcount = int.parse(user[i]["total_member_list"].toString()) > 3
    //     ? 3
    //     : int.parse(user[i]["total_member_list"].toString());
    // for (var i = 0; i < mEventcount; i++) {
    //   _images.add(Config.userImage);
    // }

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => EventsDetails(eid: user[i]["event_id"]),
                duration: Duration.zero);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: notifire.containercolore,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: notifire.bordercolore)),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 140,
                        width: width / 2,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.transparent),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: SizedBox(
                                height: height / 3.5,
                                width: width,
                                child: FadeInImage.assetNetwork(
                                    fadeInCurve: Curves.easeInCirc,
                                    placeholder: "image/skeleton.gif",
                                    fit: BoxFit.cover,
                                    image:
                                        Config.base_url + user[i]["event_img"]),
                              ),
                            ),
                            SizedBox(height: height / 70)
                          ],
                        ),
                      ),
                      SizedBox(height: height / 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          user[i]["event_title"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: notifire.textcolor,
                              fontSize: 15,
                              fontFamily: 'Gilroy Medium',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: height / 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("image/location.png",
                                height: height / 40),
                            const SizedBox(width: 2),
                            Ink(
                              width: Get.width * 0.30,
                              child: Text(
                                user[i]["event_address"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height / 70),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        child: Row(
                          children: [
                            user[i]["total_member_list"] != "0"
                                ? Row(
                                    children: [
                                      FlutterImageStack(
                                          totalCount: 0,
                                          itemRadius: 30,
                                          itemCount: 3,
                                          itemBorderWidth: 1.5,
                                          imageList: _images),
                                      SizedBox(width: Get.width * 0.01),
                                      Text(
                                        "${user[i]["total_member_list"]} + Going",
                                        style: TextStyle(
                                            color: const Color(0xff5d56f3),
                                            fontSize: 11,
                                            fontFamily: 'Gilroy Bold'),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const Spacer(),
                            // CircleAvatar(
                            //   radius: 18,
                            //   backgroundColor: Colors.grey.shade200,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(left: 3),
                            //     child: LikeButton(
                            //       onTap: (val) {
                            //         return onLikeButtonTapped(
                            //             val, user[i]["event_id"]);
                            //       },
                            //       likeBuilder: (bool isLiked) {
                            //         return !isLiked
                            //             ? const Icon(Icons.favorite,
                            //                 color: Color(0xffF0635A),
                            //                 size: 24)
                            //             : const Icon(Icons.favorite_border,
                            //                 color: Color(0xffF0635A),
                            //                 size: 24);
                            //       },
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> onLikeButtonTapped(isLiked, eid) async {
    var data = {"eid": eid, "uid": uID};
    ApiWrapper.dataPost(Config.ebookmark, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          // bookMarkListApi();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
    return !isLiked;
  }
}
