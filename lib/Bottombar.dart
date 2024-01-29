// ignore_for_file: avoid_print, deprecated_member_use, unnecessary_null_comparison, unnecessary_brace_in_string_interps, unused_element, file_names

import 'package:flutter/material.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/profile/profile.dart';
import 'package:goevent2/tournaments/tournaments.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({Key? key}) : super(key: key);

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  late ColorNotifire notifire;

  late int _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 2000;
  int _selectedIndex = 0;
  var isLogin = false;

  final _pageOption = [
    const Home(),
    //const SearchPage(),
    // const TicketStatusPage(),
    Tournaments(),
    //const Bookmark(),
    const Profile(""),
  ];

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    // isLogin = getdata.read("firstLogin") ?? false;
    setState(() {});
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

  Future<bool> _handleWillPop() async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        backgroundColor: notifire.backgrounde,
        // bottomNavigationBar: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     unselectedItemColor: notifire.bottommenucolore,
        //     backgroundColor: notifire.backgrounde,
        //     selectedLabelStyle: const TextStyle(
        //       fontFamily: 'Gilroy_Medium',
        //       fontWeight: FontWeight.w500,
        //     ),
        //     fixedColor: buttonColor,
        //     unselectedFontSize: 13,
        //     selectedFontSize: 13,
        //     unselectedLabelStyle:
        //         const TextStyle(fontFamily: 'Gilroy_Medium'),
        //     currentIndex: _selectedIndex,
        //     showSelectedLabels: true,
        //     showUnselectedLabels: true,
        //     items: [
        //       BottomNavigationBarItem(
        //           icon: Image.asset(Images.home,
        //               color: _selectedIndex == 0
        //                   ? buttonColor
        //                   : notifire.bottommenucolore,
        //               height: MediaQuery.of(context).size.height / 35),
        //           label: 'Home'.tr),
        //       // BottomNavigationBarItem(
        //       //     icon: Image.asset(Images.search, color: _selectedIndex == 1 ? buttonColor : notifire.bottommenucolore, height: MediaQuery.of(context).size.height / 33),
        //       //     label: 'Map'.tr),
        //       // BottomNavigationBarItem(
        //       //     icon: Image.asset(Images.calendar,
        //       //         color: _selectedIndex == 1
        //       //             ? buttonColor
        //       //             : notifire.bottommenucolore,
        //       //         height: MediaQuery.of(context).size.height / 35),
        //       //     label: 'My Bookings'.tr),
        //       BottomNavigationBarItem(
        //           icon: Image.asset("image/trophy.png",
        //               color: _selectedIndex == 1
        //                   ? buttonColor
        //                   : notifire.bottommenucolore,
        //               height: MediaQuery.of(context).size.height / 35),
        //           label: 'Tournaments'.tr),
        //
        //       BottomNavigationBarItem(
        //         icon: Image.asset(Images.user,
        //             color: _selectedIndex == 2
        //                 ? buttonColor
        //                 : notifire.bottommenucolore,
        //             height: MediaQuery.of(context).size.height / 35),
        //         label: 'Profile'.tr,
        //       ),
        //     ],
        //     onTap: (index) {
        //       setState(() {});
        //       _selectedIndex = index;
        //     }),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                              SizedBox(width: 5),
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
                                      ? notifire.getwhitecolor
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
        body: _pageOption[_selectedIndex],
      ),
    );
  }
}
