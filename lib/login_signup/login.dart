// ignore_for_file: unused_local_variable, prefer_final_fields, avoid_function_literals_in_foreach_calls, unused_field, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goevent2/Api/ApiWrapper.dart';
import 'package:goevent2/Controller/AuthController.dart';
import 'package:goevent2/home/home.dart';
import 'package:goevent2/login_signup/resetpass.dart';
import 'package:goevent2/login_signup/signup.dart';
import 'package:goevent2/utils/botton.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:goevent2/utils/ctextfield.dart';
import 'package:goevent2/utils/itextfield.dart';
import 'package:goevent2/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final login = Get.put(AuthController());

  late ColorNotifire notifire;
  bool status = false;
  final number = TextEditingController();
  final password = TextEditingController();
  List<String> _countryCodes = [];
  String? dropdownValue = "";
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    dropdownValue = login.countryCode.first;

    getdarkmodepreviousstate();
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                SizedBox(height: height / 11),
                Center(
                    child: Image.asset(
                  "image/getevent.png",
                  height: height / 8,
                  color: Colors.black,
                )),
                SizedBox(height: height / 100),
                SizedBox(height: height / 30),
                Row(
                  children: [
                    Text(
                      "Sign in".tr,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy Medium',
                          color: notifire.getwhitecolor),
                    ),
                  ],
                ),
                SizedBox(height: height / 40),
                Ink(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: notifire.bordercolore)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 10),
                            Icon(Icons.call_outlined,
                                size: 20, color: notifire.textcolor),
                            cpicker(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Customtextfild.textField(
                          controller: number,
                          name1: "Mobile number".tr,
                          keyboardType: TextInputType.number,
                          labelclr: Colors.grey,
                          textcolor: notifire.getwhitecolor,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height / 40),
                Customtextfild2.textField(
                  password,
                  _obscureText,
                  "Password".tr,
                  Colors.grey,
                  notifire.getwhitecolor,
                  "image/Lock.png",
                  GestureDetector(
                      onTap: () {
                        _toggle();
                      },
                      child: _obscureText
                          ? Image.asset(
                              "image/Hide.png",
                              height: 20,
                              color: notifire.textcolor,
                            )
                          : Image.asset("image/Show.png",
                              height: 20, color: notifire.textcolor)),
                  context: context,
                ),
                SizedBox(height: height / 40),
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        activeColor: notifire.getbuttonscolor,
                        value: status,
                        onChanged: (value) {
                          setState(() {});
                          status = value;
                        },
                      ),
                    ),
                    SizedBox(width: width / 60),
                    Text("Remember Me".tr,
                        style: TextStyle(
                            color: notifire.getwhitecolor,
                            fontFamily: 'Gilroy Medium')),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const Resetpassword(),
                            duration: Duration.zero);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Forgot Password?".tr,
                            style: TextStyle(
                                color: notifire.getwhitecolor,
                                fontFamily: 'Gilroy Medium'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height / 20),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (number.text.isNotEmpty && password.text.isNotEmpty) {
                      login.userLogin(number.text, password.text);
                    } else {
                      ApiWrapper.showToastMessage(
                          "Please fill required field!");
                    }
                  },
                  child: SizedBox(
                    height: 56,
                    child: Custombutton.button1(
                      notifire.getbuttonscolor,
                      "SIGN IN".tr,
                      SizedBox(width: width / 4),
                      SizedBox(width: width / 7),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OR".tr,
                    style: TextStyle(
                        color: notifire.getwhitecolor,
                        fontSize: 20,
                        fontFamily: 'Gilroy Medium'),
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      child: Container(
                        width: Get.width / 1.3,
                        decoration: BoxDecoration(
                          color: notifire.getwhitecolor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "image/google.png",
                                height: 25,
                              ),
                              SizedBox(width: width / 20),
                              Text(
                                "Sign in with Google".tr,
                                style: TextStyle(
                                    color: notifire.getblackcolor,
                                    fontFamily: 'Gilroy Medium'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      child: Container(
                        width: Get.width / 1.3,
                        decoration: BoxDecoration(
                          color: notifire.getwhitecolor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "image/facebook.png",
                                height: 25,
                              ),
                              SizedBox(width: width / 20),
                              Text(
                                "Sign in with Facebook".tr,
                                style: TextStyle(
                                    color: notifire.getblackcolor,
                                    fontFamily: 'Gilroy Medium'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?".tr,
                        style: TextStyle(
                            color: notifire.getwhitecolor,
                            fontSize: 12,
                            fontFamily: 'Gilroy Medium')),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const Signup(), duration: Duration.zero);
                      },
                      child: Text(
                        "Sign up".tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy Medium',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget log(clr, name, img, clr2) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.to(() => const Home(), duration: Duration.zero);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: clr),
          height: height / 15,
          width: width / 1.5,
          child: Row(
            children: [
              SizedBox(width: width / 10),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Image.asset(img)),
              SizedBox(width: width / 20),
              Text(
                name,
                style: TextStyle(
                    color: clr2,
                    fontFamily: 'Gilroy Medium',
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cpicker() {
    var countryDropDown = Ink(
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: notifire.getprimerycolor,
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                value: dropdownValue,
                items: login.countryCode.map((value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString(),
                          style: TextStyle(
                              fontSize: 14.0, color: notifire.getwhitecolor)));
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
      ),
    );
    return countryDropDown;
  }
}
